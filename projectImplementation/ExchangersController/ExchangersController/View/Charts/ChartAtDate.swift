

import SwiftUI
import Charts

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let time: Date
    let glucoseLevel: Double?
    let carbExchangers: Double?
    let protFatExchangers: Double?
}

func dateFromString(_ time: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.date(from: time) ?? Date()
}

struct ChartAtDate: View {
    @ObservedObject var chartState: GlucoseAtDateState
    
    let upperBoundOfGlucoseLevel = 350
    let tickSteps = 7
    let exchangersTickSize = 5
    
    struct TimePoint {
        let id: UUID = UUID()
        let value: Int
        let time: Date
    }
    
    func glucoseTickSize()->Int {
        return self.upperBoundOfGlucoseLevel / self.tickSteps
    }
    
    func glucoseTickValue()->Int{
        self.upperBoundOfGlucoseLevel/self.tickSteps
    }
    
    
    func getTimeDomainBounds(_ timePoints: [TimePoint]) ->(Date, Date) {
        let allTimes = timePoints.map({$0.time})
        
        let calendar = Calendar.current
        
        let minPoint = allTimes.min()!
        let minHour = calendar.dateComponents([.hour], from: minPoint).hour!
        
        let maxPoint = allTimes.max()!
        let maxhour = calendar.dateComponents([.hour], from: maxPoint).hour!
        
        return (
            (minHour > 0 ? calendar.date(byAdding: .hour, value: -1, to: minPoint)! : minPoint),
            (maxhour < 23 ? calendar.date(byAdding: .hour, value: 1, to: maxPoint)! : maxPoint)
        )
        
    }
    
    
    func determineRange(_ glucoseLevels: [TimePoint], _ dishesAtDay: [TimePoint]) ->ClosedRange<Date> {
        var contextDate = Date()
        if !glucoseLevels.isEmpty {
            contextDate = glucoseLevels[0].time
        }
        else if !dishesAtDay.isEmpty {
            contextDate = dishesAtDay[0].time
        }
        return startOfDay(contextDate)...endOfDay(contextDate).addingTimeInterval(1)
    }
    
    var body: some View {
        let glucoseLevels = self.chartState.glucoseAtDate
        let dishesAtDay = self.chartState.getDishesGroupedByHHMM()
        
        let glucoseType = "Glucose"
        let wwType = "WW"
        let wbtType = "WBT"
        
        let timeType = "Time"
        
        let exchangersScaleFactor = self.upperBoundOfGlucoseLevel/(self.tickSteps*self.exchangersTickSize)
        
        let dataSets = [
            (type: wwType, data: dishesAtDay.map({dish in
                TimePoint(
                    value: dish.getSumWW() * exchangersScaleFactor,
                    time: dish.date
                )
            })),
            (type: wbtType, data: dishesAtDay.map({dish in
                TimePoint(
                    value: dish.getSumWbt() * exchangersScaleFactor,
                    time: dish.date
                )
            })),
            (type: glucoseType, data: glucoseLevels.map({reading in
                TimePoint(
                    value: reading.measuredValue,
                    time: reading.timeOfMeasurement
                )
                
            }))
        ]
        
        
        Chart(dataSets,id: \.type) {dataSet in
            let data: [TimePoint] = dataSet.data
            ForEach(data, id: \.self.time){point in
                if dataSet.type == glucoseType {
                    LineMark(
                        x: .value(timeType, point.time),
                        y: .value(glucoseType, point.value)
                    )
                    .foregroundStyle(
                        by: .value("Value", glucoseType)
                    )
                    .symbol(Circle())
                }
                if dataSet.type != glucoseType {
                    BarMark(
                        x: .value(timeType, point.time),
                        y: .value(wwType, point.value),
                        width: 6
                    )
                    .position(by: .value(timeType, dataSet.type))
                    .foregroundStyle(
                        by: .value("Value", dataSet.type)
                    )
                    .cornerRadius(10)
                }
            }
        }
        .chartYScale(domain: 0...self.upperBoundOfGlucoseLevel)
        .chartYAxis {
            AxisMarks(
                position: .trailing,
                values: Array(
                    stride(
                        from: 0,
                        through: self.upperBoundOfGlucoseLevel,
                        by: glucoseTickSize()
                    )
                )
            ){
                axis in
                AxisValueLabel("\(axis.index * self.exchangersTickSize)", centered: false)
                AxisTick()
            }
            AxisMarks(
                position: .leading,
                values: Array(
                    stride(
                        from: 0,
                        through: self.upperBoundOfGlucoseLevel,
                        by: glucoseTickSize()
                    )
                )
            ) { value in
                AxisValueLabel("\(Int(value.as(Double.self)!))")
                AxisTick()
                AxisGridLine()
            }
        }
        .chartXScale(
            domain: determineRange(
                dataSets[2].data,
                dataSets[1].data
            ),
            range: .plotDimension(padding: 3)
        )
        .chartXAxis {
            AxisMarks(values: .stride(by: .hour, count: 2)) { value in
                AxisValueLabel(
                    format: .dateTime.hour(),
                    centered: true)
                AxisTick()
                AxisGridLine()
            }
        }
        .chartXAxisLabel("Time of day", alignment: .center)
        .chartYAxisLabel("Glucose Levels (mg/dl)", position: .leading)
        .chartYAxisLabel("Exchangers Levels", position: .trailing)
        .chartForegroundStyleScale([
            glucoseType : Color(.blue),
            wwType: Color(.yellow),
            wbtType: Color(.red)]
        )
        .frame(height: UIScreen.main.bounds.height*0.5)
    }
}


#Preview {
    let model = DataModel(
        glucoseReadings:
            ModelExamples.glucoseReadings + [
            GlucoseReading(
                measuredValue: 190,
                timeOfMeasurement: createDate(hour: 23, minute: 59)!),
            GlucoseReading(
                measuredValue: 200,
                timeOfMeasurement: createDate(hour: 0, minute: 0)!)
        ],
        storedEmailAddresses: ModelExamples.emails,
        storedDishes: ModelExamples.dishes,
        storedFoodDatabase: FoodDatabase(storedFoodModels: []))
    
    var presence = PopupPresenceObserver()
    
    var deb = GlucoseAtDateState(dataModel: model, dateToPick: Date())
    
    ChartAtDate(chartState: deb)
}
