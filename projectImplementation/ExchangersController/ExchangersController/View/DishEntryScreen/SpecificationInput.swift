

import SwiftUI

struct SpecificationInput: View {
    @ObservedObject var definitionOfDosage: DosageSpecificationDefinition
    
    var body: some View {
        VStack(spacing: 10) {
            InputAttr(
                name: "Piece mass",
                textFieldWidth: 150,
                unit: FoodModel.massUnit,
                outerBuffer: $definitionOfDosage.pieceMass
            )
            InputAttr(
                name: "Count",
                textFieldWidth: 150,
                unit: "  ",
                outerBuffer: $definitionOfDosage.count
            )
            HStack {
                Text("Total mass")
                Spacer()
                Text("\(String(definitionOfDosage.getTotalMass()))\(FoodModel.massUnit)")
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
}

#Preview {
    var definitionOfDosage=DosageSpecificationDefinition(
        pieceMass: String(100),
        count: String(1),
        actualFood: Example.simFoods.first!
    )
    SpecificationInput(definitionOfDosage: definitionOfDosage)
}
