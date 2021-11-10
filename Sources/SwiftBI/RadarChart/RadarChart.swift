//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-10.
//

import Foundation
import SwiftUI

struct RadarChart: View {
    
  var data: [Double]
  let gridColor: Color
  let dataColor: Color
  
  init(data: [Double], gridColor: Color = .gray, dataColor: Color = .blue) {
    self.data = data
    self.gridColor = gridColor
    self.dataColor = dataColor
  }
  
  var body: some View {
    ZStack {
      RadarChartGrid(categories: data.count, divisions: 10)
        .stroke(gridColor, lineWidth: 0.5)
      
      RadarChartPath(data: data)
        .fill(dataColor.opacity(0.3))
      
      RadarChartPath(data: data)
        .stroke(dataColor, lineWidth: 2.0)
    }
  }
    
}
