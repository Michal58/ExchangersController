

import Foundation


class GlucoseReading: Codable {
    private(set) var id: UUID
    private(set) var measuredValue: Int
    private(set) var timeOfMeasurement: Date
    
    init(measuredValue: Int, timeOfMeasurement: Date) {
        self.id = UUID()
        self.measuredValue = measuredValue
        self.timeOfMeasurement = timeOfMeasurement
    }
    
    func getDayTime()->DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.day, .hour], from: self.timeOfMeasurement)
    }
}
