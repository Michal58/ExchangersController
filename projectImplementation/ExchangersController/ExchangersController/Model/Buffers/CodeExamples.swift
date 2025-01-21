

import Foundation

struct Example{
    
    static let simFoods: [SimpleFood] = [
        SimpleFood(name: "Sim1", massSpecifier: 100, carbohydates: 20, proteins: 50, fat: 3),
        SimpleFood(name: "Sim2", massSpecifier: 100, carbohydates: 25, proteins: 40, fat: 5),
        SimpleFood(name: "Sim3", massSpecifier: 100, carbohydates: 30, proteins: 35, fat: 6),
        SimpleFood(name: "Sim4", massSpecifier: 250, carbohydates: 18, proteins: 60, fat: 8),
        SimpleFood(name: "Sim5", massSpecifier: 120, carbohydates: 22, proteins: 55, fat: 4),
        SimpleFood(name: "Sim6", massSpecifier: 180, carbohydates: 28, proteins: 45, fat: 7),
        SimpleFood(name: "Sim7", massSpecifier: 220, carbohydates: 26, proteins: 50, fat: 9),
        SimpleFood(name: "Sim8", massSpecifier: 140, carbohydates: 24, proteins: 42, fat: 3),
        SimpleFood(name: "Sim9", massSpecifier: 160, carbohydates: 29, proteins: 47, fat: 6),
        SimpleFood(name: "Sim10", massSpecifier: 190, carbohydates: 27, proteins: 48, fat: 5),
        SimpleFood(name: "Sim11", massSpecifier: 130, carbohydates: 20, proteins: 40, fat: 4),
    ]
    
    static let simDosages: [FoodDosage] = [
        FoodDosage(mass: 200, count: 1, actualFood: simFoods[0]),
        FoodDosage(mass: 300, count: 1, actualFood: simFoods[1]),
        FoodDosage(mass: 150, count: 2, actualFood: simFoods[2]),
        FoodDosage(mass: 300, count: 3, actualFood: simFoods[3]),
        FoodDosage(mass: 250, count: 2, actualFood: simFoods[4]),
        FoodDosage(mass: 180, count: 1, actualFood: simFoods[5]),
        FoodDosage(mass: 400, count: 3, actualFood: simFoods[6]),
        FoodDosage(mass: 220, count: 1, actualFood: simFoods[7]),
        FoodDosage(mass: 360, count: 2, actualFood: simFoods[8]),
        FoodDosage(mass: 300, count: 1, actualFood: simFoods[9]),
        FoodDosage(mass: 100, count: 1, actualFood: simFoods[10])
    ]
    
    static let complexReadyToNest = ComplexFood(name: "toNext", massSpecifier: 100, foodExtension: [simDosages[0], simDosages[1]])
    static let dosageToNest = FoodDosage(mass: 150, count: 1, actualFood: complexReadyToNest)
    
    
    static let complexFood: [ComplexFood] = [
        ComplexFood(name: "cpx1", massSpecifier: 100, foodExtension: [simDosages[0], simDosages[2]]),
        ComplexFood(name: "cpx2", massSpecifier: 500, foodExtension: [simDosages[3], simDosages[4], simDosages[5]]),
        ComplexFood(name: "cpx3", massSpecifier: 100, foodExtension: [dosageToNest, simDosages[6], simDosages[7]])
    ]
    
    static let complexDosages: [FoodDosage]=[
        FoodDosage(mass: 120, count: 1, actualFood: complexFood[0]),
        FoodDosage(mass: 300, count: 2, actualFood: complexFood[1]),
        FoodDosage(mass: 100, count: 1, actualFood: complexFood[2])
    ]
    
    static let calendar = Calendar.current
    
    static let dates=[
        calendar.date(from: DateComponents(year: 2023, month: 12, day: 15, hour: 9, minute: 30))!,
        calendar.date(from: DateComponents(year: 2023, month: 5, day: 10, hour: 14, minute: 45))!,
        calendar.date(from: DateComponents(year: 2023, month: 8, day: 20, hour: 18, minute: 15))!,
        calendar.date(from: DateComponents(year: 2024, month: 3, day: 5, hour: 6, minute: 50))!,
        calendar.date(from: DateComponents(year: 2025, month: 1, day: 25, hour: 23, minute: 10))!
    ]
    
    static let dishes: [Dish] = [
        Dish(date: dates[0], foodDosages: [complexDosages[0],complexDosages[1]]),
        Dish(date: dates[1], foodDosages: [complexDosages[2],simDosages[8]]),
        Dish(date: dates[0], foodDosages: [simDosages[9],simDosages[10]])
    ]
}
