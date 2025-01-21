

import Foundation
import HealthKit

class HealthManager {
    private var healthStore: HKHealthStore?
    private(set) var queriedAuthorization: Bool
    private(set) var isAuthorized: Bool
    
    static let shared = HealthManager()
    
    private init() {
        self.healthStore = HealthManager.initializeHealthStore()
        self.queriedAuthorization = false
        self.isAuthorized = false
    }
    
    static func initializeHealthStore()->HKHealthStore? {
        let isHealthDataAvailable = HKHealthStore.isHealthDataAvailable()
        if !isHealthDataAvailable {
            return nil
        }
        else {
            return HKHealthStore()
        }
    }
    
    func requestAuthorization() {
        self.queriedAuthorization = true
        
        if let healthStore = self.healthStore {
            let paramsToRead: Set<HKObjectType> = [
                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
            ]
            
            var wasClosureExecuted = false
            healthStore.requestAuthorization(
                toShare: nil,
                read: paramsToRead
            ) { success, error in
                wasClosureExecuted = true
                if error != nil || !success {
                    self.isAuthorized = false
                }
                else {
                    self.isAuthorized = true
                }
            }
            if !wasClosureExecuted {
                self.isAuthorized = true
            }
        }
    }
    
    func getBurnedCaloriesAtDate(
        date: Date,
        interval: GroupingInterval,
        completion: @escaping (Double) -> Void
    ) {
        if !self.queriedAuthorization {
            self.requestAuthorization()
        }
        if !self.isAuthorized {
            completion(0)
            return
        }
        
        let calorieType = HKQuantityType.quantityType(
            forIdentifier: .activeEnergyBurned
        )!
        
        let calendar = Calendar.current
        var startDate: Date!
        var endDate: Date!
        var addingComponent: Calendar.Component!
        var intervalComponents: DateComponents!
        
        switch interval {
        case .day:
            startDate = calendar.date(
                from: calendar.dateComponents(
                    [.year, .month, .day],
                    from: date
                )
            )!
            addingComponent = .day
            intervalComponents = DateComponents(day: 1)
        case .month:
            startDate = calendar.date(
                from: calendar.dateComponents(
                    [.year, .month],
                    from: date
                )
            )!
            addingComponent = .month
            intervalComponents = DateComponents(month: 1)
        case .year:
            startDate = calendar.date(
                from: calendar.dateComponents(
                    [.year],
                    from: date
                )
            )!
            addingComponent = .year
            intervalComponents = DateComponents(year: 1)
        }
        
        endDate = calendar.date(
            byAdding: addingComponent,
            value: 1,
            to: startDate
        )!
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate
        )
        
        let query = HKStatisticsCollectionQuery(
            quantityType: calorieType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startDate,
            intervalComponents: intervalComponents
        )
        
        query.initialResultsHandler = { _, results, error in
            guard error == nil, let results = results else {
                completion(0)
                return
            }
            
            var totalCalories: Double = 0
            results.enumerateStatistics(
                from: startDate,
                to: endDate
            ) { statistics, _ in
                if let sum = statistics.sumQuantity() {
                    totalCalories +=
                    sum.doubleValue(
                        for: HKUnit.kilocalorie()
                    )
                }
            }
            completion(totalCalories)
        }
        
        self.healthStore!.execute(query)
    }
}
