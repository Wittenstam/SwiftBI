//
//  SwiftUIView.swift
//  
//
//  Created by Marcus Wittenstam on 2021-11-14.
//

import SwiftUI


public struct LineChart: View {
    
    var title: String
    var legend: String
    var dataUnit: String
    var maxValue: Double
    var data: LineChartDataLineList
        
    @State private var currentValue = ""
    @State private var currentLabel = ""
    @State private var touchLocation: CGPoint = .init(x:0, y:0)
    @State private var touchPoint: CGPoint = .init(x:0, y:0)
    @State private var selectedLineIndex = -1
    @State private var isSelectedIndex = -1

    public init(
                title: String,
                legend: String,
                dataUnit: String,
                maxValue: Double = 0,
                data: LineChartDataLineList
    ) {
        self.title = title
        self.legend = legend
        self.dataUnit = dataUnit
        self.maxValue = maxValue
        self.data = data
    }
    

    
    private var gridItemLayout:[GridItem] {
        var items = [GridItem]()
        for _ in data.LineChartDataLineList {
            items.append(GridItem(.flexible()))
        }
        return items
    }

    public var body: some View {
        VStack(alignment: .leading) {
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
                                    .animation(.easeIn)
                            }
                            if (!currentValue.isEmpty && currentValue != "-1.0") {
                                Text("\(currentValue) \(dataUnit)")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(5)
                                    .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                                    .offset(x: labelOffset(in: geometry.frame(in: .local).width))
                                    .animation(.easeIn)
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
                                ForEach(0..<self.data.LineChartDataLineList.count){ index in
                                        LineChartLine(
                                            data: data.LineChartDataLineList,
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
                            ForEach(0..<data.LineChartDataLineList.count)   {    i in
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
                                            data.LineChartDataLineList[i].color
                                                .aspectRatio(contentMode: .fit)
                                                .frame(minWidth: 0, maxWidth: 30, minHeight: 30)
                                                .padding(5)
                                            Text(data.LineChartDataLineList[i].label)
                                                .font(.caption)
                                                .fontWeight(.heavy)
                                        }
                                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.clear).shadow(radius: 3))
                                    }
                                    else {
                                        HStack {
                                            data.LineChartDataLineList[i].color
                                                .aspectRatio(contentMode: .fit)
                                                .frame(minWidth: 0, maxWidth: 20, minHeight: 20)
                                                .padding(5)
                                            Text(data.LineChartDataLineList[i].label)
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
        .padding()
    }
        

    
    
    func updateCurrentValue() {
        
        if (data.LineChartDataLineList.count > 0 && data.LineChartDataLineList.count < 2) {
            let index = Int(touchLocation.x * CGFloat(data.LineChartDataLineList[0].value.count))
            guard index < data.LineChartDataLineList[0].value.count && index >= 0 else {
                currentValue = ""
                currentLabel = ""
                return
            }
            currentValue = "\(data.LineChartDataLineList[0].value[index].value)"
            currentLabel = data.LineChartDataLineList[0].value[index].label
        }
        else if (data.LineChartDataLineList.count >= 2 && selectedLineIndex != -1) {
            let index = Int(touchLocation.x * CGFloat(data.LineChartDataLineList[selectedLineIndex].value.count))
            guard index < data.LineChartDataLineList[selectedLineIndex].value.count && index >= 0 else {
                currentValue = ""
                currentLabel = ""
                return
            }
            currentValue = "\(data.LineChartDataLineList[selectedLineIndex].value[index].value)"
            currentLabel = data.LineChartDataLineList[selectedLineIndex].value[index].label
        }
        
    }
    
    func resetValues() {
        touchLocation = CGPoint(x:0, y:0)
        currentValue  =  ""
        currentLabel = ""
    }
    
    func labelOffset(in width: CGFloat) -> CGFloat {
        var position: CGFloat = 0
        if (data.LineChartDataLineList.count > 0 && data.LineChartDataLineList.count < 2) {
            let currentIndex = Int(touchLocation.x * CGFloat(data.LineChartDataLineList[0].value.count))
            guard currentIndex < data.LineChartDataLineList[0].value.count && currentIndex >= 0 else {
                return 0
            }
            let cellWidth = width / CGFloat(data.LineChartDataLineList[0].value.count)
            let actualWidth = width - cellWidth
            position = cellWidth * CGFloat(currentIndex) - actualWidth/2
        }
        else if (data.LineChartDataLineList.count >= 2 && selectedLineIndex != -1) {
            let currentIndex = Int(touchLocation.x * CGFloat(data.LineChartDataLineList[selectedLineIndex].value.count))
            guard currentIndex < data.LineChartDataLineList[selectedLineIndex].value.count && currentIndex >= 0 else {
                return 0
            }
            let cellWidth = width / CGFloat(data.LineChartDataLineList[selectedLineIndex].value.count)
            let actualWidth = width - cellWidth
            position = ( cellWidth * CGFloat(currentIndex) ) - ( actualWidth / 2 )
        }
        return position
    }
    
    
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineChart(title: "Montly Sales", legend: "Month", dataUnit: "SEK", maxValue: 0, data: lineChartDataSet)
        }
    }
}
