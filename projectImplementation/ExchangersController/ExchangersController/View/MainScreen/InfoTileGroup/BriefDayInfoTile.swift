

import SwiftUI

struct BriefDayInfoTile: View {
    var overViewInfoAcc: OverviewInfoAcc
    var interval: GroupingInterval
    var closure: () -> Void = {}

    
    static var tileWidth: CGFloat = 319
    
    func headerTitle() -> String {
        let dateToFormat = self.overViewInfoAcc.date
        return switch interval {
        case .day:
            getFormatInDDMMYYYY(dateToFormat)
        case .month:
            getFormatInMMYYYY(dateToFormat)
        case .year:
            getFormatInYYYY(dateToFormat)
        }
    }
    
    var body: some View {
        VStack{
            BriefDayInfoHeader(
                titleText: headerTitle(),
                closure: self.closure)
            Spacer()
            VStack(alignment: .leading, spacing: 10){
                HStack {
                    Text("Accumulated:")
                        .font(.body)
                        .padding(.horizontal, NameValuePair.leadingInset)
                    Spacer()
                }
                ShortExchangersSummary(
                    dataToPresent:
                        self.overViewInfoAcc.getExchangersSummary()
                )
                    .font(.body)
                Spacer()
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: BriefDayInfoTile.tileWidth)
        .fixedSize(horizontal: false, vertical: true)
        .background(.background.secondary)
        .cornerRadius(StyleElementsGetter.boldCorners)
    }
}

#Preview {
    let headerTitle = "Today"
    let innerData = BriefExchangersSummary(wwValue: 50,wbtValue: 21,kcal: 900)
    let infoAcc = OverviewInfoAcc(date: Date())
    let interval = GroupingInterval.day
    
    BriefDayInfoTile(
        overViewInfoAcc: infoAcc,
        interval: interval)
}
