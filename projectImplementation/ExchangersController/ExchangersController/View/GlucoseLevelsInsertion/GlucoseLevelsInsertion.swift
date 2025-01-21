

import SwiftUI

struct GlucoseLevelsInsertion: View {
    var controller: AppController
    var insertionState: GlucoseAtDateState
    
    init(
        popUpPresence: PopupPresenceObserver,
        controller: AppController,
        dateToPick: Date = Date()
    ) {
        self.controller = controller
        insertionState = GlucoseAtDateState(
            popUpPresence: popUpPresence,
            dataModel: controller.getModel(),
            dateToPick: dateToPick
        )
    }
    
    static func getGlucosePopupColsure(
        insertionState: GlucoseAtDateState,
        overloadDate: Date? = nil
    ) -> (()->Void) {
        {
            let date=ObservableWrapper(
                wrapped: overloadDate ?? insertionState.dateToPick
            )
            let levelBuffer = ObservableWrapper(wrapped: "")
            
            withAnimation(.easeInOut){
                let navigationPopupPresence = insertionState.popUpPresence
                navigationPopupPresence.popup = AnyView(
                    Popup(
                        title: "Add glucose level",
                        popupBody: AnyView(
                            AddGlucoseBody(
                                dateBuffer: date,
                                levelBuffer: levelBuffer
                            )
                          ),
                          okClosure: {
                              let date = date.wrapped
                              let level = Int(levelBuffer.wrapped)
                              
                              withAnimation(.easeInOut){
                                  withAnimation(.smooth){
                                      if level != nil {
                                          insertionState.addReading(
                                            level!,
                                            date
                                          )
                                      }
                                  }
                                  navigationPopupPresence.popup=nil
                              }
                          },
                          cancelClosure: {
                              withAnimation(.easeInOut){
                                  navigationPopupPresence.popup=nil
                              }
                          }))
            }
        }
    }
    
    var body: some View {
        let stickyOnBotom =
        HStack{
            AppButton(action:
                        GlucoseLevelsInsertion.getGlucosePopupColsure(
                            insertionState: self.insertionState
                        )
            , extraElement: AnyView(getAddGlucoseComposition()))
        }
        .padding(.horizontal)
        StandardContainer(
            leftElement: AnyView(
                getGoBackButton(
                    closure: {
                        self.controller.goBackFromGlucoseInsertionToMain()
                    }
                )
            ),
            title: "Add glucose levels",
            shouldBeBackHidden: true,
            bottom: {stickyOnBotom}) {
                VStack{
                    DateWrpper(insertionState: self.insertionState)
                }
                .padding()
                ChartAtDate(
                    chartState: self.insertionState
                )
                    .padding(.horizontal)
                VStack{
                    TileWrapperOfGlucoseLevels(
                        insertionState: self.insertionState
                    )
                }
                .padding(.horizontal)
            }
    }
}

#Preview {
    let controller = AppController()
    var presence = PopupPresenceObserver()
    let viewToDisplay = GlucoseLevelsInsertion(popUpPresence: presence,controller: controller)
    let nav = MockNavigation(viewToDisplay: AnyView(viewToDisplay), presence: presence)
    nav
}
