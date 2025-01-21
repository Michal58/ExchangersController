

import SwiftUI

struct FoodShortNotation: View {
    var isFoodComplex: Bool
    var foodTitle: String
    var isFoodLocallyStored: Bool
    
    var scaleImapct:CGFloat = 1.35
    var fontSize: CGFloat = 20
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: isFoodComplex ? "fork.knife" : "carrot.fill")
                .font(.system(size: self.fontSize))
            .scaleEffect(scaleImapct)
            Spacer()
            Text(foodTitle)
                .font(.system(size: self.fontSize))
                .multilineTextAlignment(.center)
                .lineSpacing(-10)
            Spacer()
            Image(systemName: isFoodLocallyStored ? "house" : "network")
                .font(.system(size: self.fontSize))
                .scaleEffect(scaleImapct)
        }
        .padding(.horizontal, 3)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    HStack{
        FoodShortNotation(isFoodComplex: true, foodTitle: "Food name could bevery long", isFoodLocallyStored: true)
    }
    .frame(width: 300)
}
