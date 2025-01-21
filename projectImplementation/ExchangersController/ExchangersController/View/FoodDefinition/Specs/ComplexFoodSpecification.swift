

import Foundation
import Combine


class ComplexFoodSpecification: FoodModelSpecification {
    private var updateSpecifierWithDosages: Bool
    
    private(set) var foodDosages: [FoodDosage] {
        didSet {
            updateSpecifierWithDosages = true
            updateModel()
        }
    }
    private(set) var optionalStateOfTile: [MiniCollapsibleState]
    @Published var userSpecifier: String {
        didSet {
            if oldValue == userSpecifier {
                return
            }
            self.updateSpecifierWithDosages = false
            updateModel()
            
        }
    }
    
    init(actualFoodModel: ComplexFood) {
        foodDosages = actualFoodModel.foodExtension
        self.optionalStateOfTile = self.foodDosages.map({_ in MiniCollapsibleState(isDisclosed: true)})
        
        self.userSpecifier = String(actualFoodModel.massSpecifier)
        self.updateSpecifierWithDosages = false
        super.init(actualFoodModel: actualFoodModel)
    }
    
    private func getSpecifierValue() -> Int {
        if areOnlyDigits(userSpecifier,emptyIsValid: false) {
            Int(userSpecifier)!
        }
        else {
            0
        }
    }
    
    func addAnotherDosage(_ nextDosage: FoodDosage) {
        self.foodDosages.append(nextDosage)
        self.optionalStateOfTile.append(MiniCollapsibleState(isDisclosed: true))
    }
    
    func removeDosage(_ indexToRemove: Int) {
        self.foodDosages.remove(at: indexToRemove)
        self.optionalStateOfTile.remove(at: indexToRemove)
        self.optionalStateOfTile = self.optionalStateOfTile.map({_ in MiniCollapsibleState(isDisclosed: true)})
    }
    
    func modifyDosage(dosage: FoodDosage, index: Int) {
        self.foodDosages[index] = dosage
    }
    
    override func updateModel() {
        super.updateModel()
        super.setModel(
            ComplexFood(
                name: self.actualFoodModel.name,
                massSpecifier: self.updateSpecifierWithDosages ? self.foodDosages.reduce(0, {$0+$1.totalMass()}) : getSpecifierValue(),
                foodExtension: self.foodDosages))
        
        if (self.updateSpecifierWithDosages) {
            self.userSpecifier = String((self.actualFoodModel as! ComplexFood).dosagesTotalMass())
        }
    }
}
