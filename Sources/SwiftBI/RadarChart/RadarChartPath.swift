//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-10.
//

import Foundation
import SwiftUI

struct RadarChartPath: Shape {
    
  let data: [Double]
  
  func path(in rect: CGRect) -> Path {
    guard
      3 <= data.count,
      let minimum = data.min(),
      0 <= minimum,
      let maximum = data.max()
    else { return Path() }
    
    let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY)
    var path = Path()
    
    for (index, entry) in data.enumerated() {
      switch index {
        case 0:
          path.move(to: CGPoint(x: rect.midX + CGFloat(entry / maximum) * cos(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius,
                                y: rect.midY + CGFloat(entry / maximum) * sin(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius
                               )
                    )
          
        default:
          path.addLine(to: CGPoint(x: rect.midX + CGFloat(entry / maximum) * cos(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius,
                                   y: rect.midY + CGFloat(entry / maximum) * sin(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius
                                  )
                    )
      }
    }
      
    path.closeSubpath()
    return path
  }
    
}
