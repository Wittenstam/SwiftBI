//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-17.
//

import SwiftUI

struct LineChartIndicatorPoint: View {
    
    var fillColor: Color
    
    var body: some View {
        ZStack {
            Circle()
                .fill(fillColor)
            Circle()
                .stroke(Color.background, style: StrokeStyle(lineWidth: 1))
        }
        .frame(width: 14, height: 14)
        .shadow(color: Color.secondaryBackground, radius: 6, x: 0, y: 6)
    }
}

struct LineChartIndicatorPoint_Previews: PreviewProvider {
    static var previews: some View {
        LineChartIndicatorPoint(fillColor: Color.white)
    }
}
