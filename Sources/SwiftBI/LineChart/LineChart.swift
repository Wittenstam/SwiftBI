//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-14.
//

import SwiftUI

public struct LineChart: View {
    
    var title: String
    var legend: String
    var dataUnit: String
    var data: [LineChartDataLine]
    
    @State private var currentValue = ""
    @State private var currentLabel = ""
    @State private var touchLocation: CGFloat = -1
    @State private var selectedLineIndex = -1

    public init(
                title: String,
                legend: String,
                dataUnit: String,
                data: [LineChartDataLine],
    ) {
        self.title = title
        self.legend = legend
        self.dataUnit = dataUnit
        self.data = data
        self.lineColors = lineColors
        self.filled = filled
    }
    
    private var gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
                .font(.largeTitle)
            VStack{
                GeometryReader{ geometry in
                    VStack {
                        ZStack{
                            GeometryReader{ reader in
                                ForEach(0..<self.data.count){ index in
                                    LineChartLine(data: data[index].value, lineColor: data[index].color,
                                         frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width , height: reader.frame(in: .local).height))
                                    )
                                        .offset(x: 0, y: 0)
                                }
                            }
                            .frame(width: geometry.frame(in: .local).size.width, height: 200)
                            .offset(x: 0, y: -100)
                        }
                        .frame(width: geometry.frame(in: .local).size.width, height: 200)
                        .gesture(DragGesture(minimumDistance: 0)
                            .onChanged({ position in
                                let touchPosition = position.location.x/geometry.frame(in: .local).width
                                                        
                                touchLocation = touchPosition
                                updateCurrentValue()
                            })
                            .onEnded({ position in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation(Animation.easeOut(duration: 0.5)) {
                                        resetValues()
                                    }
                                }
                            })
                        )
                        VStack {
                            if currentLabel.isEmpty {
                                Text(legend)
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(5)
                                    .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                            } else {
                                Text(currentLabel)
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(5)
                                    .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                                    .offset(x: labelOffset(in: geometry.frame(in: .local).width))
                                    .animation(.easeIn)
                            }
                            if !currentValue.isEmpty {
                                Text("\(currentValue) \(dataUnit)")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(5)
                                    .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                                    .offset(x: labelOffset(in: geometry.frame(in: .local).width))
                                    .animation(.easeIn)
                            } else {
                                Text(currentValue)
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(5)
                                    .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.clear).shadow(radius: 3))
                            }
                        }
                    }
                }
                LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 10) {
                    ForEach(0..<data.count)   {    i in
                        Button(action: {
                            if ( selectedLineIndex == i) {
                                selectedLineIndex = -1
                            }
                            else {
                                selectedLineIndex = i
                            }
                        })
                        {
                            if ( selectedLineIndex == i) {
                                HStack {
                                    lineColors[i]
                                        .aspectRatio(contentMode: .fit)
                                        .frame(minWidth: 0, maxWidth: 30, minHeight: 30)
                                        .padding(5)
                                    Text(data[i].label)
                                        .font(.caption)
                                        .fontWeight(.heavy)
                                }
                                .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.clear).shadow(radius: 3))
                            }
                            else {
                                HStack {
                                    lineColors[i]
                                        .aspectRatio(contentMode: .fit)
                                        .frame(minWidth: 0, maxWidth: 20, minHeight: 20)
                                        .padding(5)
                                    Text(data[i].label)
                                        .font(.caption)
                                        .bold()
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
    
    
    func barIsTouched(index: Int) -> Bool {
        var touched: Bool = false
        if (data.count > 0 && data.count < 2) {
            touched = touchLocation > CGFloat(index)/CGFloat(data[0].value.count) && touchLocation < CGFloat(index+1)/CGFloat(data[0].value.count)
        }
        else if (data.count >= 2 && selectedLineIndex != -1) {
            touched = touchLocation > CGFloat(index)/CGFloat(data[selectedLineIndex].value.count) && touchLocation < CGFloat(index+1)/CGFloat(data[selectedLineIndex].value.count)
        }
        return touched
    }
    
    func updateCurrentValue()    {
        
        if (data.count > 0 && data.count < 2) {
            let index = Int(touchLocation * CGFloat(data[0].value.count))
            guard index < data[0].value.count && index >= 0 else {
                currentValue = ""
                currentLabel = ""
                return
            }
            currentValue = "\(data[0].value[index].value)"
            currentLabel = data[0].value[index].label
        }
        else if (data.count >= 2 && selectedLineIndex != -1) {
            let index = Int(touchLocation * CGFloat(data[selectedLineIndex].value.count))
            guard index < data[selectedLineIndex].value.count && index >= 0 else {
                currentValue = ""
                currentLabel = ""
                return
            }
            currentValue = "\(data[selectedLineIndex].value[index].value)"
            currentLabel = data[selectedLineIndex].value[index].label
        }
        
    }
    
    func resetValues() {
        touchLocation = -1
        currentValue  =  ""
        currentLabel = ""
    }
    
    func labelOffset(in width: CGFloat) -> CGFloat {
        var position: CGFloat = 0
        if (data.count > 0 && data.count < 2) {
            let currentIndex = Int(touchLocation * CGFloat(data[0].value.count))
            guard currentIndex < data[0].value.count && currentIndex >= 0 else {
                return 0
            }
            let cellWidth = width / CGFloat(data[0].value.count)
            let actualWidth = width -    cellWidth
            position = cellWidth * CGFloat(currentIndex) - actualWidth/2
        }
        else if (data.count >= 2 && selectedLineIndex != -1) {
            let currentIndex = Int(touchLocation * CGFloat(data[selectedLineIndex].value.count))
            guard currentIndex < data[selectedLineIndex].value.count && currentIndex >= 0 else {
                return 0
            }
            let cellWidth = width / CGFloat(data[selectedLineIndex].value.count)
            let actualWidth = width -    cellWidth
            position = cellWidth * CGFloat(currentIndex) - actualWidth/2
        }
        return position
    }
    
    
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineChart(title: "Montly Sales", legend: "Month", dataUnit: "SEK", data: lineChartDataSet)
        }
    }
}
