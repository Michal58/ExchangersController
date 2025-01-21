

import SwiftUI

struct NutritientValuePresentation: View {
    var stroke: Bool = true
    var nutritientType: Nutritient
    var mass: Int
    var specifier: Int
    
    func getName()->String{
        getNutriteintName(self.nutritientType)
    }
    
    func getImage()->Image{
        getImageForNutr(self.nutritientType)
    }
    
    func getMassPresentation()->String{
        "\(self.mass)/\(self.specifier)\(FoodModel.massUnit)"
    }
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                // The name label
                Text(self.getName())
                    .padding(.leading, NameValuePair.leadingInset)
                    .font(.title3)
                    .frame(maxWidth: 150, alignment: .leading)
                HStack {
                    getImage()
                        .font(.title3)
                }
                Text(self.getMassPresentation())
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.title3)
            }
            .padding(.vertical, 0)
            .padding(.trailing, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            if self.stroke {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(StyleElementsGetter.separatorsNotOpaque)
                    .padding(.top, 3)
            }
        }
        .padding(.horizontal, 0)
    }
}

#Preview {
    NutritientValuePresentation(nutritientType: .carb, mass: 20, specifier: 100)
}
