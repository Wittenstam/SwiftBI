//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-10.
//

import Foundation
import SwiftUI

public struct RadarChart: View {

    var title: String
    let gridColor: Color
    let dataColor: Color
    var data: [RadarChartData]
    let maxValue: Double
    let divisions: Int
  
    public init(title: String, gridColor: Color = .gray, dataColor: Color = .purple, data: [RadarChartData], maxValue: Double = 0, divisions: Int = 10) {
        self.title = title
        self.gridColor = gridColor
        self.dataColor = dataColor
        self.data = data
        self.maxValue = maxValue
        self.divisions = divisions
    }
  
    public var body: some View {
        ZStack {
            RadarChartGrid(categories: data.count, divisions: divisions)
                .stroke(gridColor, lineWidth: 0.5)

            RadarChartPath(data: data, maxValue: maxValue)
                .fill(dataColor.opacity(0.3))

            RadarChartPath(data: data, maxValue: maxValue)
                .stroke(dataColor, lineWidth: 2.0)
        }
    }
    
}

struct RadarChart_Previews: PreviewProvider {
     static var previews: some View {
         Group {
             RadarChart(title: "Monthly Sales", gridColor: Color.gray, dataColor: Color.purple, data: radarChartDataSet, maxValue: 0, divisions: 10)
         }
     }
 }
