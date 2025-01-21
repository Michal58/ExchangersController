

import Foundation
import SwiftUI

func getGoBackButton(closure: @escaping () -> Void = {}) -> some View {
    Button(action: {
        closure()
    }){
        Image(systemName: "chevron.left")
            .resizable()
            .scaledToFit()
    }
}
