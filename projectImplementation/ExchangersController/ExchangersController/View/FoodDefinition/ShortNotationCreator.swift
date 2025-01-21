

import SwiftUI

struct ShortNotationCreator: View {
    @ObservedObject var specification: FoodModelSpecification
    var isFoodComplex: Bool
    var isFoodLocallyStored: Bool
    
    var scaleImapct:CGFloat
    var fontSize: CGFloat
    
    init(specification: FoodModelSpecification,
         isFoodComplex: Bool,
         isFoodLocallyStored: Bool,
         scaleImapct: CGFloat = 1.35,
         fontSize: CGFloat = 20) {
        self.specification = specification
        
        self.isFoodComplex = isFoodComplex
        self.isFoodLocallyStored = isFoodLocallyStored
        
        self.scaleImapct = scaleImapct
        self.fontSize = fontSize
        
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 3) {
            Image(systemName: isFoodComplex ? "fork.knife" : "carrot.fill")
                .font(.system(size: self.fontSize))
            .scaleEffect(scaleImapct)
            Spacer()
            TextField("Your food name", text: $specification.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.default)
                .font(.system(size: self.fontSize))
                .multilineTextAlignment(.center)
            Spacer()
            Image(systemName: isFoodLocallyStored ? "house" : "network")
                .font(.system(size: self.fontSize))
                .scaleEffect(scaleImapct)
        }
        .padding(.horizontal, 7)
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(StyleElementsGetter.appMediumGrey)
        .cornerRadius(10)
    }
}

#Preview {
    HStack{
        let spec = FoodModelSpecification(actualFoodModel: FoodModel(name: "Food name could be very long", massSpecifier: 0))
        ShortNotationCreator(specification: spec, isFoodComplex: true, isFoodLocallyStored: true)
    }
    .frame(width: 300)
}
