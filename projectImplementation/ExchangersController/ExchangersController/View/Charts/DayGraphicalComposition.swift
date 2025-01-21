

import SwiftUI

struct DayGraphicalComposition: View {
    var state: GlucoseAtDateState
    var bodySpacing: CGFloat = 10
    
    func getFirstExpansion() -> some View {
        VStack(spacing: 20){
            HStack{
                Text("Time")
                Spacer()
                Text("Level")
            }
            ForEach(state.glucoseAtDate.indices, id: \.self){index in
                let reading: GlucoseReading = state.glucoseAtDate[index]
                
                HStack{
                    Text("\(getFormatInHHMM(reading.timeOfMeasurement))")
                    Spacer()
                    HStack{
                        Text("\(reading.measuredValue)")
                    }
                }
            }
        }
            .font(.title3)
            .padding()
            .background(StyleElementsGetter.appBackLightGrey)
    }
    
    func getSecondExpansion()->some View {
        VStack(spacing: 20){
            HStack{
                Text("Time")
                Spacer()
                Text("WW")
                Spacer()
                Text("WBT")
            }
            let dishesAtDay = state.getDishesAtSetDate()
            ForEach(dishesAtDay.indices, id: \.self){index in
                let dish: Dish = dishesAtDay[index]
                HStack{
                    Text("\(getFormatInHHMM(dish.date))")
                    Spacer()
                    Text("\(dish.getSumWW())")
                    Spacer()
                    Text("\(dish.getSumWbt())")
                    
                }
            }
        }
            .font(.title3)
            .padding()
            .background(StyleElementsGetter.appBackLightGrey)
    }
    
    var body: some View {
        VStack(spacing: 10){
            HStack{
                Text("\(getFormatInDDMMYYYY(state.dateToPick))")
                    .font(.title)
                Spacer()
            }
            ChartAtDate(chartState: self.state)
            let fistExpansion = getFirstExpansion()
            CollapsibleTile(
                headerContent: AnyView(
                    Text("Glucose levels list")
                        .font(.title3)
                ),
                contentToExpand: AnyView(fistExpansion))
            CollapsibleTile(
                headerContent: AnyView(
                    Text("Exchangers levels list")
                        .font(.title3)
                ),
                contentToExpand: AnyView(getSecondExpansion()))
        }
        .padding(.horizontal)
    }
}

#Preview {
    let model = DataModel(
        glucoseReadings: ModelExamples.glucoseReadings,
        storedEmailAddresses: ModelExamples.emails,
        storedDishes: ModelExamples.dishes,
        storedFoodDatabase: FoodDatabase(storedFoodModels: []))
    
    var presence = PopupPresenceObserver()
    
    var deb = GlucoseAtDateState(dataModel: model, dateToPick: Date())
    
    DayGraphicalComposition(state: deb)
}
