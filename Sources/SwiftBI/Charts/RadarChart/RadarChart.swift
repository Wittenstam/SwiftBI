//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-10.
//

import SwiftUI

public struct RadarChart: View {

    @Binding var title: String
    @Binding var gridColor: Color
    @Binding var dataColor: Color
    @Binding var dataUnit: String
    @Binding var legend: String
    @Binding var data: [RadarChartData]
    @Binding var maxValue: Double
    @Binding var divisions: Int
    
    @State private var currentValue = ""
    @State private var currentLabel = ""
    @State private var touchLocation: CGPoint = .init(x: -1, y: -1)
  
    public init(
                title: Binding<String>,
                gridColor: Binding<Color>, //= .gray,
                dataColor: Binding<Color>, //= .purple,
                dataUnit: Binding<String>,
                legend: Binding<String>,
                data: Binding<[RadarChartData]>,
                maxValue: Binding<Double>,//= 0,
                divisions: Binding<Int> //= 10
    ) {
        self._title = title
        self._gridColor = gridColor
        self._dataColor = dataColor
        self._dataUnit = dataUnit
        self._legend = legend
        self._data = data
        self._maxValue = maxValue
        self._divisions = divisions
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
       // var currentIndex = pieSlices.firstIndex(where: { $0.startDegree < angle && angle < $0.endDegree }) ?? -1
        
        var currentIndex = -1
        for (index, pie) in pieSlices.enumerated() {
                
            if (pie.startDegree > pie.endDegree) {
                if (angle > pie.startDegree) {
                    if (pie.startDegree < angle && angle < 360) {
                        currentIndex = index
                    }
                }
                else {
                    if (0 < angle && angle < pie.endDegree) {
                        currentIndex = index
                    }
                }
            }
            else {
                if (pie.startDegree < angle && angle < pie.endDegree) {
                    currentIndex = index
                }
            }
        }
        
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
    
    func angleAtTouchLocation(inPie pieSize: CGRect, touchLocation: CGPoint) ->  Double?  {
        let dx = touchLocation.x - pieSize.midX
        let dy = touchLocation.y - pieSize.midY

        let distanceToCenter = (dx * dx + dy * dy).squareRoot()
        let radius = pieSize.width/2

        guard distanceToCenter <= radius
        else {
            return nil
        }

        let angleAtTouchLocation = Double(atan2(dy, dx) * (180 / .pi))

        if angleAtTouchLocation < 0 {
            return (180 + angleAtTouchLocation) + 180
        }
        else {
            return angleAtTouchLocation
        }
    }
    
    
}

struct RadarChart_Previews: PreviewProvider {
    static var previews: some View {
        previewWrapper()
    }
    
    struct previewWrapper: View {
        @State var title: String = "Monthly Sales"
        @State var gridColor: Color = .gray
        @State var dataColor: Color = .purple
        @State var dataUnit: String = "SEK"
        @State var legend: String =  "Month"
        @State var data: [RadarChartData] = [
            RadarChartData(label: "January", value: 340.32),
            RadarChartData(label: "February", value: 250.0),
            RadarChartData(label: "March", value: 430.22),
            RadarChartData(label: "April", value: 350.0),
            RadarChartData(label: "May", value: 450.0),
            RadarChartData(label: "June", value: 380.0),
            RadarChartData(label: "July", value: 365.98)
        ]
        @State var maxValue: Double = 0
        @State var divisions: Int = 10
        
        var body: some View {
            RadarChart(title: $title, gridColor: $gridColor, dataColor: $dataColor, dataUnit: $dataUnit, legend: $legend, data: $data, maxValue: $maxValue, divisions: $divisions)
        }
    }
 }
