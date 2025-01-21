

import Foundation

class GlucoseAtDateState: ObservableObject {
    private var dataModel: DataModel
    @Published var popUpPresence: PopupPresenceObserver
    @Published var dateToPick: Date {
        didSet {
            updateGlucoseAtDate()
        }
    }
    @Published private(set) var glucoseAtDate: [GlucoseReading]
    
    init(
        popUpPresence: PopupPresenceObserver = PopupPresenceObserver(),
        dataModel: DataModel,
        dateToPick: Date) {
        self.popUpPresence = popUpPresence
        self.dataModel = dataModel
        self.glucoseAtDate = []
        self.dateToPick = dateToPick
        updateGlucoseAtDate()
    }
    
    func updateGlucoseAtDate(){
        self.glucoseAtDate = dataModel.getGlucoseAtDay(date: dateToPick)
    }
    
    func removeReadingAt(_ index: Int){
        dataModel.removeOriginalReading(self.glucoseAtDate[index].id)
        glucoseAtDate = dataModel.getGlucoseAtDay(date: dateToPick)
    }
    
    func addReading(_ level: Int, _ date: Date){
        print(date)
        self.dataModel.addGlucoseReading(level, date)
        self.updateGlucoseAtDate()
    }
    
    func glucoseAtDate(_ date: Date)->[GlucoseReading] {
        self.dataModel.getGlucoseAtDay(date: date)
    }
    
    func makeDaySummaryFromDishes(_ dishes: [Dish])->BriefDaySummaryData{
        self.dataModel.makeDaySummaryFromDishes(dishes, dateToPick)
    }
    
    func glucoseAtSetDate()->[GlucoseReading] {
        self.dataModel.getGlucoseAtDay(date: self.dateToPick)
    }
    
    func getDishesAtSetDate()->[Dish] {
        self.dataModel.getDishesAtDay(date:self.dateToPick)
    }
    
    private func makeAccumulatedDishFromDict(key: String, groupedDishes: [String: [Dish]])->Dish{
        let dishesRow: [Dish] = groupedDishes[key]!
        var accumulatedDosages: [FoodDosage] = []
        
        for dish in dishesRow[0...] {
            accumulatedDosages.append(contentsOf: dish.getDosages())
        }
        
        return Dish(date: dishesRow[0].getExactDate(),
             foodDosages: accumulatedDosages
        )
    }
    
    func getDishesGroupedByHHMM()->[Dish]{
        let allDishes = self.getDishesAtSetDate()
        let groupedDishes = allDishes.reduce(into: [String:[Dish]]()) { result, dish in
            let key = dish.getStrTimeOfDay()
            if result[key] == nil {
                result[key] = [dish]
            } else {
                result[key]!.append(dish)
            }
        }
        return groupedDishes.keys.map {
            makeAccumulatedDishFromDict(key: $0, groupedDishes: groupedDishes)
        }
    }
}
