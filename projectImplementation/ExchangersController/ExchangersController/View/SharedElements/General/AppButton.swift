

import SwiftUI

struct AppButton: View {
    static let standardHeight: CGFloat = 80
    static let fontType = Font.title3
    
    var action: ()->Void
    var text: String?
    var extraElement: AnyView?
    var shouldBeSquezzed: Bool = true
    
    var horizontalPadding: CGFloat = 25
    var innerSpacing: CGFloat = 3
    var disableIndicator: Bool = false
    
    var body: some View {
        Button(action: self.action) {
            HStack(alignment: .center, spacing: self.innerSpacing) {
                if let textContent = self.text {
                    Text(textContent)
                        .font(AppButton.fontType)
                        .foregroundColor(.primary)
                }
                if !shouldBeSquezzed {
                    Spacer()
                }
                if let extraContent=self.extraElement {
                    extraContent
                }
            }
            .frame(height: AppButton.standardHeight)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, self.horizontalPadding)
        }
        .background(
            StyleElementsGetter.appBlue
                .opacity(self.disableIndicator ? 0.3 : 1)
        )
        .cornerRadius(.infinity)
    }
    
    static func transformImageFromSystemName(name: String, scaleFactor: CGFloat = 0.22)->some View {
        Image(systemName: name)
            .resizable()
            .scaledToFit()
            .frame(height: AppButton.standardHeight*scaleFactor)
            .foregroundColor(.black)
    }
    
    static func transformImageFromName(name: String, scaleFactor: CGFloat = 0.22)-> some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(height: AppButton.standardHeight*scaleFactor)
            .foregroundColor(.black)
    }
}

#Preview {
    let image = AppButton.transformImageFromSystemName(name: "checkmark")
    
    VStack{
        AppButton(action: {print("Example")}, text: "Example", extraElement: AnyView(image))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(10)
}
