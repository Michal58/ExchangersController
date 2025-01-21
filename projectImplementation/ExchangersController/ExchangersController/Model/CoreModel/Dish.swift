

import Foundation


class Dish: Identifiable, Codable {
    private(set) var id: UUID
    private(set) var date: Date
    private var foodDosages: [FoodDosage]           
    
    init(date: Date, foodDosages: [FoodDosage]) {
        self.id = UUID()
        self.date = date
        self.foodDosages = foodDosages
    }
    
    func getExactDate()->Date {
        self.date
    }
    
    func getTimeOfDay() -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.hour, .minute], from: self.date)
    }
    
    func getStrTimeOfDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self.date)
    }
    
    func getDosages() -> [FoodDosage] {
        foodDosages
    }
    
    func getSumWW()->Int {
        foodDosages.reduce(0) {acc, dosage in
            acc+dosage.totalWW()
        }
    }
    
    func getSumWbt()->Int {
        foodDosages.reduce(0) {acc, dosage in
            acc+dosage.totalWbt()
        }
    }
    
    func getSumKcal()->Int {
        foodDosages.reduce(0) {acc, dosage in
            acc+dosage.totalKcal()
        }
    }
    
    func getExchagersSummary() -> BriefExchangersSummary {
        BriefExchangersSummary(wwValue: getSumWW(), wbtValue: getSumWbt(), kcal: getSumKcal())
    }
    
    func modifyDate(_ date: Date){
        self.date = date
    }
    
    func modifyDosages(_ dosages: [FoodDosage]) {
        self.foodDosages.removeAll()
        self.foodDosages.append(contentsOf: dosages)
    }
}
