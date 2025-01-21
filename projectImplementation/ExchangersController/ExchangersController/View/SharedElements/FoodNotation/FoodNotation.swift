

import SwiftUI

struct FoodNotation: View {
    var foodModel: FoodModel
    
    var mainSpacing: CGFloat = 5
    var paramSpacing: CGFloat = 3
    
    var body: some View {
        VStack(spacing: self.mainSpacing) {
            FoodShortNotation(isFoodComplex: self.foodModel is ComplexFood, foodTitle: self.foodModel.name, isFoodLocallyStored: self.foodModel.isLocal())
            Divider()
            VStack(spacing: paramSpacing) {
                HStack(alignment: .top) {
                    // Space Between
                    Text("Kcal: \(self.foodModel.getKcal())")
                    Spacer()
                    // Alternative Views and Spacers
                    Text("/\(self.foodModel.massSpecifier)\(FoodModel.massUnit)")
                }
                .frame(maxWidth: .infinity, alignment: .top)
                
                HStack(alignment: .center) {
                    Text("Carb: \(foodModel.getCarbohydrates())\(FoodModel.massUnit)")
                    Spacer()
                    Divider()
                        .frame(maxHeight: 25)
                    Spacer()
                    Text("Prot: \(foodModel.getProteins())\(FoodModel.massUnit)")
                    Spacer()
                    Divider()
                        .frame(maxHeight: 25)
                    Spacer()
                    Text("Fat: \(foodModel.getFat())\(FoodModel.massUnit)")
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
    FoodNotation(foodModel: foodModel)
}
