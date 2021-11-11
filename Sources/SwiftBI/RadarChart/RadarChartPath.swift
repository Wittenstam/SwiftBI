//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-10.
//

import Foundation
import SwiftUI


struct RadarChartPath: Shape {
        
    let data: [RadarChartData]
    let maxValue: Double

    func path(in rect: CGRect) -> Path {
        
        var allValues: [Double]    {
            var values = [Double]()
            for data in data {
                values.append(data.value)
            }
            return values
        }
        
        var maximumValue = maxValue
        if (maximumValue == 0) {
            guard
                3 <= allValues.count,
                    let minimum = allValues.min(),
                0 <= minimum,
                        let maximum = allValues.max()
                else { return Path() }
            maximumValue = maximum
        }
        let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY)
        var path = Path()

        for (index, entry) in allValues.enumerated() {
            switch index {
                case 0:
                  path.move(to: CGPoint(x: rect.midX + CGFloat(entry / maximumValue) * cos(CGFloat(index) * 2 * .pi / CGFloat(allValues.count) - .pi / 2) * radius,
                                        y: rect.midY + CGFloat(entry / maximumValue) * sin(CGFloat(index) * 2 * .pi / CGFloat(allValues.count) - .pi / 2) * radius
                                       )
                            )
                  
                default:
                  path.addLine(to: CGPoint(x: rect.midX + CGFloat(entry / maximumValue) * cos(CGFloat(index) * 2 * .pi / CGFloat(allValues.count) - .pi / 2) * radius,
                                           y: rect.midY + CGFloat(entry / maximumValue) * sin(CGFloat(index) * 2 * .pi / CGFloat(allValues.count) - .pi / 2) * radius
                                          )
                            )
            }
        }
          
        path.closeSubpath()
        return path
    }
    
    
    
}
