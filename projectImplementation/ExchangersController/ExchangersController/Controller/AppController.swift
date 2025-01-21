

import Foundation
import SwiftUI

enum ViewState {
    case mainOverview
    case extendedSummary
    case dishEntry
    case foodSearch
    case foodEntry
    case foodAdd
    case defineFood
    case databaseEdit
    case glucoseInsert
    case charts
    case reports
}

class ViewWrapper{
    var viewToDisplay: any View
    init(_ viewToDisplay: any View) {
        self.viewToDisplay = viewToDisplay
    }
}

class AppController {
    private var model: DataModel
    private var mainPath: ObservableWrapper<NavigationPath>
    private var logicalPath: [ViewState]
    private var viewPathMapping: [ViewState: ViewWrapper]
    private var popupPresence: PopupPresenceObserver
    private var proxyObjects: [Any]
    
    private var mainScreenState: MainState
    private var databaseBuffer: BrowsingBuffer
    
    static func restoreDataModel() -> DataModel {
        return PersistenceManager.shared.loadState()
    }
    
    init() {
        self.model = AppController.restoreDataModel()
        self.logicalPath = []
        self.mainPath = ObservableWrapper(wrapped: NavigationPath())
        self.popupPresence = PopupPresenceObserver()
        self.viewPathMapping = [:]
        self.proxyObjects = []
        
        self.mainScreenState = MainState()
        self.databaseBuffer = BrowsingBuffer(
            browser: nil,
            onEmptyAction: BrowsingBuffer.noFilter
        )
    }
    
    func getMainPopupPresence()->PopupPresenceObserver{
        self.popupPresence
    }
    
    func getNavigationPath()->ObservableWrapper<NavigationPath>{
        self.mainPath
    }
    
    func getViewToDisplay()->ViewWrapper{
        return viewPathMapping[self.logicalPath.last!]!
    }
    
    func getModel()->DataModel{
        self.model
    }
    
    func appendToState(_ viewState: ViewState){
        self.logicalPath.append(viewState)
        self.getNavigationPath().wrapped.append(viewState)
    }
    
    func removeFromState(){
        self.logicalPath.removeLast()
        self.getNavigationPath().wrapped.removeLast()
    }
    
    // from main view (always)
    func goToExtendedDaySummary(_ dayDate: Date){
        let newSummary = ExtendedDaySummary(
            controller: self,
            model: self.model,
            dayOfSummary: dayDate,
            navigationPopupPresence: self.popupPresence)
        self.viewPathMapping[.extendedSummary] = ViewWrapper(
            newSummary
        )
        appendToState(.extendedSummary)
    }
    
    func goBackFromExtendedScreenToMainScreen(){
        removeFromState()
    }
    
    func goFromMainScreenToDishEntry(){
        let dishEntryScreen = DishEntry(
            conroller: self,
            dish: nil
        )
        self.viewPathMapping[.dishEntry] = ViewWrapper(
            dishEntryScreen
        )
        appendToState(.dishEntry)
    }
    
    func goFromExtendedSummaryToDishEntry(_ originalDish: Dish){
        let dishEntryScreen = DishEntry(
            conroller: self,
            dish: originalDish
        )
        self.viewPathMapping[.dishEntry] = ViewWrapper(
            dishEntryScreen
        )
        appendToState(.dishEntry)
    }
    
    func discardDishEntry(){
        removeFromState()
    }
    
    func deleteDishEntry(originalDishId: UUID){
        self.model.removeDish(id: originalDishId)
        removeFromState()
        if self.logicalPath.last! == .extendedSummary &&
            (self.viewPathMapping[.extendedSummary]!.viewToDisplay as! ExtendedDaySummary).insertionState.getDishesAtSetDate().isEmpty {
            goBackFromExtendedScreenToMainScreen()
        }
    }
    
    func acceptDishEntry(originalId: UUID?, date: Date, dosages: [FoodDosage]) {
        if originalId != nil {
            self.model.modifyDish(id: originalId!, date: date, dosages: dosages)
        }
        else {
            self.model.addDish(date: date, dosages: dosages)
        }
        
        removeFromState()
    }
    
    func goFromMainToSearch(){
        let buffer=BrowsingBuffer(browser:nil)

        let browser=Browser(buffer: buffer, debugMode: false, model: model)
        buffer.setBrowser(browser)
        let searchView = FoodSearch(
            controller: self,
            searchResultsBuffer: buffer
        )
        self.viewPathMapping[.foodSearch] = ViewWrapper(
            searchView
        )
        self.appendToState(.foodSearch)
    }
    
    func goBackFromSearch(){
        if self.logicalPath != [.foodSearch] {
            self.databaseBuffer.updateBrowserResults(self.model.getDatabase().getFoodModels())
        }
        self.removeFromState()
    }
    
    func getFromAddFoodContentForDishEntry(dosages: ObservableWrapper<[DosageSpecificationDefinition]>){
        self.proxyObjects.append(dosages)
        
        let buffer=BrowsingBuffer(browser:nil)

        let browser=Browser(buffer: buffer, debugMode: false, model: model)
        buffer.setBrowser(browser)
        
        let addFoodView = AddFoodEntryView(
            controller: self,
            searchResultsBuffer: buffer
        )
        
        self.viewPathMapping[.foodAdd] = ViewWrapper(
            addFoodView
        )
        
        self.appendToState(.foodAdd)
    }
    
