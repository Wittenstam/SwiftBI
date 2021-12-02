//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-14.
//

import SwiftUI


public struct LineChart: View {
    
    @Binding var title: String
    @Binding var legend: String
    @Binding var dataUnit: String
    @Binding var maxValue: Double
    @Binding var data: [LineChartDataLine]
        
    @State private var currentValue = ""
    @State private var currentLabel = ""
    @State private var touchLocation: CGPoint = .init(x:0, y:0)
    @State private var touchPoint: CGPoint = .init(x:0, y:0)
    @State private var selectedLineIndex = -1
    @State private var isSelectedIndex = -1

    public init(
                title: Binding<String>,
                legend: Binding<String>,
                dataUnit: Binding<String>,
                maxValue: Binding<Double>, //= 0,
                data: Binding<[LineChartDataLine]>
    ) {
        self._title = title
        self._legend = legend
        self._dataUnit = dataUnit
        self._maxValue = maxValue
        self._data = data
    }


    
    private var gridItemLayout:[GridItem] {
        var items = [GridItem]()
        for _ in data {
            items.append(GridItem(.flexible()))
        }
        return items
    }

    public var body: some View {
        VStack(alignment: .leading) {
            if (!data.isEmpty) {
                Text(title)
                    .bold()
                    .font(.largeTitle)
                VStack{
                    GeometryReader{ geometry in
                        VStack {
                            
                            VStack {
                                if currentLabel.isEmpty {
                                    Text("") //legend
                                        .bold()
                                        .foregroundColor(.black)
                                        .padding(5)
                                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.clear).shadow(radius: 3))
                                } else {
                                    Text(currentLabel)
                                        .bold()
                                        .foregroundColor(.black)
                                        .padding(5)
                                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                                        .offset(x: labelOffset(in: geometry.frame(in: .local).width))
                                        .animation(.easeIn, value: 1.0)
                                }
                                if (!currentValue.isEmpty && currentValue != "-1.0") {
                                    Text("\(currentValue) \(dataUnit)")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.black)
                                        .padding(5)
                                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                                        .offset(x: labelOffset(in: geometry.frame(in: .local).width))
                                        .animation(.easeIn, value: 1.0)
                                } else {
                                    Text("")
                                        .bold()
                                        .foregroundColor(.black)
                                        .padding(5)
                                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.clear).shadow(radius: 3))
                                }
                            }
                            .padding(.top)
                            .padding(.top)
                            
                            ZStack{
                                GeometryReader{ reader in
                                    ForEach(0..<self.data.count){ index in
                                            LineChartLine(
                                                data: data,
                                                lineIndex: index,
                                                maxValue: maxValue,
                                                touchLocation: $touchLocation,
                                                isSelectedIndex: $isSelectedIndex,
                                                frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width , height: reader.frame(in: .local).height))
                                            )
                                                .offset(x: 0, y: 0)
                                    }
                                    .offset(x: 0, y: 0) //Y: -100 100
                                }
                                .frame(width: geometry.frame(in: .local).size.width, height: 200)
                            }
                            .frame(width: geometry.frame(in: .local).size.width, height: 200)
                            .gesture(DragGesture(minimumDistance: 0)
                                .onChanged({ position in
                                    let touchPositionX = position.location.x/geometry.frame(in: .local).width
                                    let touchPositionY = position.location.y/geometry.frame(in: .local).height
                                    touchLocation = CGPoint(x: touchPositionX, y: touchPositionY)
                                    touchPoint = CGPoint(x: position.location.x, y: position.location.y)
                                    updateCurrentValue()
                                })
                                .onEnded({ position in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        withAnimation(Animation.easeOut(duration: 0.5)) {
                                            resetValues()
                                        }
                                    }
                                })
                            )
                            
                            LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 10) {
                                ForEach(0..<data.count)   {    i in
                                    Button(action: {
                                        if ( selectedLineIndex == i) {
                                            selectedLineIndex = -1
                                            isSelectedIndex = -1
                                        }
                                        else {
                                            selectedLineIndex = i
                                            isSelectedIndex = i
                                        }
                                    })
                                    {
                                        if ( selectedLineIndex == i) {
                                            HStack {
                                                data[i].color
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(minWidth: 0, maxWidth: 30, minHeight: 30)
                                                    .padding(5)
                                                Text(data[i].label)
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    .font(.system(size: 30))
                                            }
                                            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.clear).shadow(radius: 3))
                                        }
                                        else {
                                            HStack {
                                                data[i].color
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(minWidth: 0, maxWidth: 20, minHeight: 20)
                                                    .padding(5)
                                                Text(data[i].label)
                                                    .font(.caption)
                                                    .bold()
                                            }
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                                //.padding(.top)
                            
                            
                        }
                        .frame(width: geometry.frame(in: .local).size.width, height: 250)
                    }
                }
            }
        }
        .padding()
    }
        

    
    
    func updateCurrentValue() {
        
        if (data.count > 0 && data.count < 2) {
            let index = Int(touchLocation.x * CGFloat(data[0].value.count))
            guard index < data[0].value.count && index >= 0 else {
                currentValue = ""
                currentLabel = ""
                return
            }
            currentValue = "\(data[0].value[index].value)"
            currentLabel = data[0].value[index].label
        }
        else if (data.count >= 2 && selectedLineIndex != -1) {
            let index = Int(touchLocation.x * CGFloat(data[selectedLineIndex].value.count))
            guard index < data[selectedLineIndex].value.count && index >= 0 else {
                currentValue = ""
                currentLabel = ""
                return
            }
            currentValue = "\(data[selectedLineIndex].value[index].value)"
            currentLabel = data[selectedLineIndex].value[index].label
        }
        
    }
    
    func resetValues() {
        touchLocation = CGPoint(x:0, y:0)
        currentValue  =  ""
        currentLabel = ""
    }
    
    func labelOffset(in width: CGFloat) -> CGFloat {
        var position: CGFloat = 0
        if (data.count > 0 && data.count < 2) {
            let currentIndex = Int(touchLocation.x * CGFloat(data[0].value.count))
            guard currentIndex < data[0].value.count && currentIndex >= 0 else {
                return 0
            }
            let cellWidth = width / CGFloat(data[0].value.count)
            let actualWidth = width - cellWidth
            position = cellWidth * CGFloat(currentIndex) - actualWidth/2
        }
        else if (data.count >= 2 && selectedLineIndex != -1) {
            let currentIndex = Int(touchLocation.x * CGFloat(data[selectedLineIndex].value.count))
            guard currentIndex < data[selectedLineIndex].value.count && currentIndex >= 0 else {
                return 0
            }
            let cellWidth = width / CGFloat(data[selectedLineIndex].value.count)
            let actualWidth = width - cellWidth
            position = ( cellWidth * CGFloat(currentIndex) ) - ( actualWidth / 2 )
        }
        return position
    }
    
    
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        previewWrapper()
    }
    
    struct previewWrapper: View {
        @State var title: String = "Montly Sales"
        @State var legend: String = "Month"
        @State var dataUnit: String =  "SEK"
        @State var maxValue: Double = 0
        @State var data : [LineChartDataLine] = [
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
            
        var body: some View {
            LineChart(title: $title, legend: $legend, dataUnit: $dataUnit, maxValue: $maxValue, data: $data)
        }
        
    }
}


