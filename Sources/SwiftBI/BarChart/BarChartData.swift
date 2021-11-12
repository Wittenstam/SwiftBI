//
//  File.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-11.
//

import Foundation


public struct BarChartData {
     var label: String
     var value: Double
    
    public init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
 }


let barChartDataSet = [
    BarChartData(label: "January", value: 340.32),
    BarChartData(label: "February", value: 250.0),
    BarChartData(label: "March", value: 430.22),
    BarChartData(label: "April", value: 350.0),
    BarChartData(label: "May", value: 450.0),
    BarChartData(label: "June", value: 380.0),
    BarChartData(label: "July", value: 365.98)
 ]
