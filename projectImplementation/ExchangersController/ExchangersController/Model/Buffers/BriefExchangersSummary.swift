struct BriefExchangersSummary: Hashable {
    var wwValue: Int
    var wbtValue: Int
    var kcal: Int
    
    mutating func addInplace(other: BriefExchangersSummary)-> Void {
        self.wwValue += other.wwValue
        self.wbtValue += other.wbtValue
        self.kcal += other.kcal
    }
}
