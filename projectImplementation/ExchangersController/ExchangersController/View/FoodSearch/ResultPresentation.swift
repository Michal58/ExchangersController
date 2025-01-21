

import SwiftUI

struct ResultPresentation: View {
    var actualResult: FoodModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 3) {
            FoodNotation(foodModel: actualResult)
                .padding()
                .background(StyleElementsGetter.appStrongGray)
            VStack {
                NutritientValuePresentation(
                    nutritientType: .carb,
                    mass: actualResult.getCarbohydrates(),
                    specifier: actualResult.massSpecifier
                )
                NutritientValuePresentation(
                    nutritientType: .prot,
                    mass: actualResult.getProteins(),
                    specifier: actualResult.massSpecifier
                )
                NutritientValuePresentation(
                    stroke: false,
                    nutritientType: .fat,
                    mass: actualResult.getFat(),
                    specifier: actualResult.massSpecifier
                )
            }
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity)
        .background(StyleElementsGetter.appMediumGrey)
        .cornerRadius(StyleElementsGetter.boldCorners)
    }
}

#Preview {
    let res = Example.simFoods[0]
    ResultPresentation(actualResult: res)
}
