

import SwiftUI

struct Charts: View {
    var controller: AppController
    @ObservedObject var startDate: ObservableWrapper<Date>
    @ObservedObject var endDate: ObservableWrapper<Date>
    
    var body: some View {
        StandardContainer(
            leftElement: AnyView(
                getGoBackButton(
                    closure: {
                        self.controller.goFromChartToMain()
                    }
                )
            ),
            title: "Charts",
            shouldBeBackHidden: true,
            bottom: {
                ReportUpload.ReportsStickyBottom(
                    dateModel: self.controller.getModel(),
                    startDate: self.startDate,
                    endDate: self.endDate)
                    .padding(.horizontal)
            }) {
                VStack{
                    DatePicker("Start date", selection: $startDate.wrapped, displayedComponents: .date)
                        .datePickerStyle(.compact)
                    DatePicker("End date", selection: $endDate.wrapped, displayedComponents: .date)
                        .datePickerStyle(.compact)
                    ForEach(
                        getInclusiveDatesRange(
                            startDate: self.startDate.wrapped,
                            endDate: self.endDate.wrapped
                        ),
                        id: \.self
                    ){date in
                        VStack(spacing: 10) {
                            DayGraphicalComposition(
                                state: GlucoseAtDateState(
                                    dataModel: self.controller.getModel(),
                                    dateToPick: date
                                )
                            )
                            Divider()
                        }
                    }
                }
                .padding()
                
            }
    }
}

#Preview {
    var presence = PopupPresenceObserver()
    let controller = AppController()
    let viewToDisplay = Charts(
        controller: controller,
        startDate:
            ObservableWrapper(
                wrapped:Date()
            ),
        endDate:
            ObservableWrapper(
                wrapped: Date()
            )
    )
    let nav = MockNavigation(viewToDisplay: AnyView(viewToDisplay), presence: presence)
    nav
}
