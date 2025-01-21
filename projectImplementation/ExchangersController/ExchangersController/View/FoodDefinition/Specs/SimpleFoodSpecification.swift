

import Foundation

class SimpleFoodSpecification: FoodModelSpecification {
    @Published var userSpecifier: String {
        didSet {
            updateModel()
        }
    }
    @Published var userCarbs: String {
        didSet {
            updateModel()
        }
    }
    @Published var userProt: String {
        didSet {
            updateModel()
        }
    }
    @Published var userFat: String {
        didSet {
            updateModel()
        }
    }
    
    init(actualFoodModel: SimpleFood) {
        userSpecifier = String(actualFoodModel.massSpecifier)
        userCarbs = String(actualFoodModel.getCarbohydrates())
        userProt = String(actualFoodModel.getProteins())
        userFat = String(actualFoodModel.getFat())
        
        super.init(actualFoodModel: actualFoodModel)
    }
    convenience init() {
        self.init(actualFoodModel: SimpleFood.createDefaultModel())
    }
    
    func areMassesSmallerThanSpecifier(specifier: Int, carbVal: Int, protVal: Int, fatVal: Int)->Bool{
        specifier>=carbVal+protVal+fatVal
    }
    
    private func convertOrDefault(_ value: String, _ defaultValue: Int = 0)->Int {
        areOnlyDigits(value) ? Int(value)! : defaultValue
    }
    
    private func massCorrectOrDefault(_ value: Int, _ isMassCorrect: Bool, _ defaultValue:Int = 0)->Int {
        isMassCorrect ? value : defaultValue
    }
    
    override func updateModel(){
        super.updateModel()
        
        let calcSpec = convertOrDefault(self.userSpecifier)
        let calcCarb = convertOrDefault(self.userCarbs)
        let calcProt = convertOrDefault(self.userProt)
        let calcFat = convertOrDefault(self.userFat)
        
        let areMassesCorrect = self.areMassesSmallerThanSpecifier(
            specifier: calcSpec,
            carbVal: calcCarb,
            protVal: calcProt,
            fatVal: calcFat)
        
        super.setModel(SimpleFood(
            name: actualFoodModel.name,
            massSpecifier: calcSpec,
            carbohydates: massCorrectOrDefault(calcCarb, areMassesCorrect),
            proteins: massCorrectOrDefault(calcProt, areMassesCorrect),
            fat: massCorrectOrDefault(calcFat, areMassesCorrect))
        )
    }
}
