

import SwiftUI

struct DishSummary: View {
    var dishComposition: Dish
    var editClosure: ()->Void
    var alertCallClosure: ()->Void
    
    let addGlucoseComposition: some View = HStack {
        AppButton.transformImageFromSystemName(name: "plus")
        AppButton.transformImageFromName(name: "DropImg", scaleFactor: 0.4)
    }
    
    var body: some View {
        let smallView = HStack(alignment: .center, spacing: 10) {
            Button(action: {
                editClosure()
            }) {
                Image(systemName: "square.and.pencil")
                    .font(.title)
                    .foregroundColor(.primary)
            }
            Text(self.dishComposition.getStrTimeOfDay())
                .font(Font.title2)
              .multilineTextAlignment(.center)
              .foregroundColor(.black)
              .frame(width: 110, height: 39, alignment: .center)
        }
        .padding(10)
        
        let toExpand=HStack{
            VStack(spacing: 10) {
                ForEach(dishComposition.getDosages()){dosage in
                    HStack{
                        FoodNotation(foodModel: dosage.getActualFood())
                        Spacer()
                        Text("\(dosage.totalMass())\(FoodModel.massUnit)")
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .cornerRadius(StyleElementsGetter.boldCorners)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .inset(by: 1.5)
                    .stroke(.black, lineWidth: 3)
            )
        }
            .padding()
            .frame(maxWidth: .infinity)
            .background(StyleElementsGetter.appBackLightGrey)
        
        let stickyContent = VStack(spacing: 10) {
            ShortExchangersSummary(dataToPresent: self.dishComposition.getExchagersSummary(), thirdRowName: "Kcal:")
            
            ZStack {
                AppButton(action: self.alertCallClosure, extraElement: AnyView(addGlucoseComposition))
            }
            .padding(.horizontal, 3)
        }
        .padding()
        .background(StyleElementsGetter.appBackLightGrey)
        
        CollapsibleTile(headerContent: AnyView(smallView),contentToExpand: AnyView(toExpand), stickyContent: AnyView(stickyContent))
        
    }
}

#Preview {
    let briefSummary = BriefExchangersSummary(wwValue: 10, wbtValue: 20, kcal: 1000)
    let actualTime = DateComponents(hour: 6, minute: 51)
    
    let dishSummary = DishSummaryData(time: actualTime, exchangers: briefSummary)
    
    DishSummary(
        dishComposition: Example.dishes[2],
        editClosure: {},
        alertCallClosure: {}
    )
}
