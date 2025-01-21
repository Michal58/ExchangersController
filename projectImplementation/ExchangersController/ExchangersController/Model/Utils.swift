

import Foundation
import SwiftUI

func getNutriteintName(_ nutr: Nutritient)->String {
    switch(nutr){
    case .carb:
        "Carbohydrates"
    case .prot:
        "Proteins"
    case .fat:
        "Fat"
    default:
        ""
    }
}

func getImageForNutr(_ nutr: Nutritient)->Image {
    switch(nutr){
    case .carb:
        Image("Sugar")
    case .prot:
        Image("Milk")
    case .fat:
        Image("Butter")
    default:
        Image("")
    }
}

func areOnlyDigits(_ text: String, emptyIsValid: Bool = false)->Bool {
    (!text.isEmpty || emptyIsValid) &&
    text.allSatisfy({letter in
        letter.isNumber
    })
}

class AuxDateCreation{
    static let DEFAULT_YEAR = Calendar.current.dateComponents([.year], from: Date()).year!
    static let DEFAULT_MONTH = Calendar.current.dateComponents([.month], from: Date()).month!
    static let DEFAULT_DAY = Calendar.current.dateComponents([.day], from: Date()).day!
    static let DEFAULT_HOUR = Calendar.current.dateComponents([.hour], from: Date()).hour!
    static let DEFAULT_MINUTE = Calendar.current.dateComponents([.minute], from: Date()).minute!
    
    static let DEFAULT_DATE: Date = createDate(
        year: DEFAULT_YEAR,
        month: DEFAULT_MONTH,
        day: DEFAULT_DAY,
        hour: DEFAULT_HOUR,
        minute: DEFAULT_MINUTE)!
}

func createDate(
    year: Int = AuxDateCreation.DEFAULT_YEAR,
    month: Int = AuxDateCreation.DEFAULT_MONTH,
    day: Int = AuxDateCreation.DEFAULT_DAY,
    hour: Int = AuxDateCreation.DEFAULT_HOUR,
    minute: Int = AuxDateCreation.DEFAULT_MINUTE)->Date?{
    var componentsOfDate = DateComponents()
    
    componentsOfDate.year = year
    componentsOfDate.month = month
    componentsOfDate.day = day
    componentsOfDate.hour = hour
    componentsOfDate.minute = minute
    
    return Calendar.current.date(from: componentsOfDate)
}


func normallizeDateToYMMD(_ date: Date)->Date {
    let normalizedComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
    return Calendar.current.date(from: normalizedComponents)!
}

// different format intentionally - I want it clearly differ from function above
func normalzeToYYYY_MM(_ date: Date)->Date {
    let normalizedComponents = Calendar.current.dateComponents([.year, .month], from: date)
    return Calendar.current.date(from: normalizedComponents)!
}


func normalizeToYYYY(_ date: Date)->Date {
    let normalizedComponents = Calendar.current.dateComponents([.year], from: date)
    return Calendar.current.date(from: normalizedComponents)!
}

func getFormatInHHMM(_ date: Date)->String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
}

func getFormatInDDMMYYYY(_ date: Date, sep: String = "/")->String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd\(sep)MM\(sep)yyyy"
    return formatter.string(from: date)
}

func getFormatInMMYYYY(_ date: Date)->String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/yyyy"
    return formatter.string(from: date)
}

func getFormatInYYYY(_ date: Date)->String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return formatter.string(from: date)
}

func getInclusiveDatesRange(startDate: Date, endDate: Date, interval: Calendar.Component = .day)->[Date]{
    //stack overflow solution
    
    let calendar = Calendar.current

        var matchingDates = [startDate]
        
        let components = DateComponents(hour: 0, minute: 0, second: 0)
        calendar.enumerateDates(startingAfter: startDate, matching: components, matchingPolicy: .nextTime) { (date, strict, stop) in
            if let date = date {
                if date <= endDate {
                    matchingDates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return matchingDates
}


class ListBuffer<T> {
    var list: [T]
    init(list: [T] = []) {
        self.list = list
    }
}

func printV(_ str: Any)->some View {
    print(str)
    return EmptyView()
}

// for getting effective references
class RefWrap<T>{
    var wrapped: T
    init(wrapped: T) {
        self.wrapped = wrapped
    }
}


class ObservableWrapper<T>: ObservableObject{
    @Published var wrapped: T
    init(wrapped: T) {
        self.wrapped = wrapped
    }
}


func startOfDay(_ baseDate: Date) -> Date {
    let calendar = Calendar.current
    
    let currentDate = baseDate
    let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
    
    var updatedComponents = components
    updatedComponents.hour = 0
    updatedComponents.minute = 0
    updatedComponents.second = 0
    
    return calendar.date(from: updatedComponents)!
}

func endOfDay(_ baseDate: Date) -> Date {
    let start = startOfDay(baseDate)
    return Calendar.current.date(byAdding: DateComponents(hour: 23, minute: 59, second: 59), to: start)!
}

func mockView(_ closure: ()->(Void))->EmptyView {
    closure()
    return EmptyView()
}

struct ImageData {
    let imageName: String
    let actualImage: Data
}

@MainActor func renderViewToPNG<T: View>(
    viewToConvert: T,
    size: CGSize
) -> Data? {
    let renderer = ImageRenderer(
        content:
            viewToConvert
            .padding(15)
            .frame(
                width: size.width,
                height: size.height
            )
    )
    return renderer.uiImage?.pngData() ?? nil
}


