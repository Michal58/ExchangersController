

import Foundation

class DatabaseSpecification: ObservableObject {
    private var originalDatabase: FoodDatabase
    @Published private var databaseContent: [FoodModel]
    @Published var searchBuffer: String
    
    init(originalDatabase: FoodDatabase) {
        self.searchBuffer = ""
        self.originalDatabase = originalDatabase
        self.databaseContent = originalDatabase.getFoodModels()
    }
    
    func updateDatabaseContent() {
        self.databaseContent = self.originalDatabase.getFoodModels()
    }
}
