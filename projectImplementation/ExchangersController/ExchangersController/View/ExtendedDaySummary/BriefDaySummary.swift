

import SwiftUI

struct BriefDaySummary: View {
    var summaryData: BriefDaySummaryData
    
    var body: some View {
        let headerTitle = Text("Day summary")
            .font(.title2)
            .bold()
        
        let contentToExpand = VStack{
            NameValuePair(name: "WW", value: summaryData.getWW())
            NameValuePair(name: "WBT", value: summaryData.getWBT())
            NameValuePair(name: "Kcal", value: summaryData.getKcal())
            NameValuePair(name: "Kcal burned", value: summaryData.getKcalBurned())
            NameValuePair(name: "Kcal balance", value: summaryData.getKcalBalance(), storke: false)
        }
        .padding()
        .background(StyleElementsGetter.appBackLightGrey)
        
        CollapsibleTile(headerContent: AnyView(headerTitle), contentToExpand: AnyView(contentToExpand))
    }
}

#Preview {
    let example = BriefDaySummaryData(wwData: 50, wbtData: 25, kcalData: 2000, kcalBurned: 1000)
    
    BriefDaySummary(summaryData: example)
}
