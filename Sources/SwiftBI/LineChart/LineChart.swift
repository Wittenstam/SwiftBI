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
    var data: [LineChartData]
    var lineColor: Color
    var filled: Bool

    public init(
                title: String,
                dataUnit: String,
                data: [LineChartData],
                lineColor: Color,
                filled: Bool
    ) {
        self.title = title
        self.dataUnit = dataUnit
        self.data = data
        self.lineColor = lineColor
        self.filled = filled
    }
    
    public var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading, spacing: 8) {
               // Group{
                Text(title)
                    .bold()
                    .font(.largeTitle)
//                    if (self.price != nil){
//                        Text(self.price!)
//                            .font(.body)
//                        .offset(x: 5, y: 0)
//                    }
                //}.offset(x: 0, y: 0)
                ZStack{
                    GeometryReader{ reader in
                        LineChartLine(data: data,
                             frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width , height: reader.frame(in: .local).height))
                        )
                            .offset(x: 0, y: 0)
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
        //LineView(data: [8,23,54,32,12,37,7,23,43], title: "Full chart")
        Group {
            LineChart(title: "Montly Sales", dataUnit: "SEK", data: lineChartDataSet, lineColor: Color.green, filled: true)
        }
    }
}
