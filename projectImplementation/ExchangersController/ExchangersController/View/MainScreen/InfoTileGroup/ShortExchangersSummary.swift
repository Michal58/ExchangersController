

import SwiftUI

struct ShortExchangersSummary: View {
    var dataToPresent: BriefExchangersSummary
    
    var firstRowName: String = "WW:"
    var secondRowName: String = "WBT:"
    var thirdRowName: String = "Kcal balance:"
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            NameValuePair(name: self.firstRowName, value: String(dataToPresent.wwValue))
            NameValuePair(name: self.secondRowName, value: String(dataToPresent.wbtValue))
            NameValuePair(name: self.thirdRowName, value: String(dataToPresent.kcal), storke: false)
        }
    }
}

#Preview {
    let dataToPresent = BriefExchangersSummary(wwValue: 10, wbtValue: 5, kcal: 421)
    
    ShortExchangersSummary(dataToPresent: dataToPresent)
}
