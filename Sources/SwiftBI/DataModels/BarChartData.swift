//
//  File.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-11.
//

import Foundation

public class BarChartDataList: ObservableObject {
    @Published var BarChartDataList = [BarChartData]()
}

class BarChartData {
     var label: String
     var value: Double
    
    public init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
 }


var barChartDataSet : BarChartDataList {
    let data : BarChartDataList = BarChartDataList()
    
    data.BarChartDataList.append(BarChartData(label: "January", value: 340.32))
    data.BarChartDataList.append(BarChartData(label: "February", value: 250.0))
    data.BarChartDataList.append(BarChartData(label: "March", value: 430.22))
    data.BarChartDataList.append(BarChartData(label: "April", value: 350.0))
    data.BarChartDataList.append(BarChartData(label: "May", value: 450.0))
    data.BarChartDataList.append(BarChartData(label: "June", value: 380.0))
    data.BarChartDataList.append(BarChartData(label: "July", value: 365.98))

    return data
}
