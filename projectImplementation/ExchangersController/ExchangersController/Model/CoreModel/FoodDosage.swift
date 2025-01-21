

import Foundation

class FoodDosage: Identifiable, Codable {
    private(set) var id = UUID()
    private(set) var mass: Int
    private(set) var count: Int
    private var actualFood: FoodModel
    
    init(mass: Int, count: Int, actualFood: FoodModel) {
        self.mass = mass
        self.count = count
        self.actualFood = actualFood
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.mass = try container.decode(Int.self, forKey: .mass)
        self.count = try container.decode(Int.self, forKey: .count)
        self.actualFood = try container.decode(PartiallyDecodedFood.self, forKey: .actualFood).model
    }
    
    func getActualFood()-> FoodModel {
        actualFood
    }
    
    func totalMass()-> Int {
        self.mass * self.count
    }
    
    func copy()->FoodDosage{
        FoodDosage(mass: self.mass, count: self.count, actualFood: self.actualFood.copy())
    }
    
    
    func totalNutritient(_ nutritient: Nutritient)->Int {
        actualFood.getNutritientValueWithMass(nutritient, self.totalMass())
    }
    
    func totalWW()->Int {
        calcWW(totalNutritient(.carb))
    }
    
    func totalWbt()->Int {
        calcWbt(totalNutritient(.prot), totalNutritient(.fat))
    }
    
    func totalKcal()->Int {
        totalNutritient(.kcal)
    }
    
    func getExchagersSummary() -> BriefExchangersSummary {
        BriefExchangersSummary(wwValue: totalWW(), wbtValue: totalWbt(), kcal: totalKcal())
    }
    
    func nonLoaclCopy() -> FoodDosage {
        FoodDosage(mass: self.mass, count: self.count, actualFood: (self.actualFood as! SimpleFood).nonLocalCopy())
    }
}
