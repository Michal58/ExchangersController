

import Foundation

class BrowsingBuffer: ObservableObject{
    private var browser: Browser?
    private var onEmptyAction: ([FoodModel])->[FoodModel]
    
    @Published private(set) var toShowResults: [FoodModel]
    private var browserResults: [FoodModel]
    
    static var SEARCH_WILDCARD: String = "*"
    
    @Published var searchTerm: String{
        didSet {
            if oldValue != searchTerm{
                self.filterShowResults()
            }
        }
    }
    @Published var shouldSearchRemotely: Bool {
        didSet  {
            if oldValue != shouldSearchRemotely{
                self.filterShowResults()
            }
        }
    }
    
    @Published var shouldSearchLocally: Bool {
        didSet  {
            if oldValue != shouldSearchLocally{
                self.filterShowResults()
            }
        }
    }
    @Published var shouldSearchComplex: Bool {
        didSet  {
            if oldValue != shouldSearchComplex{
                self.filterShowResults()
            }
        }
    }
    
    init(browser: Browser?, onEmptyAction: @escaping ([FoodModel])->[FoodModel] = removeAllResults) {
        self.browser = browser
        self.toShowResults = []
        self.browserResults = []
        self.searchTerm = ""
        
        self.shouldSearchRemotely = true
        self.shouldSearchLocally = true
        self.shouldSearchComplex = true
        
        self.onEmptyAction = onEmptyAction
    }
    
    static func removeAllResults(results: [FoodModel])->[FoodModel]{
        []
    }
    static func noFilter(results: [FoodModel])->[FoodModel]{
        results
    }
    
    func setBrowser(_ browser: Browser){
        self.browser = browser
    }
    
    func setIfShouldSearchLocally(_ should: Bool){
        self.shouldSearchLocally = should
    }
    
    func setIfShouldSearchRemotely(_ should: Bool){
        self.shouldSearchRemotely = should
    }
    
    func setIfShouldSearchComplex(_ should: Bool){
        self.shouldSearchComplex = should
    }
    
    func updateBrowserResults(_ results: [FoodModel]){
        browserResults = results
        toShowResults = filterWithFlags(browserResults)
    }
    
    func filterWithFlags(_ interResults: [FoodModel])->[FoodModel]{
        interResults.filter {
            ($0 is SimpleFood || self.shouldSearchComplex) &&
            (
                (!$0.isLocal() && self.shouldSearchRemotely) ||
                ($0.isLocal() && self.shouldSearchLocally)
            )
        }
    }
    
    func filterShowResults(){
        let resultsToFilter: [FoodModel] =
        if searchTerm == BrowsingBuffer.SEARCH_WILDCARD {
            browserResults
        }
        else if searchTerm.isEmpty {
            self.onEmptyAction(self.browserResults)
        }
        else {
            filterWithFlags(browserResults.filter { $0.name.contains(searchTerm) })
        }
        toShowResults = filterWithFlags(resultsToFilter)
    }
    
    func submitSearchTerm(ultimateTerm: String? = nil,
                          shouldLocally: Bool? = nil,
                          shouldRemotely: Bool? = nil,
                          shouldIncludeComplex: Bool? = nil) {
        
        self.searchTerm = ultimateTerm ?? self.searchTerm
        self.shouldSearchLocally = shouldLocally ?? self.shouldSearchLocally
        self.shouldSearchRemotely = shouldRemotely ?? self.shouldSearchRemotely
        self.shouldSearchComplex = shouldIncludeComplex ?? self.shouldSearchComplex
        
        browser?.search(phrase: self.searchTerm, shouldLocally: self.shouldSearchLocally, shouldRemotely: self.shouldSearchRemotely, shouldIncludeComplex: self.shouldSearchComplex)
    }
}
