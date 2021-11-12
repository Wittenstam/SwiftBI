//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-12.
//

import SwiftUI

public struct PieChart: View {
     
    var title: String
    var dataUnit: String
    var data: [PieChartData]
    var separatorColor: Color
    var accentColors: [Color]
    
    @State  private var currentValue = ""
    @State  private var currentLabel = ""
    @State  private var touchLocation: CGPoint = .init(x: -1, y: -1)
    
    public init(title: String, dataUnit: String, data: [PieChartData], separatorColor: Color, accentColors: [Color]) {
        self.title = title
        self.dataUnit = dataUnit
        self.data = data
        self.separatorColor = separatorColor
        self.accentColors = accentColors
    }
    
    var pieSlices: [PieSlice] {
        var slices = [PieSlice]()
        data.enumerated().forEach {(index, data) in
            let value = normalizedValue(index: index, data: self.data)
            if slices.isEmpty    {
                slices.append((.init(startDegree: 0, endDegree: value * 360)))
            } else {
                slices.append(.init(startDegree: slices.last!.endDegree,    endDegree: (value * 360 + slices.last!.endDegree)))
            }
        }
        return slices
    }
    
    private var gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    

    public var body: some View {
        VStack {
            Text(title)
                .bold()
                .font(.largeTitle)
            ZStack {
                GeometryReader { geometry in
                    ZStack  {
                        ForEach(0..<self.data.count){ i in
                            PieChartSlice(center: CGPoint(x: geometry.frame(in: .local).midX, y: geometry.frame(in:  .local).midY), radius: min(geometry.frame(in: .local).maxX - geometry.frame(in: .local).midX,geometry.frame(in: .local).maxY - geometry.frame(in: .local).midY), startDegree: pieSlices[i].startDegree, endDegree: pieSlices[i].endDegree, isTouched: sliceIsTouched(index: i, inPie: geometry.frame(in:  .local)), accentColor: accentColors[i], separatorColor: separatorColor)
                        }
                    }
                        .gesture(DragGesture(minimumDistance: 0)
                                .onChanged({ position in
                                    let pieSize = geometry.frame(in: .local)
                                    touchLocation   =   position.location
                                    updateCurrentValue(inPie: pieSize)
                                })
                                .onEnded({ _ in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        withAnimation(Animation.easeOut) {
                                            resetValues()
                                        }
                                    }
                                })
                        )
                }
                    .aspectRatio(contentMode: .fit)
                VStack  {
                    if !currentLabel.isEmpty   {
                        Text(currentLabel)
                            .font(.caption)
                            .bold()
                            .foregroundColor(.black)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                    }
                    
                    if !currentValue.isEmpty {
                        Text("\(currentValue) \(dataUnit)")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.black)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                    }
                }
                .padding()
            }
            LazyVGrid(columns: gridItemLayout, alignment: .leading, spacing: 10) {
                ForEach(0..<data.count)   {    i in
                    HStack {
                        accentColors[i]
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 0, maxWidth: 20, minHeight: 20)
                            .padding(5)
                        Text(data[i].label)
                            .font(.caption)
                            .bold()
                    }
                }
            }
        }
            .padding()
    }


    func updateCurrentValue(inPie   pieSize:    CGRect)  {
        guard let angle = angleAtTouchLocation(inPie: pieSize, touchLocation: touchLocation)    else    {return}
        let currentIndex = pieSlices.firstIndex(where: { $0.startDegree < angle && $0.endDegree > angle }) ?? -1
         
        currentLabel = data[currentIndex].label
        currentValue = "\(data[currentIndex].value)"
     }
    
    
    func resetValues() {
        currentValue = ""
        currentLabel = ""
        touchLocation = .init(x: -1, y: -1)
    }
    
    
    func sliceIsTouched(index: Int, inPie pieSize: CGRect) -> Bool {
        guard let angle =   angleAtTouchLocation(inPie: pieSize, touchLocation: touchLocation) else { return false }
        return pieSlices.firstIndex(where: { $0.startDegree < angle && $0.endDegree > angle }) == index
    }
    
}

struct PieChart_Previews: PreviewProvider {
     static var previews: some View {
         Group {
             PieChart(title: "Montly Sales", dataUnit: "SEK", data: pieChartDataSet, separatorColor: Color.background, accentColors: pieColors)
         }
     }
 }