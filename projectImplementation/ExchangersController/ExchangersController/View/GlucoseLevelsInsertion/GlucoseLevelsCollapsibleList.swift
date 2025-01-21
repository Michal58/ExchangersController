

import SwiftUI

struct GlucoseLevelsCollapsibleList: View {
    var state: GlucoseAtDateState
    
    
    struct LocalExapnsion: View {
        @ObservedObject var state: GlucoseAtDateState
        
        var body: some View {
            VStack(spacing: 20){
                HStack{
                    Text("Time")
                    Spacer()
                    Text("Level")
                    
                    Spacer()
                        .frame(width: 28)
                }
                ForEach(state.glucoseAtDate.indices, id: \.self){index in
                    let reading: GlucoseReading = state.glucoseAtDate[index]
                    
                    HStack{
                        Text("\(getFormatInHHMM(reading.timeOfMeasurement))")
                        Spacer()
                        HStack{
                            Text("\(reading.measuredValue)")
                            
                            Button(action: {
                                withAnimation(.smooth){
                                    self.state.removeReadingAt(index)
                                }
                            }){
                                Image(systemName: "xmark")
                                    .foregroundColor(Color.red)
                                    .font(.title2)
                            }
                            
                        }
                    }
                }
            }
                .font(.title3)
                .padding()
                .background(StyleElementsGetter.appBackLightGrey)
        }
    }
    
    var body: some View {
        
        CollapsibleTile(
            headerContent: AnyView(
                Text("Glucose levels list")
                    .font(.title3)
            ),
            contentToExpand: AnyView(
                LocalExapnsion(state: self.state)
            ))
        
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
    
    GlucoseLevelsCollapsibleList(
        state: deb)
}
