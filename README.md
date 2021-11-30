# SwiftBI
 
A SwiftUI package filled with smooth graphs for your iOS, macOS or watchOS app. 

All types of charts support light and dark mode, and all chart types has touch support.

There are five types of charts:
All images are shown with dark mode enables and simulates a user interacting with the chart by touching it and displaying the value 

BarChart | LineChart | MulitLineChart | RadarChart | PieChart
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
<img width="344" alt="BarChart" src="https://user-images.githubusercontent.com/87200889/143315627-2534fbd5-a8d9-4647-aae4-1f51ee49034f.png"> | <img width="340" alt="LineChart" src="https://user-images.githubusercontent.com/87200889/143315763-fccdfce7-b961-4989-905f-f8e219816607.png"> | <img width="337" alt="MultiLineChart" src="https://user-images.githubusercontent.com/87200889/143315782-762486ec-bef4-42d0-afa0-f474fee19928.png"> | <img width="341" alt="PieChart" src="https://user-images.githubusercontent.com/87200889/143315797-1775f5b6-03a1-4c29-88ca-5a0256743e92.png"> | <img width="341" alt="RadarChart" src="https://user-images.githubusercontent.com/87200889/143315817-d930c75f-4d8c-4f2d-9828-1e9786bf31b0.png">

## Installation

You can easily add this package to your app via **Swift Package Manager**. Just add this Swift package in Xcode using this Github repository url. (File > Add Packages...)

## Author
Marcus Wittenstam

## Usage
```swift

import SwiftBI 
```

### Bar Chart
```swift
    let barChartDataSet = [
         BarChartData(label: "January", value: 340.32),
         BarChartData(label: "February", value: 250.0),
         BarChartData(label: "March", value: 430.22),
         BarChartData(label: "April", value: 350.0),
         BarChartData(label: "May", value: 450.0),
         BarChartData(label: "June", value: 380.0),
         BarChartData(label: "July", value: 365.98),
         BarChartData(label: "August", value: 450.0),
         BarChartData(label: "September", value: 380.0),
         BarChartData(label: "Oktober", value: 365.98),
         BarChartData(label: "November", value: 450.0),
         BarChartData(label: "December", value: 380.0)
     ]
     
    var body: some View {
        BarChart(title: "Monthly Sales", legend: "Month", dataUnit: "SEK", barColor: .blue, maxValue: 0, data: barChartDataSet)
             .frame(height: 500)
    }
```

### Line Chart
```swift
   let singleLineChartDataSet = [
        LineChartDataLine(label: "2021", color: Color.pink, isFilled: false, isCurved: true, value:
            [
                LineChartData(label: "January", value: 340.32),
                LineChartData(label: "February", value: 250.0),
                LineChartData(label: "March", value: 430.22),
                LineChartData(label: "April", value: 350.0),
                LineChartData(label: "May", value: 450.0),
                LineChartData(label: "June", value: 380.0),
                LineChartData(label: "July", value: 365.98)
            ]
        )
    ]
     
    var body: some View {
        LineChart(title: "Montly Sales", legend: "Month", dataUnit: "SEK", maxValue: 0, data: singleLineChartDataSet)
            .frame(height: 400)
    }
```

### Multi Line Chart
```swift
   let multiLineChartDataSet = [
        LineChartDataLine(label: "2019", color: Color.green, isFilled: true, isCurved: true, value:
            [
                LineChartData(label: "January", value: 340.32),
                LineChartData(label: "February", value: 250.0),
                LineChartData(label: "March", value: 430.22),
                LineChartData(label: "April", value: 350.0),
                LineChartData(label: "May", value: 450.0),
                LineChartData(label: "June", value: 380.0),
                LineChartData(label: "July", value: 365.98)
            ]
        ),
        LineChartDataLine(label: "2020", color: Color.blue, isFilled: false, isCurved: true, value:
            [
                LineChartData(label: "January", value: 250.32),
                LineChartData(label: "February", value: 360.0),
                LineChartData(label: "March", value: 290.22),
                LineChartData(label: "April", value: 510.0),
                LineChartData(label: "May", value: 410.0),
                LineChartData(label: "June", value: 180.0),
                LineChartData(label: "July", value: 305.98)
            ]
        ),
        LineChartDataLine(label: "2021", color: Color.red, isFilled: false, isCurved: true, value:
            [
                LineChartData(label: "January", value: 290.32),
                LineChartData(label: "February", value: 310.0),
                LineChartData(label: "March", value: 240.22),
                LineChartData(label: "April", value: 480.0),
                LineChartData(label: "May", value: 460.0),
                LineChartData(label: "June", value: 290.0),
                LineChartData(label: "July", value: 430.98)
            ]
        )
    ]
     
    var body: some View {
        LineChart(title: "Montly Sales", legend: "Month", dataUnit: "SEK", maxValue: 0, data: multiLineChartDataSet)
            .frame(height: 400)
    }
```

### Radar Chart
```swift
    let radarChartDataSet = [
        RadarChartData(label: "January", value: 340.32),
        RadarChartData(label: "February", value: 250.0),
        RadarChartData(label: "March", value: 430.22),
        RadarChartData(label: "April", value: 350.0),
        RadarChartData(label: "May", value: 450.0),
        RadarChartData(label: "June", value: 380.0),
        RadarChartData(label: "July", value: 365.98)
     ]
     
    var body: some View {
        RadarChart(title: "Monthly Sales", gridColor: Color.gray, dataColor: Color.purple, dataUnit: "SEK", legend: "Month", data: radarChartDataSet, maxValue: 0, divisions: 10)
          .frame(height: 400)
    }
```

### Pie Chart
```swift
    let pieChartDataSet = [
        PieChartData(label: "January", value: 150.32),
        PieChartData(label: "February", value: 202.32),
        PieChartData(label: "March", value: 390.22),
        PieChartData(label: "April", value: 350.0),
        PieChartData(label: "May", value: 460.33),
        PieChartData(label: "June", value: 320.02),
        PieChartData(label: "July", value: 50.98)
    ]
     
    var body: some View {
        PieChart(title: "Montly Sales", dataUnit: "SEK", data: pieChartDataSet)
            .frame(height: 500)
    }
```

