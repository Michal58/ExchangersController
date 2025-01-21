

import Foundation

enum GroupingInterval{
    case year
    case month
    case day
}


class OverviewInfoAcc {
    var date: Date
    var ww: Int
    var wbt: Int
    var kcalBalance: Int
    
    func getExchangersSummary()-> BriefExchangersSummary {
        BriefExchangersSummary(wwValue: ww, wbtValue: wbt, kcal: kcalBalance)
    }
    
    init(dish: Dish, date: Date) {
        self.date = date
        self.ww = dish.getSumWW()
        self.wbt = dish.getSumWbt()
        self.kcalBalance = dish.getSumKcal()
    }
    
    init(date: Date, ww: Int = 0, wbt: Int = 0, kcalBalance: Int = 0){
        self.date = date
        self.ww = ww
        self.wbt = wbt
        self.kcalBalance = kcalBalance
    }
    
    func substractBurntCalories(_ burntValue: Int){
        self.kcalBalance -= burntValue
    }
    
    func addOther(_ other: OverviewInfoAcc){
        self.ww += other.ww
        self.wbt += other.wbt
        self.kcalBalance += other.kcalBalance
    }
}

class DataModel: Codable {
    private var glucoseReadings: [GlucoseReading]
    private var storedEmailAddresses: [String]
    private var storedDishes: [Dish]
    private var storedFoodDatabase: FoodDatabase
    
    init(glucoseReadings: [GlucoseReading], storedEmailAddresses: [String], storedDishes: [Dish], storedFoodDatabase: FoodDatabase) {
        self.glucoseReadings = glucoseReadings
        self.storedEmailAddresses = storedEmailAddresses
        self.storedDishes = storedDishes
        self.storedFoodDatabase = storedFoodDatabase
    }
    
    static func initializeEmptyModel()->DataModel{
        DataModel(
            glucoseReadings: [],
            storedEmailAddresses: [],
            storedDishes: [],
            storedFoodDatabase:
                FoodDatabase(
                    storedFoodModels: []
                )
        )
    }
    
    
    func getDishes()-> [Dish] {
        storedDishes
    }
    
    func getBurnedCaloriesAtDate(date: Date, interval: GroupingInterval)->Int{
        var queryValue: Double? = nil
        
        HealthManager.shared.getBurnedCaloriesAtDate(
            date: date,
            interval: .month
        ) { calories in
            queryValue = calories
        }
        while queryValue == nil {
            // loop until task executed
        }
        return Int(queryValue!.rounded())
    }
    
    func normFor(_ interval: GroupingInterval)->(Date)->Date{
        switch interval {
        case .year:
            normalizeToYYYY
        case .month:
            normalzeToYYYY_MM
        case .day:
            normallizeDateToYMMD
        }
    }
    
    func groupDishes(norm: (Date)->Date = normallizeDateToYMMD)->[Date:[Dish]] {
        let dayGroupedDishes: [Date:[Dish]] = self.storedDishes.reduce(into: [Date: [Dish]]()) { dict, dish in
            let key = norm(dish.getExactDate())
            
            if dict[key] == nil {
                dict[key] = [dish]
            }
            else {
                dict[key]!.append(dish)
            }
        }
        
        return dayGroupedDishes
    }
    
    private func transfromDayDishesToAcc(_ groupedDishes: [Date: [Dish]], _ interval: GroupingInterval)->[Date:OverviewInfoAcc]{
        let normalizationMethod: (Date)->Date = normFor(interval)
        
        let grouping = groupedDishes.keys.reduce(into: [Date:OverviewInfoAcc]()){newDict, oldKey in
            let newDate = normalizationMethod(oldKey)
            
            let transformedRow: [OverviewInfoAcc] = groupedDishes[oldKey]!.map({dish in
                OverviewInfoAcc(
                    dish: dish,
                    date: newDate
                )
            })
            
            let summedUpRow: OverviewInfoAcc = transformedRow.reduce(into: OverviewInfoAcc(date: newDate)){info,singleAcc in
                info.addOther(singleAcc)
            }
            
            if newDict[newDate] == nil {
                newDict[newDate] = summedUpRow
            }
            else {
                newDict[newDate]!.addOther(summedUpRow)
            }
        }
        
        return grouping
    }

    func getSummedUpExchangers(interval: GroupingInterval)->[OverviewInfoAcc]{
        let dayGroupedDishes: [Date: [Dish]] = groupDishes()
        let transfromedDishes: [Date: OverviewInfoAcc] = transfromDayDishesToAcc(dayGroupedDishes, interval)
        transfromedDishes.keys.forEach {key in
            transfromedDishes[key]!.substractBurntCalories(
                getBurnedCaloriesAtDate(
                    date: key,
                    interval: interval
                )
            )
        }
        let result = transfromedDishes.values.sorted{acc1, acc2 in
            acc1.date > acc2.date
        }
        return result
    }
    
    // When we want to divide accumulated summary for bigger interval (e.g. year)
    // we want also to show accumulated values in smaller interval (e.g. month)
    
