

import SwiftUI

struct ExtendedDaySummary: View {
    var conroller: AppController
    var insertionState: GlucoseAtDateState
    
    init(controller: AppController,
         model: DataModel,
         dayOfSummary: Date,
         navigationPopupPresence: PopupPresenceObserver) {
        self.conroller = controller
        self.insertionState = GlucoseAtDateState(
            popUpPresence: navigationPopupPresence,
            dataModel: model,
            dateToPick: dayOfSummary
        )
    }
    
    var body: some View {
        let goBackButton = Button(action: {
            self.conroller.goBackFromExtendedScreenToMainScreen()
        }){
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
        }
        let dishesInADay = self.insertionState.getDishesAtSetDate()
        ZStack{
            StandardContainer(
                leftElement: AnyView(goBackButton),
                title: getFormatInDDMMYYYY(
                    self.insertionState.dateToPick
                ),
                shouldBeBackHidden: true
            ){
                HStack {
                    let summaryDataSource = self.insertionState.makeDaySummaryFromDishes(dishesInADay)
                    BriefDaySummary(
                        summaryData: summaryDataSource
                    )
                }
                .padding(.horizontal)
                HStack {
                    Text("Eaten dishes")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                ForEach(dishesInADay){dish in
                    HStack {
                        DishSummary(
                            dishComposition: dish,
                            editClosure: {
                                self.conroller.goFromExtendedSummaryToDishEntry(dish)
                            },
                            alertCallClosure: GlucoseLevelsInsertion
                                .getGlucosePopupColsure(
                                    insertionState: self.insertionState,
                                    overloadDate: dish.date
                            )
                        )
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    let conroller = AppController()
    var presence = PopupPresenceObserver()
    let viewToDisplay = ExtendedDaySummary(
        controller: conroller,
        model: ModelExamples.model,
        dayOfSummary: Date(),
        navigationPopupPresence: presence)
    let nav = MockNavigation(viewToDisplay: AnyView(viewToDisplay), presence: presence)
    nav
}
