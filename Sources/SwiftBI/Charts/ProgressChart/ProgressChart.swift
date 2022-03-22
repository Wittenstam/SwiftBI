//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2022-03-22.
//

import SwiftUI

struct ProgressChart: View {
    
    @Binding var title: String
    @Binding var legend: String
    @Binding var dataUnit: String
    @Binding var showProcentage: Bool
    @Binding var progressColor: Color
    @Binding var maxValue: Double
    @Binding var type: ProgressChartType
    @Binding var data: ProgressChartData

    public init(
                title: Binding<String>,
                legend: Binding<String>,
                dataUnit: Binding<String>,
                showProcentage: Binding<Bool>,
                progressColor: Binding<Color>,
                maxValue: Binding<Double>,
                type: Binding<ProgressChartType>,
                data: Binding<ProgressChartData>
    ) {
        self._title = title
        self._legend = legend
        self._dataUnit = dataUnit
        self._showProcentage = showProcentage
        self._progressColor = progressColor
        self._maxValue = maxValue
        self._type = type
        self._data = data
    }

    @State private var currentValue = ""
    @State private var currentLabel = ""
    @State private var touchLocation: CGFloat = -1
    
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
                //.font(.title)
                .font(.system(size: 25, weight: .bold))
            VStack {
                GeometryReader { geometry in
                    VStack {
                        
                        if (type == .line) {
                            VStack {
                                if (showProcentage == true) {
                                    Text("\(Int((data.value / maxValue) * 100))%")
                                        .font(.system(size: 30))
                                } else {
                                    Text("\(Int(data.value)) \(dataUnit)")
                                        .font(.system(size: 30))
                                }
                                
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(Color(UIColor.lightGray))
                                        .frame(width: 300, height: 20)
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(progressColor)
                                        .frame(width: 300 * (data.value / maxValue), height: 20)
                                }
                            }
                        }
                        else if (type == .circle) {
                            ZStack {
                                Circle()
                                    .stroke(Color(UIColor.lightGray), lineWidth: 15)
                                    .frame(width: geometry.size.width)
                                Circle()
                                    .trim(from: 0.0, to: (data.value / maxValue) )
                                    .stroke(progressColor, lineWidth: 15)
                                    .frame(width: geometry.size.width)
                                    .rotationEffect(Angle(degrees: -90))
                                
                                if (showProcentage == true) {
                                    Text("\(Int((data.value / maxValue) * 100))%")
                                        .font(.system(size: 30))
                                } else {
                                    Text("\(Int(data.value)) \(dataUnit)")
                                        .font(.system(size: 30))
                                }
                            }
                        }
                        else if (type == .halfcircle) {
                            ZStack {
                                Circle()
                                    .trim(from: 0.0, to: 0.5)
                                    .stroke(progressColor, style: StrokeStyle(lineWidth: 12.0, dash: [8]))
                                    .frame(width: geometry.size.width)
                                    .rotationEffect(Angle(degrees: -180))
                                Circle()
                                    .trim(from: 0.0, to: (data.value / maxValue)/2)
                                    .stroke(progressColor, lineWidth: 12.0)
                                    .frame(width: geometry.size.width)
                                    .rotationEffect(Angle(degrees: -180))
                                
                                if (showProcentage == true) {
                                    Text("\(Int((data.value / maxValue) * 100))%")
                                        .font(.system(size: 30))
                                } else {
                                    Text("\(Int(data.value)) \(dataUnit)")
                                        .font(.system(size: 30))
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        .padding()
    }
    
    
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        previewWrapper()
    }
    struct previewWrapper: View {
        @State var title: String = "Timer"
        @State var legend: String =  "Minute timer"
        @State var dataUnit: String = "Seconds"
        @State var showProcentage: Bool = true
        @State var progressColor: Color = .blue
        @State var maxValue: Double = 60
        @State var type: ProgressChartType = .circle
        @State var data: ProgressChartData = ProgressChartData(label: "Timer", value: 56.7)
         
        var body: some View {
            ProgressChart(title: $title, legend: $legend, dataUnit: $dataUnit, showProcentage: $showProcentage, progressColor: $progressColor, maxValue: $maxValue, type: $type, data: $data)
        }
    }
}
