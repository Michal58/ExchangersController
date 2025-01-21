

import Foundation

class DosageSpecificationDefinition: ObservableObject {
    @Published var actualFood: FoodModel
    @Published var pieceMass: String
    @Published var count: String
    
    init(pieceMass: String, count: String, actualFood: FoodModel) {
        self.pieceMass = pieceMass
        self.count = count
        self.actualFood = actualFood
    }
    
    convenience init(readyDosage: FoodDosage){
        self.init(pieceMass: String(readyDosage.mass), count: String(readyDosage.count), actualFood: readyDosage.getActualFood())
    }
    
    func dynamicDosage()->FoodDosage{
        let calcMass = Int(pieceMass) ?? 0
        let calcCount = Int(count) ?? 0
        return FoodDosage(mass: calcMass, count: calcCount, actualFood: self.actualFood)
    }
    
    func getTotalMass()->Int{
        if Int(pieceMass) != nil && Int(count) != nil {
            return Int(pieceMass)! * Int(count)!
        }
        else {
            return 0
        }
    }
    
    func copy()->DosageSpecificationDefinition{
        DosageSpecificationDefinition(
            readyDosage: self.dynamicDosage()
        )
    }
}
