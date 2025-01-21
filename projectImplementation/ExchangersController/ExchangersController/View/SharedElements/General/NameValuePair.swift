import SwiftUI

struct NameValuePair: View {
    var name: String
    var value: String
    
    static let leadingInset:CGFloat = 13
    
    var storke: Bool = true
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                // The name label
                Text(name)
                    .padding(.leading, NameValuePair.leadingInset)
                Text(value)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.vertical, 0)
            .padding(.trailing, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            if storke {
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
    NameValuePair(name: "Name", value: "Value")
}
