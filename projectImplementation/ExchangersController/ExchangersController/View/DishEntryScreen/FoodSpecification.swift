

import SwiftUI

struct FoodSpecification: View {
    private var stateOfTile: MiniCollapsibleState
    
    @ObservedObject var definitionOfDosage: DosageSpecificationDefinition
    
    var closureOfXButton: ()->Void
    
    init(foodDosage: FoodDosage,
         stateOfTile: MiniCollapsibleState = MiniCollapsibleState(isDisclosed: true),
         closureOfXButton:@escaping ()->Void = {}
    ) {
        self.definitionOfDosage=DosageSpecificationDefinition(
            pieceMass: String(foodDosage.mass),
            count: String(foodDosage.count),
            actualFood: foodDosage.getActualFood()
        )
        
        self.closureOfXButton = closureOfXButton
        
        self.stateOfTile = stateOfTile
    }
    
    init(foodModel: FoodModel,
         isLocal:Bool,
         stateOfTile: MiniCollapsibleState = MiniCollapsibleState(isDisclosed: true),
         closureOfXButton:@escaping ()->Void = {}) {
        let initDosage=FoodDosage(mass: 0, count: 0, actualFood: foodModel)
        self.init(foodDosage: initDosage, stateOfTile: stateOfTile, closureOfXButton: closureOfXButton)
    }
    
    init(readyDosageSpec: DosageSpecificationDefinition,
         stateOfTile: MiniCollapsibleState = MiniCollapsibleState(isDisclosed: true),
         closureOfXButton:@escaping ()->Void = {}){
        self.definitionOfDosage = readyDosageSpec
        self.closureOfXButton = closureOfXButton
        
        self.stateOfTile = stateOfTile
    }
    
    func turnToDiscard(){
        withAnimation(.smooth){
            self.stateOfTile.isDisclosed = true
        }
    }
    
    var body: some View {
        let smallView = HStack(alignment: .center, spacing: 10) {
            FoodNotation(
                foodModel: self.definitionOfDosage.actualFood)
            Spacer()
            Button(action: {
                self.turnToDiscard()
                self.closureOfXButton()
            }) {
                Image(systemName: "xmark")
                    .font(.title)
                    .foregroundColor(.red)
            }
        }
        .padding(10)
        
        let toExpand=HStack{
            VStack{
                SpecificationInput(definitionOfDosage: self.definitionOfDosage)
                VStack(spacing: 10) {
                    ShortExchangersSummary(
                        dataToPresent: self.definitionOfDosage.dynamicDosage().getExchagersSummary(),
                        thirdRowName: "Kcal:")
                }
                .padding()
                .background(StyleElementsGetter.appBackLightGrey)
            }
        }
            .padding()
            .frame(maxWidth: .infinity)
            .background(StyleElementsGetter.appBackLightGrey)
        
        CollapsibleTile(
            miniState: self.stateOfTile,
            shouldGoRight: false,
            headerContent: AnyView(smallView),
            contentToExpand: AnyView(toExpand))
    }
}

#Preview {
    let headerTitle = "Today"
    let innerData = BriefExchangersSummary(wwValue: 50,wbtValue: 21,kcal: 900)
    FoodSpecification(foodDosage: Example.complexDosages[0])
}
