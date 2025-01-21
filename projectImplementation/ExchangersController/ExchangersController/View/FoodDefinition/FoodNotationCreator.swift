

import SwiftUI

struct FoodNotationCreator: View {
    @ObservedObject var modelSpec: FoodModelSpecification
    var isLocal: Bool
    
    var mainSpacing: CGFloat
    var paramSpacing: CGFloat
    
    init(modelSpec: FoodModelSpecification,
         isLocal: Bool,
         mainSpacing: CGFloat = 5,
         paramSpacing: CGFloat = 3) {
        self.modelSpec = modelSpec
        self.isLocal = isLocal
        self.mainSpacing = mainSpacing
        self.paramSpacing = paramSpacing
    }
    
    var body: some View {
        
        VStack(spacing: self.mainSpacing) {
            
            ShortNotationCreator(
                specification: self.modelSpec,
                isFoodComplex: self.modelSpec.actualFoodModel is ComplexFood,
                isFoodLocallyStored: self.isLocal)
            Divider()
            VStack(spacing: paramSpacing) {
                HStack(alignment: .top) {
                    // Space Between
                    Text("Kcal: \(self.modelSpec.actualFoodModel.getKcal())")
                    Spacer()
                    // Alternative Views and Spacers
                    Text("/\(self.modelSpec.actualFoodModel.massSpecifier)\(FoodModel.massUnit)")
                }
                .frame(maxWidth: .infinity, alignment: .top)
                
                HStack(alignment: .center) {
                    Text("Carb: \(modelSpec.actualFoodModel.getCarbohydrates())\(FoodModel.massUnit)")
                    Spacer()
                    Divider()
                        .frame(maxHeight: 25)
                    Spacer()
                    Text("Prot: \(modelSpec.actualFoodModel.getProteins())\(FoodModel.massUnit)")
                    Spacer()
                    Divider()
                        .frame(maxHeight: 25)
                    Spacer()
                    Text("Fat: \(modelSpec.actualFoodModel.getFat())\(FoodModel.massUnit)")
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

#Preview {
    let foodModel = Example.simFoods.first!
    let modelSpec = FoodModelSpecification(actualFoodModel: foodModel)
    FoodNotationCreator(modelSpec: modelSpec, isLocal: true)
}