    func getSummedUpExchangers(srcContextDate: Date, srcInteravl: GroupingInterval, destInterval: GroupingInterval)->[OverviewInfoAcc]{
        let dayGroupedDishes: [Date: [Dish]] = groupDishes()
        let destFormatAccumulatedDishes: [Date: OverviewInfoAcc] = transfromDayDishesToAcc(dayGroupedDishes, destInterval)
        
        let resultNorm = normFor(srcInteravl)
        let contentOfDestDishes = destFormatAccumulatedDishes.filter {key, value in
            resultNorm(key) == resultNorm(srcContextDate)
        }
        contentOfDestDishes.keys.forEach {key in
            destFormatAccumulatedDishes[key]!.substractBurntCalories(
                getBurnedCaloriesAtDate(
                    date: key,
                    interval: destInterval
                )
            )
        }
        
        let result: [OverviewInfoAcc] = contentOfDestDishes.values
        .sorted {acc1, acc2 in
            acc1.date > acc2.date
        }
        
        return result
    }
    
    func getGlucoseAtDay(date: Date)->[GlucoseReading]{
        let normalizedDate = normallizeDateToYMMD(date)
        return glucoseReadings
            .filter({reading in
            normallizeDateToYMMD(reading.timeOfMeasurement) == normalizedDate
        })
        .sorted(by: {r1, r2 in
            r1.timeOfMeasurement < r2.timeOfMeasurement
        })
    }
    
    func getDishesAtDay(date: Date)->[Dish] {
        let normalizeDate = normallizeDateToYMMD(date)
        return self.storedDishes.filter( { dish in
            normallizeDateToYMMD(dish.date) == normalizeDate
        })
        .sorted(by: {d1, d2 in
            d1.date < d2.date
        })
    }
    
    func removeDish(id: UUID) {
        self.storedDishes.removeAll {
            $0.id == id
        }
    }
    
    func removeReadingAtDate(_ date: Date){
        self.glucoseReadings.removeAll(where: {reading in
            reading.timeOfMeasurement == date
        })
    }
    
    func removeOriginalReading(_ id: UUID){
        self.glucoseReadings.removeAll {
            $0.id == id
        }
    }
    
    func addGlucoseReading(_ glucoseLevel: Int, _ date: Date){
        let newReading = GlucoseReading(
            measuredValue: glucoseLevel,
            timeOfMeasurement: date
        )
        self.glucoseReadings.append(newReading)
        self.glucoseReadings.sort {r1, r2 in
            r1.timeOfMeasurement < r2.timeOfMeasurement
        }
    }
    
    func getCopyOfEmails()-> [String] {
        storedEmailAddresses
    }
    
    func removeEmailAt(_ index : Int){
        self.storedEmailAddresses.remove(at: index)
    }
    
    func sendReport(startDate: Date, endDate: Date) -> Bool {
        return true
    }
    
    func addEmail(_ email: String){
        self.storedEmailAddresses.append(email)
    }
    
    func makeSummaryOfDishProperty(_ dishes: [Dish], _ accMethod: (Dish)->Int)->Int{
        dishes.reduce(0) {acc, dish in
            acc + accMethod(dish)
        }
    }
    
    func makeDaySummaryFromDishes(_ dishes: [Dish], _ date: Date)->BriefDaySummaryData{
        BriefDaySummaryData(
            wwData: makeSummaryOfDishProperty(dishes, {
                $0.getSumWW()
            }),
            wbtData: makeSummaryOfDishProperty(dishes, {
                $0.getSumWbt()
            }),
            kcalData: makeSummaryOfDishProperty(dishes, {
                $0.getSumKcal()
            }),
            kcalBurned: getBurnedCaloriesAtDate(
                date: date,
                interval: .day
            )
        )
    }
    
    func sortDishesDesc(){
        self.storedDishes.sort {d1, d2 in
            d1.date > d2.date
        }
    }
    
    func modifyDish(id: UUID, date: Date, dosages: [FoodDosage]) {
        let dishToModify = self.storedDishes.first {
            $0.id == id
        }
        dishToModify!.modifyDate(date)
        dishToModify!.modifyDosages(dosages)
    }
    
    func addDish(date: Date, dosages: [FoodDosage]) {
        var copyOfDosages: [FoodDosage] = []
        copyOfDosages.append(contentsOf: dosages)
        
        let newDish = Dish(
            date: date,
            foodDosages: copyOfDosages
        )
        self.storedDishes.append(newDish)
        self.sortDishesDesc()
        
    }
    
    func getDatabase()->FoodDatabase{
        self.storedFoodDatabase
    }
    
    func addRemoteFood(remoteFood: SimpleFood){
        self.storedFoodDatabase.addRemoteSimpleFood(remoteFood)
    }
    
    func modifyFoodFromDatabase(_ toAdjust: FoodModel, _ originalReference: FoodModel){
        originalReference.modifyWithValuesOfOther(toAdjust)
    }
    
    func addNewFoodToDatabase(_ food: FoodModel){
        self.storedFoodDatabase.addFood(food)
    }
    
    
    @MainActor func prepareTextAndImagesForMail(_ startDate: Date, _ endDate: Date)->(String, [ImageData]){
        let composer = MailComposer(refModel: self)
        return composer.prepareTextAndImagesForMail(startDate, endDate)
    }
}
