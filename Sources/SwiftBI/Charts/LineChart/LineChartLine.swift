//
//  File.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-16.
//

import SwiftUI

public struct LineChartLine: View {
    
    
    var data: [LineChartDataLine]
    var lineIndex: Int
    @Binding var touchLocation: CGPoint
    @Binding var isSelectedIndex: Int
    @Binding var frame: CGRect
    

    let padding:CGFloat = 30
    
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
    var minimumValue: Double  {
        var allValues: [Double]    {
            var values = [Double]()
            for lines in data {
                for lineData in lines.value {
                    values.append(lineData.value)
                }
            }
            return values
        }
        guard let max = allValues.min() else {
            return 0
        }
        return max
    }
    var allValues: [Double] {
        var values = [Double]()
        for lines in data {
            //for (index, linedata) in lines.value.enumerated() {
            for lineData in lines.value {
                //values.append(lineData.value)
                values.append(normalizedValue(lineData: lineData, maxValue: maximumValue))
            }
        }
        return values
    }
    var lineValues: [Double] {
        var values = [Double]()
        for lineData in data[lineIndex].value {
            //values.append(lineData.value)
            values.append(normalizedValue(lineData: lineData, maxValue: maximumValue))
        }
        return values
    }
    var stepWidth: CGFloat {
        if data[lineIndex].value.count < 2 {
            return 0
        }
        return frame.size.width / CGFloat(data[lineIndex].value.count-1)
    }
    var stepHeight: CGFloat {
        var min: Double?
        var max: Double?
        let points = allValues //lineValues //self.data[lineIndex].value
//        if minDataValue != nil && maxDataValue != nil {
//            min = minDataValue!
//            max = maxDataValue!
//        }else
        if let minPoint = points.min(), let maxPoint = points.max(), minPoint != maxPoint {
            min = minPoint
            max = maxPoint
        }else {
            return 0
        }
        if let min = min, let max = max, min != max {
            if (min <= 0){
                return (frame.size.height-padding) / CGFloat(max) // max - min
            }else{
                return (frame.size.height-padding) / CGFloat(max) // max - min
            }
        }
        return 0
    }
    var path: Path {
        let points = lineValues
        if data[lineIndex].isCurved {
            return curvedLinePath(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
        }
        else {
            return linePath(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
        }
    }
    var filledPath: Path {
        let points = lineValues
        if data[lineIndex].isCurved {
            return filledCurvedLinePath(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
        }
        else {
            return filledLinePath(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
        }
    }
    
    
    public var body: some View {
        ZStack {
            if (data[lineIndex].isFilled) {
                filledPath
                    .fill(data[lineIndex].color)
                    .rotationEffect(.degrees(180), anchor: .center)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .transition(.opacity)
                    //.animation(.easeIn(duration: 1.6))
            }
            else {
                path
                    .stroke(data[lineIndex].color,style: StrokeStyle(lineWidth: 3, lineJoin: .round))
                    .rotationEffect(.degrees(180), anchor: .center)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .animation(Animation.easeOut(duration: 1.2).delay(Double(self.lineIndex) * 0.4))
            }
            
            if (isSelectedIndex == lineIndex || data.count < 2) {
                LineChartIndicatorPoint(fillColor: data[lineIndex].color)
                    .position(getClosestPointOnPath())
                    //.position(x: getNearestPositionX(), y: 1)
                    .rotationEffect(.degrees(180), anchor: .center)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
        }
    }
    
    

    
    func getClosestPointOnPath() -> CGPoint {
        let touchLocationX = getNearestPositionX()
        let closestPoint = self.path.point(to: touchLocationX)
        return closestPoint
    }
    
    
    func getNearestPositionX() -> CGFloat {
        var position: CGFloat = 0

        let currentIndex = Int(touchLocation.x * CGFloat(data[lineIndex].value.count))
        guard currentIndex < data[lineIndex].value.count && currentIndex >= 0 else {
            return 0
        }
        position = ( stepWidth * CGFloat(currentIndex) )
        
        return position
    }
    
    
    func linePath(points:[Double], step:CGPoint) -> Path {
        var path = Path()
        
        if (points.count < 2) {
            return path
        }
        //guard let offset = points.min() else { return path }
        
//        let p1 = CGPoint(x: 0, y: CGFloat(points[0]-offset) * step.y)
//        path.move(to: p1)
        
        findFirst: for pointIndex in 0 ..< points.count {
            if points[pointIndex] != Double(-1) {
                let firstPoint  = CGPoint(x: step.x * CGFloat(pointIndex), y: (step.y * CGFloat(points[pointIndex] )) ) //(frame.minY - points[pointIndex])  (step.y * minimumValue) +
                path.move(to: firstPoint)
                break findFirst
            }
        }
        
        for pointIndex in 1..<points.count {
            if points[pointIndex] != Double(-1) {
                let nextPoint = CGPoint(x: step.x * CGFloat(pointIndex), y:  (step.y * CGFloat(points[pointIndex] )) ) //(frame.minY  - points[pointIndex])
                path.addLine(to: nextPoint)
            }
        }
        
        return path
    }
    
    func curvedLinePath(points:[Double], step:CGPoint) -> Path {
        var path = Path()
        
        if (points.count < 2) {
            return path
        }
        
        let lineRadius = 0.25 // how cruved will the lie be. between 0 and 1. 0 not at all, 1 very curved
        var previousPoint = CGPoint(x:0, y:0)
        
        findFirst: for pointIndex in 0 ..< points.count {
            if points[pointIndex] != Double(-1) {
                let firstPoint  = CGPoint(x: step.x * CGFloat(pointIndex), y: (step.y * CGFloat(points[pointIndex] )) ) //(frame.minY - points[pointIndex])  (step.y * minimumValue) +
                path.move(to: firstPoint)
                previousPoint = firstPoint
                break findFirst
            }
        }
        
        for pointIndex in 1..<points.count {
            if points[pointIndex] != Double(-1) {
                let nextPoint = CGPoint(x: step.x * CGFloat(pointIndex), y:  (step.y * CGFloat(points[pointIndex] )) ) //(frame.minY  - points[pointIndex])
                let deltaX = nextPoint.x - previousPoint.x
                let curveXOffset = deltaX * lineRadius
                path.addCurve(to: nextPoint, control1: .init(x: previousPoint.x + curveXOffset, y: previousPoint.y), control2: .init(x: nextPoint.x - curveXOffset, y: nextPoint.y))
                previousPoint = nextPoint
            }
        }
        
        return path
    }
    
    
    func filledLinePath(points:[Double], step:CGPoint) -> Path {
        
        var path = linePath(points: points, step: step)

        path.addLine(to: CGPoint(x: frame.maxX, y: frame.minY)) //minY
        path.addLine(to: CGPoint(x: frame.minX, y: frame.minY)) //minY
        
        path.closeSubpath()
        
        return path
    }
    
    func filledCurvedLinePath(points:[Double], step:CGPoint) -> Path {
        
        var path = curvedLinePath(points: points, step: step)

        path.addLine(to: CGPoint(x: frame.maxX, y: frame.minY)) //minY
        path.addLine(to: CGPoint(x: frame.minX, y: frame.minY)) //minY
        
        path.closeSubpath()
        
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

    
}


