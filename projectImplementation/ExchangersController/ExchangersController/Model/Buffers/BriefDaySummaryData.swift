

import Foundation


struct BriefDaySummaryData {
    private var wwData: Int
    private var wbtData: Int
    private var kcalData: Int
    private var kcalBurned: Int
    private var kcalBalance: Int
    
    init(wwData: Int, wbtData: Int, kcalData: Int, kcalBurned: Int) {
        self.wwData = wwData
        self.wbtData = wbtData
        self.kcalData = kcalData
        self.kcalBurned = kcalBurned
        self.kcalBalance = kcalData-kcalBurned
    }
    
    func getWW()->String{
        String(self.wwData)
    }
    
    func getWBT()->String{
        String(self.wbtData)
    }
    
    func getKcal()->String{
        String(self.kcalData)
    }
    
    func getKcalBurned()->String{
        String(self.kcalBurned)
    }
    
    func getKcalBalance()->String{
        String(self.kcalBalance)
    }
}
