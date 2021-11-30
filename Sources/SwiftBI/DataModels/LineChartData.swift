//
//  File.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-14.
//

import Foundation
import SwiftUI


public struct LineChartDataLine {
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



