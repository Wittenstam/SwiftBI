//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-14.
//

import SwiftUI

struct LineChartLine: View {
    var data: [LineChartData]
    var lineColor: Color
    
    @Binding var frame: CGRect

    let padding:CGFloat = 30
    
    var stepWidth: CGFloat {
        if data.count < 2 {
            return 0
        }
        return frame.size.width / CGFloat(data.count-1)
    }
    var allValues: [Double]    {
        var values = [Double]()
        for data in data {
            values.append(data.value)
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
                return (frame.size.height-padding) / CGFloat(max - min)
            }else{
                return (frame.size.height-padding) / CGFloat(max + min)
            }
        }
        
        return 0
    }
    var path: Path {
        let points = allValues
        return Path.lineChart(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
    }
    
    public var body: some View {
        
        ZStack {

            self.path
                .stroke(lineColor ,style: StrokeStyle(lineWidth: 3, lineJoin: .round))
                .rotationEffect(.degrees(180), anchor: .center)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .drawingGroup()
        }
    }
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
