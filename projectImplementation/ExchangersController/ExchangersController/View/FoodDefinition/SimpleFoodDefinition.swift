

import SwiftUI

struct SimpleFoodDefinition: View {
    @ObservedObject var simpleFoodSpec: SimpleFoodSpecification
    var outerPadding: CGFloat
    
    init(
        simpleModel: SimpleFood,
        outerPadding: CGFloat = 10
    ) {
        self.simpleFoodSpec = SimpleFoodSpecification(actualFoodModel: simpleModel)
        self.outerPadding = outerPadding
    }
    
    init(
        simpleSpecification: SimpleFoodSpecification,
        outerPadding: CGFloat = 10
    ){
        self.simpleFoodSpec = simpleSpecification
        self.outerPadding = outerPadding
    }
    
    init () {
        self.init(simpleModel: SimpleFood.createDefaultModel())
    }
    
    func getRectDiv()->AnyView{
        return AnyView(Rectangle()
            .foregroundColor(.black)
            .frame(height: 1)
            .foregroundColor(StyleElementsGetter.separatorsNotOpaque)
            .padding(.top, 3))
    }
    
    func getLeftElementForNutritient(_ nutr: Nutritient)->AnyView {
        AnyView(
            HStack {
                Text(getNutriteintName(nutr))
                    .padding(.leading, NameValuePair.leadingInset)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    getImageForNutr(nutr)
                        .font(.title3)
                }
            }
        )
    }
    
    var body: some View {
        FoodNotationCreator(modelSpec: simpleFoodSpec, isLocal: true)
        VStack{
            InputAttr(
                name: "Mass specifier",
                unit: FoodModel.massUnit,
                outerBuffer: $simpleFoodSpec.userSpecifier)
            VStack{
                InputAttr(
                    complexLeftView: getLeftElementForNutritient(.carb),
                    textFieldWidth: 120,
                    unit: FoodModel.massUnit,
                    outerBuffer: $simpleFoodSpec.userCarbs
                )
                .padding(.trailing)
                self.getRectDiv()
                InputAttr(
                    complexLeftView: getLeftElementForNutritient(.prot),
                    textFieldWidth: 120,
                    unit: FoodModel.massUnit,
                    outerBuffer: $simpleFoodSpec.userProt
                )
                .padding(.trailing)
                self.getRectDiv()
                InputAttr(
                    complexLeftView: getLeftElementForNutritient(.fat),
                    textFieldWidth: 120,
                    unit: FoodModel.massUnit,
                    outerBuffer: $simpleFoodSpec.userFat
                )
                .padding(.trailing)
            }
            .padding(.vertical)
            .background(StyleElementsGetter.appStrongGray)
            .cornerRadius(StyleElementsGetter.boldCorners)
            .overlay(
                RoundedRectangle(cornerRadius: StyleElementsGetter.boldCorners)
                    .inset(by: 1.5)
                    .stroke(.black, lineWidth: 1)
            )
        }
        .padding(self.outerPadding)
        .background(StyleElementsGetter.appBackLightGrey)
        .cornerRadius(StyleElementsGetter.boldCorners)
        
        VStack(spacing: 10) {
            ShortExchangersSummary(
                dataToPresent: self.simpleFoodSpec.getExchangerSummary(), thirdRowName: "Kcal:")
        }
    }
}

#Preview {
    SimpleFoodDefinition()
}
