import Foundation

class PersistenceManager {
    
    static let shared = PersistenceManager()
    
    private static let fileName = "DataModel.json"
    
    private func documentsURL() -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(PersistenceManager.fileName)
    }
    
    func saveState(_ state: Codable) {
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(state)
            try data.write(to: documentsURL())
        } catch {
            print("Error saving state: \(error)")
        }
    }
    
    func loadState() -> DataModel {
        if !FileManager.default.fileExists(atPath: documentsURL().path) {
            let defaultState = DataModel.initializeEmptyModel()
            return defaultState
        }
        
        do {
            let data = try Data(contentsOf: documentsURL())
            let decoder = JSONDecoder()
            let state = try decoder.decode(DataModel.self, from: data)
            return state
        } catch {
            print("Error loading state: \(error)")
            let defaultState = DataModel.initializeEmptyModel()
            return defaultState
        }
    }
}
