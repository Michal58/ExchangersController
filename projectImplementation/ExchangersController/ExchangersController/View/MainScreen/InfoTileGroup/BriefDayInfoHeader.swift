

import SwiftUI

struct BriefDayInfoHeader: View {
    var titleText: String
    var closure: ()->Void = {}
    
    var hPadding: CGFloat = 10
    var vPadding: CGFloat = 10
    
    var body: some View {
        HStack(alignment: .center) {
            ZStack{
                HStack(alignment: .center) {
                    Text(self.titleText)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                }
                HStack(alignment: .center) {
                    Spacer()
                    Button(action:self.closure) {
                        Image(systemName: "play.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.black)
                            .frame(height: UIFont.preferredFont(forTextStyle: .title2).pointSize*StyleElementsGetter.standardIconRatio)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, self.hPadding)
        .padding(.vertical, self.vPadding)
        .background(StyleElementsGetter.appBlue)
    }
}

#Preview {
    BriefDayInfoHeader(titleText: "Today")
}
