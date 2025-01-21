

import Foundation

class ModelExamples{
    static let glucoseReadings = [
        GlucoseReading(
            measuredValue: 104,
            timeOfMeasurement: createDate(hour: 10, minute: 02)!),
        GlucoseReading(measuredValue: 154,
                       timeOfMeasurement: createDate(hour: 12, minute: 33)!),
        GlucoseReading(measuredValue: 201,
                       timeOfMeasurement: createDate(hour: 16, minute: 49)!)
    ]
    static let emails: [String] = [
        "alex.johnson@example.com",
        "emily.smith@domain.com",
        "michael.brown@website.org",
        "sophia.martinez@company.net",
        "liam.davis@service.co"
    ]
    static let dishes: [Dish] = [
        // today
        Dish(
            date: createDate(hour: 10, minute: 02)!,
            foodDosages: [
                Example.complexDosages[0],
                Example.complexDosages[1]
            ]),
        Dish(
            date: createDate(hour: 12, minute: 23)!,
            foodDosages: [
                Example.complexDosages[2],
                Example.simDosages[8]
            ]),
        Dish(
            date: createDate(hour: 15, minute: 33)!,
            foodDosages: [
                Example.simDosages[9],
                Example.simDosages[10]
            ]),
        // another day
        Dish(
            date: createDate(year: 2025, month: 01, day: 10, hour: 10, minute: 10)!,
            foodDosages: [
                Example.complexDosages[2],
                Example.simDosages[8]
            ]),
        // another year
        Dish(
            date: createDate(year: 2024, month: 12, day: 20, hour: 10, minute: 10)!,
            foodDosages: [
                Example.complexDosages[0],
                Example.simDosages[0]
            ])
    ]
    
    static let model: DataModel = DataModel(
        glucoseReadings:
            ModelExamples.glucoseReadings + [
            GlucoseReading(
                measuredValue: 190,
                timeOfMeasurement: createDate(hour: 23, minute: 59)!),
            GlucoseReading(
                measuredValue: 200,
                timeOfMeasurement: createDate(hour: 0, minute: 0)!)
        ],
        storedEmailAddresses: ModelExamples.emails,
        storedDishes: ModelExamples.dishes,
        storedFoodDatabase: FoodDatabase(
            storedFoodModels: Example.simFoods + Example.complexFood
        )
    )
}
