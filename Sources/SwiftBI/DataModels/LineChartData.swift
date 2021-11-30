//
//  File.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-14.
//

import Foundation
import SwiftUI


public class LineChartDataLine : ObservableObject {
    var label: String
    var color: Color
    var isFilled: Bool
    var isCurved: Bool
    var value: [LineChartData]
    private var _isSelected: Bool = false
        var isSelected: Bool {
            get { return _isSelected }
            set { _isSelected = newValue }
        }
    
    public init(label: String, color: Color, isFilled: Bool, isCurved: Bool, value: [LineChartData]) {
        self.label = label
        self.color = color
        self.isFilled = isFilled
        self.isCurved = isCurved
        self.value = value
    }
 }

public struct LineChartData {
     var label: String
     var value: Double
    
    public init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
 }


let lineChartDataSet = [
    LineChartDataLine(label: "First", color: Color.green, isFilled: true, isCurved: true, value:
        [
            LineChartData(label: "January", value: 340.32),
            LineChartData(label: "February", value: 250.0),
            LineChartData(label: "March", value: 430.22),
            LineChartData(label: "April", value: 350.0),
            LineChartData(label: "May", value: 410.0),
            LineChartData(label: "June", value: 110.0),
            LineChartData(label: "July", value: 365.98)
        ]
    ),
    LineChartDataLine(label: "Second", color: Color.blue, isFilled: false, isCurved: true, value:
        [
            LineChartData(label: "January", value: 250.32),
            LineChartData(label: "February", value: 360.0),
            LineChartData(label: "March", value: 290.22),
            LineChartData(label: "April", value: 510.0),
            LineChartData(label: "May", value: 410.0), //410.0
            LineChartData(label: "June", value: 180.0),
            LineChartData(label: "July", value: 305.98)
        ]
    )
]
