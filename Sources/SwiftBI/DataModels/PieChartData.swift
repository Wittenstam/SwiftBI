//
//  File.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-12.
//

import Foundation


public struct PieChartData {
     var label: String
     var value: Double
    
    public init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
 }


let pieChartDataSet = [
    PieChartData(label: "January", value: 150.32),
    PieChartData(label: "February", value: 202.32),
    PieChartData(label: "March", value: 390.22),
    PieChartData(label: "April", value: 350.0),
    PieChartData(label: "May", value: 460.33),
    PieChartData(label: "June", value: 320.02),
    PieChartData(label: "July", value: 50.98)
]
