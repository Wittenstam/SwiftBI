//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-14.
//

import SwiftUI

public struct LineChart: View {
    var title: String
    var dataUnit: String
    var data: [[LineChartData]]
    var lineColors: [Color]
    var filled: Bool

    public init(
                title: String,
                dataUnit: String,
                data: [[LineChartData]],
                lineColors: [Color],
                filled: Bool
    ) {
        self.title = title
        self.dataUnit = dataUnit
        self.data = data
        self.lineColors = lineColors
        self.filled = filled
    }

    public var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .bold()
                    .font(.largeTitle)

                ZStack{
                    GeometryReader{ reader in
                        ForEach(0..<self.data.count){ index in
                            LineChartLine(data: data[index], lineColor: lineColors[index],
                                 frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width , height: reader.frame(in: .local).height))
                            )
                                .offset(x: 0, y: 0)
                        }
                    }
                    .frame(width: geometry.frame(in: .local).size.width, height: 200)
                    .offset(x: 0, y: -100)

                }
                .frame(width: geometry.frame(in: .local).size.width, height: 200)
        
            }
        }
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineChart(title: "Montly Sales", dataUnit: "SEK", data: lineChartDataSet, lineColors: lineChartColors, filled: true)
        }
    }
}