    func acceptAddFood(dosageSpec: DosageSpecificationDefinition){
        if self.logicalPath[self.logicalPath.count - 2] == .dishEntry {
            let dosages: ObservableWrapper<[DosageSpecificationDefinition]> = self.proxyObjects.last! as! ObservableWrapper<[DosageSpecificationDefinition]>
            dosages.wrapped.insert(
                dosageSpec.copy(),
                at: 0
            )
        }
        else {
            let complexSpec: ComplexFoodSpecification = self.proxyObjects.last! as! ComplexFoodSpecification
            complexSpec.addAnotherDosage(dosageSpec.dynamicDosage())
        }
        
        self.proxyObjects.removeLast()
        self.removeFromState()
    }
    
    func cancelAddFood(){
        self.proxyObjects.removeLast()
        self.removeFromState()
    }
    
    func modifyFoodFromSearch(originalFood: FoodModel){
        let modifyFoodView = FoodDefinition(referenceOfFood: originalFood, controller: self)
        self.viewPathMapping[.defineFood] = ViewWrapper(modifyFoodView)
        self.appendToState(.defineFood)
    }
    
    func addFoodToDatabaseFromSearch(focusWrapper: ObservableWrapper<FoodModel?>){
        self.model.addRemoteFood(remoteFood: focusWrapper.wrapped! as! SimpleFood)
        withAnimation(.smooth){
            focusWrapper.wrapped = nil
        }
    }
    
    func cancelFoodDefinition(){
        if self.logicalPath[self.logicalPath.count - 2] == .foodSearch {
            let searchView = FoodSearch(
                controller: self,
                searchResultsBuffer: (self.viewPathMapping[.foodSearch]!.viewToDisplay as! FoodSearch).searchResultsBuffer
            )
            self.viewPathMapping[.foodSearch] = ViewWrapper(
                searchView
            )
        }
        removeFromState()
    }
    
    func commitModification(specification: FoodModelSpecification, reference: FoodModel){
        self.model.modifyFoodFromDatabase(specification.getModel(), reference)
        if logicalPath[self.logicalPath.count - 2] == .foodSearch{
            let searchView = FoodSearch(
                controller: self,
                searchResultsBuffer: (self.viewPathMapping[.foodSearch]!.viewToDisplay as! FoodSearch).searchResultsBuffer
            )
            self.viewPathMapping[.foodSearch] = ViewWrapper(
                searchView
            )
        }
        else {
            self.databaseBuffer.updateBrowserResults(self.model.getDatabase().getFoodModels())
        }
        removeFromState()
    }
    
    func commitAddFood(specification: FoodModelSpecification){
        self.model.addNewFoodToDatabase(specification.actualFoodModel)
        self.databaseBuffer.updateBrowserResults(self.model.getDatabase().getFoodModels())
        removeFromState()
    }
    
    func addDosageToComplexSpecification(complexSpecification: ComplexFoodSpecification){
        self.proxyObjects.append(complexSpecification)
        let buffer=BrowsingBuffer(browser:nil)

        let browser=Browser(buffer: buffer, debugMode: false, model: model)
        buffer.setBrowser(browser)
        
        let addFoodView = AddFoodEntryView(
            controller: self,
            searchResultsBuffer: buffer
        )
        
        self.viewPathMapping[.foodAdd] = ViewWrapper(
            addFoodView
        )
        
        self.appendToState(.foodAdd)
    }
    
    func goFromMainToDatabaseEdition(){
        self.databaseBuffer = BrowsingBuffer(
            browser: nil,
            onEmptyAction: BrowsingBuffer.noFilter
        )
        
        let databaseView = DatabaseEdition(
            initialBuffer: self.databaseBuffer,
            controller: self
        )
        self.viewPathMapping[.databaseEdit] = ViewWrapper(databaseView)
        self.appendToState(.databaseEdit)
    }
    
    func goFromDatabaseToMain(){
        removeFromState()
    }
    
    func modifyFoodFromDatabase(originalFood: FoodModel){
        let modifyFoodView = FoodDefinition(referenceOfFood: originalFood, controller: self)
        self.viewPathMapping[.defineFood] = ViewWrapper(modifyFoodView)
        self.appendToState(.defineFood)
    }
    
    func goFromDatabaseToSearch(){
        let buffer=BrowsingBuffer(browser:nil)

        let browser=Browser(buffer: buffer, debugMode: false, model: model)
        buffer.setBrowser(browser)
        let searchView = FoodSearch(
            controller: self,
            searchResultsBuffer: buffer
        )
        self.viewPathMapping[.foodSearch] = ViewWrapper(
            searchView
        )
        self.appendToState(.foodSearch)
    }
    
    func startAddingFood(isComlex: Bool){
        let modifyFoodView = FoodDefinition(isComplex: isComlex, controller: self)
        self.viewPathMapping[.defineFood] = ViewWrapper(modifyFoodView)
        self.appendToState(.defineFood)
    }
    
    func goFromMainToGlucoseLevelsInsertion(){
        let glucoseLevelsInsertionView = GlucoseLevelsInsertion(popUpPresence: self.popupPresence, controller: self)
        self.viewPathMapping[.glucoseInsert] = ViewWrapper(glucoseLevelsInsertionView)
        self.appendToState(.glucoseInsert)
    }
    
    func goBackFromGlucoseInsertionToMain(){
        removeFromState()
    }
    
    func goFromMainToCharts(){
        let chartsView = Charts(
            controller: self,
            startDate:
                ObservableWrapper(
                    wrapped: Date()
                ),
            endDate:
                ObservableWrapper(
                    wrapped: Date()
                )
        )
        self.viewPathMapping[.charts] = ViewWrapper(chartsView)
        self.appendToState(.charts)
    }
    
    func goFromChartToMain(){
        removeFromState()
    }
    
    func goFromMainToReports(){
        let reportsView = ReportUpload(controller: self, presence: self.popupPresence)
        self.viewPathMapping[.reports] = ViewWrapper(reportsView)
        self.appendToState(.reports)
    }
    
    func goFromReportsToMain(){
        removeFromState()
    }
}
