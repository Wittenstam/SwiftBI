//
//  File.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-12.
//

import Foundation


public struct PieChartData: Equatable {
    var label: String
    var value: Double

    public init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
 }


