

import Foundation


struct DishSummaryData {
    var time: DateComponents
    var exchangers: BriefExchangersSummary
    
    func getTime()->String{
        let hour = time.hour ?? 0
        let minute = time.minute ?? 0
        return String(format: "%02d:%02d", hour, minute)
    }
    
    func getExchangers()->BriefExchangersSummary{
        return exchangers
    }
}
