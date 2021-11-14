//
//  File.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-14.
//

import Foundation
import SwiftUI


public struct LineChartData {
     var label: String
     var value: Double
    
    public init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
 }


let lineChartDataSet = [
    [
        LineChartData(label: "January", value: 340.32),
        LineChartData(label: "February", value: 250.0),
        LineChartData(label: "March", value: 430.22),
        LineChartData(label: "April", value: 350.0),
        LineChartData(label: "May", value: 450.0),
        LineChartData(label: "June", value: 380.0),
        LineChartData(label: "July", value: 365.98)
    ],
    [
        LineChartData(label: "January", value: 250.32),
        LineChartData(label: "February", value: 360.0),
        LineChartData(label: "March", value: 290.22),
        LineChartData(label: "April", value: 510.0),
        LineChartData(label: "May", value: 410.0),
        LineChartData(label: "June", value: 180.0),
        LineChartData(label: "July", value: 305.98)
    ]
]

let lineChartColors = [
    Color.green,
    Color.blue
]
