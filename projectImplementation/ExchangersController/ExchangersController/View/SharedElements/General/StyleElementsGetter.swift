import SwiftUI

struct StyleElementsGetter: View {
    static var appBlue: Color{
        Color(red: 0.69, green: 0.83, blue: 0.94)
    }
    
    static var appBackGreyX: Color{
        Color(red: 84/255, green: 84/255, blue: 86/255)
            .opacity(0.34)
    }
    
    static var appBackLightGrey: Color{
        Color(red: 0.93, green: 0.93, blue: 0.94)
    }
    
    static var appStrongGray: Color {
        Color(red: 0.76, green: 0.76, blue: 0.76)
    }
    
    static var appMediumGrey: Color {
        Color(red: 0.89, green: 0.89, blue: 0.91)
    }
    
    static var separatorsNotOpaque: Color{
        Color(red: 0.33, green: 0.33, blue: 0.34).opacity(0.34)
    }
    
    enum ColorShortcut {
        static let enAppBlue=Color(red: 0.69, green: 0.83, blue: 0.94)
    }
    
    
    static var standardIconRatio: CGFloat = 0.75
    static var boldCorners: CGFloat = 20
    static var normalCorners:CGFloat = 10
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .background(StyleElementsGetter.appBackLightGrey)
    }
}

#Preview {
    StyleElementsGetter()
}
