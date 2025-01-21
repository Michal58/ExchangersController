

import Foundation

class Browser {
    static let ALL_WILDTERM: String = "all"
    private var previousSearchResult: [FoodModel]
    
    private var debugMode: Bool
    var buffer: BrowsingBuffer
    var model: DataModel?
    
    class RemoteResult{
        var name: String
        var carbValue: Double
        var protValue: Double
        var fatValue: Double
        
        init(
            name: String,
            carbValue: Double,
            protValue: Double,
            fatValue: Double
        ) {
            self.name = name
            self.carbValue = carbValue
            self.protValue = protValue
            self.fatValue = fatValue
        }
    }
    
    init(buffer: BrowsingBuffer, debugMode: Bool = false, model: DataModel? = nil) {
        self.debugMode = debugMode
        self.buffer = buffer
        self.model = model
        
        self.previousSearchResult = []
    }
    
    func informAboutEndOfFetching(_ remoteDatabaseResults: [RemoteResult]) {
        let modelsFromRemoteResults: [FoodModel] = remoteDatabaseResults
            .prefix(10)
            .map {result in
            SimpleFood(
                name: result.name,
                massSpecifier: FoodModel.DEFAULT_SPECIFIER,
                carbohydates: Int(result.carbValue.rounded()),
                proteins: Int(result.protValue.rounded()),
                fat: Int(result.fatValue.rounded()),
                isLocal: false
            )
        }
        
        self.previousSearchResult = modelsFromRemoteResults
        self.buffer.updateBrowserResults(self.previousSearchResult)
    }
    
    func fetchData(_ queryTerm: String = "orange") {
        let requestJson = """
            {
                "includeDataTypes": {
                    "Foundation": true
                },
                "referenceFoodsCheckBox": true,
                "requireAllWords": true,
                "includeMarketCountries": null,
                "sortField": "",
                "sortDirection": null,
                "pageNumber": 1,
                "exactBrandOwner": null,
                "currentPage": 1,
                "generalSearchInput": "\(queryTerm)"
            }
            """
        
        guard let jsonData = requestJson.data(using: .utf8) else {
            return
        }
        
        guard let url = URL(string: "https://fdc.nal.usda.gov/portal-data/external/search") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let fetchingTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                var foodTuples: [RemoteResult] = []
                
                if let jsonResponse = try JSONSerialization.jsonObject(
                    with: data,
                    options: []
                ) as? [String: Any],
                   let foods = jsonResponse["foods"] as? [[String: Any]] {
                    
                    for food in foods {
                        if let remoteName = food["description"] as? String {
                            if let foodNutrients = food["foodNutrients"] as? [[String: Any]] {
                                var carbohydratesValue: Double? = nil
                                var proteinsValue: Double? = nil
                                var fatValue: Double? = nil
                                
                                for nutrient in foodNutrients {
                                    if let nutrientId = nutrient["nutrientId"] as? Int,
                                       let value = nutrient["value"] as? Double {
                                        if nutrientId == 1004 {
                                            fatValue = value
                                        } else if nutrientId == 1003 {
                                            proteinsValue = value
                                        } else if nutrientId == 1005 {
                                            carbohydratesValue = value
                                        }
                                    }
                                }
                                
                                if carbohydratesValue != nil &&
                                    proteinsValue != nil &&
                                    fatValue != nil {
                                    foodTuples.append(
                                        RemoteResult(
                                            name: remoteName,
                                            carbValue: carbohydratesValue!,
                                            protValue: proteinsValue!,
                                            fatValue: fatValue!
                                        )
                                    )
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.informAboutEndOfFetching(foodTuples)
                    }
                }
            } catch {
            }
        }
        fetchingTask.resume()
    }
    
    func searchLocally(_ phrase: String, shouldIncludeComplex: Bool)->[FoodModel]{
        if self.model == nil {
            return []
        }
        let database = self.model!.getDatabase()
        return database.getFoodModels().filter {model in
            phrase.lowercased() == Browser.ALL_WILDTERM ||
            (
                (shouldIncludeComplex || model is SimpleFood) &&
                model.name.lowercased().contains(phrase.lowercased())
            )
        }
        .sorted {
            $0.name < $1.name
        }
    }
    
    func search(phrase: String, shouldLocally: Bool, shouldRemotely: Bool, shouldIncludeComplex: Bool)->Void{
        if debugMode {
            searchDebug()
            return
        }
        
        var results: [FoodModel] = []
        if shouldLocally {
            results.append(
                contentsOf:
                    searchLocally(
                        phrase,
                        shouldIncludeComplex: shouldIncludeComplex
                    )
            )
        }
        
        self.previousSearchResult = results
        buffer.updateBrowserResults(self.previousSearchResult)
        
        if shouldRemotely {
            fetchData(phrase)
        }
    }
    
    func searchDebug()->Void{
        var copyOfList:[FoodModel] = Example.simFoods
        let copyOfListComplex:[FoodModel] = Example.complexFood
        copyOfList.append(contentsOf: copyOfListComplex)
        
        if self.model != nil {
            buffer.updateBrowserResults(self.model!.getDatabase().getFoodModels())
        }
        else {
            buffer.updateBrowserResults(copyOfList)
        }
    }
}
