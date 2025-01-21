

import Foundation
import SwiftUI

func getAddFoodComposition() -> some View {
    HStack{
        AppButton.transformImageFromSystemName(name: "plus")
        AppButton.transformImageFromName(name: "appleFood", scaleFactor: 0.4)
    }
}

func getAddGlucoseComposition() -> some View {
    HStack {
        AppButton.transformImageFromSystemName(name: "plus")
        AppButton.transformImageFromName(name: "DropImg", scaleFactor: 0.4)
    }
}

func getSendReportComposition() -> some View {
    HStack {
        AppButton.transformImageFromSystemName(name: "plus")
        AppButton.transformImageFromSystemName(name: "square.and.arrow.up", scaleFactor: 0.4)
    }
}

func getAddEmailComposition()-> some View {
    HStack {
        AppButton.transformImageFromSystemName(name: "plus")
        AppButton.transformImageFromSystemName(name: "envelope")
    }
}

struct SimpleDateWrapper: View {
    @ObservedObject var dateBuffer: ObservableWrapper<Date>
    var text: String
    
    var body: some View {
        DatePicker(
            text,
            selection: $dateBuffer.wrapped,
            displayedComponents: .date
        )
        .datePickerStyle(.compact)
    }
}

struct DateWrpper: View {
    @ObservedObject var insertionState: GlucoseAtDateState
    var text: String = "Select date"
    
    var body: some View {
        DatePicker(
            text,
            selection: $insertionState.dateToPick,
            displayedComponents: .date)
            .datePickerStyle(.compact)
    }
}


    
