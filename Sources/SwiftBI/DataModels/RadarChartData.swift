//
//  File.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-11.
//

import Foundation


public class RadarChartData : ObservableObject {
     var label: String
     var value: Double
    
    public init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
 }


let radarChartDataSet = [
    RadarChartData(label: "January", value: 340.32),
    RadarChartData(label: "February", value: 250.0),
    RadarChartData(label: "March", value: 430.22),
    RadarChartData(label: "April", value: 350.0),
    RadarChartData(label: "May", value: 450.0),
    RadarChartData(label: "June", value: 380.0),
    RadarChartData(label: "July", value: 365.98)
]
