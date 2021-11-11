//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-11.
//

import SwiftUI

public struct BarChart: View {

    var title: String
    var legend: String
    var dataUnit: String
    var barColor: Color
    var data: [BarChartData]
    var maxValue: Double
    
    @State private var currentValue = ""
    @State private var currentLabel = ""
    @State private var touchLocation: CGFloat = -1
    
    init(title: String, legend: String, dataUnit: String, barColor: Color = .blue, data: [BarChartData], maxValue: Double = 0) {
        self.title = title
        self.legend = legend
        self.dataUnit = dataUnit
        self.barColor = barColor
        self.data = data
        self.maxValue = maxValue
    }
                                 
    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
                .font(.largeTitle)
            Text("Current value: \(currentValue) \(dataUnit)")
                .font(.headline)
            GeometryReader { geometry in
                VStack {
                    HStack {
                        ForEach(0..<data.count, id: \.self) { i in
                            BarChartCell(value: normalizedValue(index: i, maxValue: maxValue), barColor: barColor)
                                .opacity(barIsTouched(index: i) ? 1 : 0.55)
                                .scaleEffect(barIsTouched(index: i) ? CGSize(width: 1.05, height: 1) : CGSize(width: 1, height: 1), anchor: .bottom)
                                .animation(.spring())
                                .padding(.top)
                        }
                    }
                        .gesture(DragGesture(minimumDistance: 0)
                            .onChanged({ position in
                                let touchPosition = position.location.x/geometry.frame(in: .local).width
                                                        
                                touchLocation = touchPosition
                                updateCurrentValue()
                            })
                            .onEnded({ position in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation(Animation.easeOut(duration: 0.5)) {
                                        resetValues()
                                    }
                                }
                            })
                        )
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
                }
            }
        }
        .padding()
    }
    
    
    
    func normalizedValue(index: Int, maxValue: Double) -> Double {
        var maximumValue = maxValue
        if (maximumValue == 0) {
            var allValues: [Double]    {
                var values = [Double]()
                for data in data {
                    values.append(data.value)
                }
                return values
            }
            guard let max = allValues.max() else {
                     return 1
            }
            maximumValue = max
        }
        if maximumValue != 0 {
            return Double(data[index].value)/Double(maximumValue)
        } else {
            return 1
        }
    }
    
    func barIsTouched(index: Int) -> Bool {
        touchLocation > CGFloat(index)/CGFloat(data.count) && touchLocation < CGFloat(index+1)/CGFloat(data.count)
    }
    
    func updateCurrentValue()    {
        let index = Int(touchLocation * CGFloat(data.count))
        guard index < data.count && index >= 0 else {
            currentValue = ""
            currentLabel = ""
            return
        }
        currentValue = "\(data[index].value)"
        currentLabel = data[index].label
    }
    
    func resetValues() {
        touchLocation = -1
        currentValue  =  ""
        currentLabel = ""
    }
    
    func labelOffset(in width: CGFloat) -> CGFloat {
        let currentIndex = Int(touchLocation * CGFloat(data.count))
        guard currentIndex < data.count && currentIndex >= 0 else {
            return 0
        }
        let cellWidth = width / CGFloat(data.count)
        let actualWidth = width -    cellWidth
        let position = cellWidth * CGFloat(currentIndex) - actualWidth/2
        return position
    }

}


struct BarChart_Previews: PreviewProvider {
     static var previews: some View {
         Group {
             BarChart(title: "Monthly Sales", legend: "Month", dataUnit: "SEK", barColor: .blue, data: barChartDataSet, maxValue: 0)
         }
     }
 }
