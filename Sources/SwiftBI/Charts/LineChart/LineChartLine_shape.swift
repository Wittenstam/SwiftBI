//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-14.
//

import SwiftUI

struct LineChartLine_shape: Shape {
    
    
    var data: [LineChartDataLine]
    //var data: [LineChartData]
    var index: Int
    var lineColor: Color
    var filled: Bool
    
    //@Binding var frame: CGRect

    let padding:CGFloat = 30
    
    
    
//    var path: Path {
//        let points = allValues
//        var path = Path.lineChart(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
//        if filled {
//            path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY))
//            path.addLine(to: CGPoint(x: frame.minX, y: frame.maxY))
//            path.closeSubpath()
//        }
//        return path
//    }
    
    func path(in rect: CGRect) -> Path {
        
        var stepWidth: CGFloat {
            if data[index].value.count < 2 {
                return 0
            }
            return rect.size.width / CGFloat(data[index].value.count-1)
        }
        var maximumValue: Double  {
            var allValues: [Double]    {
                var values = [Double]()
                for lines in data {
                    for lineData in lines.value {
                        values.append(lineData.value)
                    }
                }
                return values
            }
            guard let max = allValues.max() else {
                return 1
            }
            return max
        }
        var allValues: [Double]    {
            var values = [Double]()
            for lines in data {
                //for (index, linedata) in lines.value.enumerated() {
                for lineData in lines.value {
                    //values.append(data.value)
                    values.append(normalizedValue(lineData: lineData, maxValue: maximumValue))
                }
            }
            return values
        }
        var lineValues: [Double]    {
            var values = [Double]()
            for lineData in data[index].value {
                values.append(normalizedValue(lineData: lineData, maxValue: maximumValue))
            }
            return values
        }
        var stepHeight: CGFloat {
            var min: Double?
            var max: Double?
            let points = allValues
            if let minPoint = points.min(), let maxPoint = points.max(), minPoint != maxPoint {
                min = minPoint
                max = maxPoint
            }else {
                return 0
            }
            if let min = min, let max = max, min != max {
                if (min <= 0){
                    return (rect.size.height-padding) / CGFloat(max - min)
                }else{
                    return (rect.size.height-padding) / CGFloat(max + min)
                }
            }
            
            return 0
        }
        

        let points = lineValues
        var path = Path.lineChart(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
        if filled {
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.closeSubpath()
        }
        return path
        
    }
    
    
    
    func normalizedValue(lineData: LineChartData, maxValue: Double) -> Double {
//        var maximumValue = maxValue
//        if (maximumValue == 0) {
//            var allValues: [Double]    {
//                var values = [Double]()
//                for data in data.value {
//                    values.append(data.value)
//                }
//                return values
//            }
//            guard let max = allValues.max() else {
//                     return 1
//            }
//            maximumValue = max
//        }
        if maxValue != 0 {
            return Double(lineData.value)/Double(maxValue)
        } else {
            return 1
        }
    }
    
    
//    public var body: some View {
//
//        ZStack {
//            self.path
//                .stroke(lineColor ,style: StrokeStyle(lineWidth: 3, lineJoin: .round))
//                .rotationEffect(.degrees(180), anchor: .center)
//                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
//                .drawingGroup()
//    }
}

extension Path {
    
    static func lineChart(points:[Double], step:CGPoint) -> Path {
        var path = Path()
        if (points.count < 2){
            return path
        }
        guard let offset = points.min() else { return path }
        let p1 = CGPoint(x: 0, y: CGFloat(points[0]-offset)*step.y)
        path.move(to: p1)
        for pointIndex in 1..<points.count {
            let p2 = CGPoint(x: step.x * CGFloat(pointIndex), y: step.y*CGFloat(points[pointIndex]-offset))
            path.addLine(to: p2)
        }
        return path
    }
}








