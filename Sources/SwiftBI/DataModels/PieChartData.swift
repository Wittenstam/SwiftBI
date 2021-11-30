//
//  File.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-12.
//

import Foundation

public class PieChartDataList: ObservableObject {
    @Published var PieChartDataList = [PieChartData]()
}

public struct PieChartData {
     var label: String
     var value: Double
    
    public init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
 }


var pieChartDataSet : PieChartDataList {
    let data : PieChartDataList = PieChartDataList()
    
    data.PieChartDataList.append(PieChartData(label: "January", value: 150.32))
    data.PieChartDataList.append(PieChartData(label: "February", value: 202.32))
    data.PieChartDataList.append(PieChartData(label: "March", value: 390.22))
    data.PieChartDataList.append(PieChartData(label: "April", value: 350.0))
    data.PieChartDataList.append(PieChartData(label: "May", value: 460.33))
    data.PieChartDataList.append(PieChartData(label: "June", value: 320.02))
    data.PieChartDataList.append(PieChartData(label: "July", value: 50.98))
                                 
    return data
}
