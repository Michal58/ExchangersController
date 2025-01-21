

import Foundation


// Works on passed FoodModel
class FoodModelSpecification: ObservableObject {
    @Published private(set) var actualFoodModel: FoodModel
    @Published var name: String {
        didSet {
            updateModel()
        }
    }
    
    init(actualFoodModel: FoodModel) {
        self.name = actualFoodModel.name
        self.actualFoodModel = actualFoodModel
    }
    
    func setModelName(_ name: String) {
        actualFoodModel.setName(name)
    }
    
    func getModel()-> FoodModel{
        actualFoodModel
    }
    
    func updateModel(){
        actualFoodModel.setName(name)
    }
    
    func setModel(_ model: FoodModel){
        actualFoodModel = model
    }
    
    func getExchangerSummary() -> BriefExchangersSummary {
        FoodDosage(mass: self.actualFoodModel.massSpecifier, count: 1, actualFood: self.actualFoodModel).getExchagersSummary()
    }
    
    func isValid() -> Bool {
        !self.name.isEmpty
    }
}
