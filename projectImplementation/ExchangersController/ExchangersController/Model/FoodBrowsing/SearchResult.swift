

import Foundation

class SearchResult {
    var actualFood: FoodModel
    var isRemote: Bool
    
    init(actualFood: FoodModel, isRemote: Bool) {
        self.actualFood = actualFood
        self.isRemote = isRemote
    }
}
