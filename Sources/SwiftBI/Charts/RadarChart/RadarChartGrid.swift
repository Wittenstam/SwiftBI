//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-10.
//

import Foundation
import SwiftUI


struct RadarChartGrid: Shape {
        
    var maxX: CGFloat
    var midX: CGFloat
    var maxY: CGFloat
    var midY: CGFloat
    
    let categories: Int
    let divisions: Int

    func path(in rect: CGRect) -> Path {
      
        let radius = min(maxX - midX, maxY - midY)
        let stride = radius / CGFloat(divisions)
        var path = Path()

        for category in 1 ... categories {
            path.move(to: CGPoint(x: midX, y: midY))
            path.addLine(to: CGPoint(x: midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius,
                                   y: midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius
                                  )
                    )
        }

        for step in 1 ... divisions {
            let rad = CGFloat(step) * stride
            path.move(to: CGPoint(x: midX + cos(-.pi / 2) * rad,
                                y: midY + sin(-.pi / 2) * rad))

            for category in 1 ... categories {
            path.addLine(to: CGPoint(x: midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * rad,
                                     y: midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * rad
                                    )
                        )
            }
        }

        return path
    }
    
}
