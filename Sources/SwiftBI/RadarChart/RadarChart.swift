//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-10.
//

import SwiftUI

public struct RadarChart: View {

    var title: String
    let gridColor: Color
    let dataColor: Color
    var dataUnit: String
    var legend: String
    var data: [RadarChartData]
    let maxValue: Double
    let divisions: Int
    
    @State private var currentValue = ""
    @State private var currentLabel = ""
    @State  private var touchLocation: CGPoint = .init(x: -1, y: -1)
  
    public init(title: String, gridColor: Color = .gray, dataColor: Color = .purple, dataUnit: String, legend: String,  data: [RadarChartData], maxValue: Double = 0, divisions: Int = 10) {
        self.title = title
        self.gridColor = gridColor
        self.dataColor = dataColor
        self.dataUnit = dataUnit
        self.legend = legend
        self.data = data
        self.maxValue = maxValue
        self.divisions = divisions
    }
    
    var pieSlices: [PieSlice] {
        var slices = [PieSlice]()
        let value = Double(360) / Double(data.count)
        data.enumerated().forEach {(index, data) in
            //let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY)
            
            if slices.isEmpty {
                var endValue = (Double(270) + Double(value/2))
                endValue = endValue.truncatingRemainder(dividingBy: 360)
                if (endValue < 0) {
                    endValue += 360;
                }
                slices.append((.init(startDegree: (Double(270)-(value/2)), endDegree: endValue )))
                
            } else {
                var endValue = (Double(value) + slices.last!.endDegree)
                endValue = endValue.truncatingRemainder(dividingBy: 360)
                if (endValue < 0) {
                    endValue += 360;
                }
                slices.append(.init(startDegree: slices.last!.endDegree, endDegree: endValue))
            }
        }
        return slices
    }
  
    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
                .font(.largeTitle)
//            Text("Current value: \(currentValue) \(dataUnit)")
//                .font(.headline)
            GeometryReader { geometry in
                VStack {
                    ZStack {
                        
                        
                        
                        RadarChartGrid(maxX: geometry.frame(in: .local).maxX, midX: geometry.frame(in: .local).midX, maxY: geometry.frame(in: .local).maxY, midY: geometry.frame(in: .local).midY, categories: data.count, divisions: divisions)
                            .stroke(gridColor, lineWidth: 0.5)

                        RadarChartPath(maxX: geometry.frame(in: .local).maxX, midX: geometry.frame(in: .local).midX, maxY: geometry.frame(in: .local).maxY, midY: geometry.frame(in: .local).midY, data: data, maxValue: maxValue)
                            .fill(dataColor.opacity(0.3))

                        RadarChartPath(maxX: geometry.frame(in: .local).maxX, midX: geometry.frame(in: .local).midX, maxY: geometry.frame(in: .local).maxY, midY: geometry.frame(in: .local).midY, data: data, maxValue: maxValue)
                            .stroke(dataColor, lineWidth: 2.0)
                        
                        
                        ZStack  {
                            ForEach(0..<self.data.count){ i in
                                PieChartSlice(center: CGPoint(x: geometry.frame(in: .local).midX, y: geometry.frame(in:  .local).midY), radius: min(geometry.frame(in: .local).maxX - geometry.frame(in: .local).midX,geometry.frame(in: .local).maxY - geometry.frame(in: .local).midY), startDegree: pieSlices[i].startDegree, endDegree: pieSlices[i].endDegree, isTouched: sliceIsTouched(index: i, inPie: geometry.frame(in:  .local)), accentColor: dataColor.opacity(0.001), separatorColor: gridColor.opacity(0.001))
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

struct RadarChart_Previews: PreviewProvider {
     static var previews: some View {
         Group {
             RadarChart(title: "Monthly Sales", gridColor: Color.gray, dataColor: Color.purple, dataUnit: "SEK", legend: "Month", data: radarChartDataSet, maxValue: 0, divisions: 10)
         }
     }
 }
