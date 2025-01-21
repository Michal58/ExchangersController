

import SwiftUI


func mockDosageGetter() -> FoodDosage {
    [
        FoodDosage(mass: 200, count: 1, actualFood: Example.simFoods[0]),
        FoodDosage(mass: 150, count: 1, actualFood: Example.simFoods[1]),
        FoodDosage(mass: 100, count: 1, actualFood: Example.complexFood[0])
    ].randomElement()!
}

class InputTileState{
    var dosage: FoodDosage
    var isDisclosed: Bool
    
    init(dosage: FoodDosage, isDisclosed: Bool) {
        self.dosage = dosage
        self.isDisclosed = isDisclosed
    }
}

struct ComplexFoodDefinition: View {
    @ObservedObject var complexFoodSpec: ComplexFoodSpecification
    var controller: AppController
    var tilesSpacing: CGFloat
    
    init(
        complexFoodToProcess: ComplexFood,
        controller: AppController
    ) {
        self.controller = controller
        self.complexFoodSpec = ComplexFoodSpecification(actualFoodModel: complexFoodToProcess)
        self.tilesSpacing = 10
    }
    
    init(
        complexSpecification: ComplexFoodSpecification,
        tileSpacing: CGFloat = 10,
        controller: AppController
        
    ){
        self.controller = controller
        self.complexFoodSpec = complexSpecification
        self.tilesSpacing = tileSpacing
    }
    
    init(controller: AppController) {
        self.init(
            complexFoodToProcess: ComplexFood.createDefaultModel(),
            controller: controller
        )
    }
    
    var body: some View {
        FoodNotationCreator(
            modelSpec: self.complexFoodSpec,
            isLocal: true)
        AppButton(
            action: {
                self.controller.addDosageToComplexSpecification(
                    complexSpecification: self.complexFoodSpec
                )
            },
            text: "Add food  ",
            extraElement: AnyView(AppButton.transformImageFromSystemName(name: "plus"))
        )
        
        LazyVStack(spacing: self.tilesSpacing){
            ForEach(0..<self.complexFoodSpec.foodDosages.indices.count, id: \.self) { index in
                let dosage = self.complexFoodSpec.foodDosages[index]
                
                
                let foodSpec = FoodSpecification(
                    foodDosage: dosage,
                    stateOfTile: self.complexFoodSpec.optionalStateOfTile[index]) {
                    withAnimation(.smooth){
                        self.complexFoodSpec.removeDosage(index)
                    }
                }
                
                foodSpec
                    .onReceive(foodSpec.definitionOfDosage.objectWillChange) {newCount in
                        
                        self.complexFoodSpec.modifyDosage(
                            dosage: foodSpec.definitionOfDosage.dynamicDosage(),
                            index: index)
                    }
            }
            InputAttr(
                name: "Mass specifier",
                unit: FoodModel.massUnit,
                outerBuffer: $complexFoodSpec.userSpecifier)
            VStack(spacing: 10) {
                ShortExchangersSummary(
                    dataToPresent: self.complexFoodSpec.getExchangerSummary(), thirdRowName: "Kcal:")
            }
        }
    }
    
}

#Preview {
    let controller = AppController()
    ComplexFoodDefinition(
        complexFoodToProcess: Example.complexFood[2],
        controller: controller
    )
}
