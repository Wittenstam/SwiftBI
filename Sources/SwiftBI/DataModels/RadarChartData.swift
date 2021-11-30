//
//  File.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-11.
//

import Foundation

public class RadarChartDataList: ObservableObject {
    @Published var RadarChartDataList = [RadarChartData]()
}

public struct RadarChartData {
     var label: String
     var value: Double
    
    public init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
 }


var radarChartDataSet : RadarChartDataList {
    let data : RadarChartDataList = RadarChartDataList()
    
    data.RadarChartDataList.append(RadarChartData(label: "January", value: 340.32))
    data.RadarChartDataList.append(RadarChartData(label: "February", value: 250.0))
    data.RadarChartDataList.append(RadarChartData(label: "March", value: 430.22))
    data.RadarChartDataList.append(RadarChartData(label: "April", value: 350.0))
    data.RadarChartDataList.append(RadarChartData(label: "May", value: 450.0))
    data.RadarChartDataList.append(RadarChartData(label: "June", value: 380.0))
    data.RadarChartDataList.append(RadarChartData(label: "July", value: 365.98))
    
    return data
}
