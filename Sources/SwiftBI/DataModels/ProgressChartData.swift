//
//  File.swift
//  
//
//  Created by Marcus Wittenstam on 2022-03-22.
//

import Foundation

public struct ProgressChartData: Equatable {
    var label: String
    var value: Double

    public init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
 }

enum ProgressChartType: Codable  {
    case line
    case circle
    case halfcircle
}
