

import Foundation

class FoodDatabase: Codable {
    private var storedFoodModels: [FoodModel]
    
    init(storedFoodModels: [FoodModel]) {
        self.storedFoodModels = storedFoodModels
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.storedFoodModels = try container.decode([PartiallyDecodedFood].self, forKey: .storedFoodModels)
            .map {$0.model}
    }
    
    func getFoodModels() -> [FoodModel] {
        self.storedFoodModels
    }
    
    func validateModelValidity(_ model: FoodModel)->Bool{
        !model.name.isEmpty
    }
    
    func addRemoteSimpleFood(_ model: SimpleFood){
        if validateModelValidity(model){
            self.storedFoodModels.append(
                SimpleFood(
                    name: model.name,
                    massSpecifier: model.massSpecifier,
                    carbohydates: model.carbohydates,
                    proteins: model.proteins,
                    fat: model.fat,
                    isLocal: true
                )
            )
        }
    }
    
    func addFood(_ model: FoodModel){
        if validateModelValidity(model){
            self.storedFoodModels.append(model)
        }
    }
    
    func removeFoodWithID(_ id: UUID){
        self.storedFoodModels.removeAll(where: {
            $0.idOfFood == id
        })
    }
}
