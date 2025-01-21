
import SwiftUI

struct AddFoodEntryView: View {
    struct CancelAddFoodButton: View {
        var controller: AppController
        @ObservedObject var isDiscardPresented: ObservableWrapper<Bool>
        
        init(controller: AppController){
            self.controller = controller
            self.isDiscardPresented = ObservableWrapper(
                wrapped: false
            )
        }
        
        var body: some View {
            Button(action: {
                isDiscardPresented.wrapped.toggle()
            }){
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
            }
                .foregroundStyle(.red)
                .alert("Entry discard", isPresented: $isDiscardPresented.wrapped) {
                    HStack {
                        Button("Cancel", role: .cancel) {
                            // Nothing
                        }
                        Button("Ok", role: .destructive) {
                            self.controller.cancelAddFood()
                        }
                    }
                } message: {
                    Text("Provided food entry will be discarded. Are you sure about your decision?")
                }
        }
    }
    
    struct WithDefinedDosageAcceptButton: View {
        var controller: AppController
        @ObservedObject var definitionOfDosage: DosageSpecificationDefinition
        
        var body: some View {
            let disableIndicator = self.definitionOfDosage.dynamicDosage().totalMass() == 0
            
            AppButton(
                action: {
                    self.controller.acceptAddFood(
                        dosageSpec: self.definitionOfDosage
                    )
                },
                text: "Accept  ",
                extraElement: AnyView(
                    AppButton.transformImageFromSystemName(
                        name: "checkmark"
                    )
                ),
                disableIndicator: disableIndicator
            )
            .disabled(disableIndicator)
        }
    }
    
    struct FoodEntryAcceptView: View {
        var controller: AppController
        var definitionOfDosage: DosageSpecificationDefinition?
        
        var body: some View {
            Spacer()
            
            if self.definitionOfDosage == nil {
                AppButton(
                    action: {
                        // nothing
                    },
                    text: "Accept  ",
                    extraElement: AnyView(
                        AppButton.transformImageFromSystemName(
                            name: "checkmark"
                        )
                    ),
                    disableIndicator: true
                )
                .disabled(true)
            }
            else {
                WithDefinedDosageAcceptButton(
                    controller: self.controller,
                    definitionOfDosage: self.definitionOfDosage!
                )
            }
        }
    }
        

    struct MainAddFoodBody: View {
        var controller: AppController
        var definitionOfDosage: ObservableWrapper<DosageSpecificationDefinition?>
        @ObservedObject var searchResultsBuffer: BrowsingBuffer
        @ObservedObject var focusWrapper: ObservableWrapper<FoodModel?>
        
        
        var body: some View {
            if self.focusWrapper.wrapped == nil && searchResultsBuffer.searchTerm.isEmpty {
                Text("Search to add food")
                    .font(.title)
            }
            
            BrowserView(
                resultsBuffer: searchResultsBuffer,
                focusWrapper: focusWrapper
            )
            .onReceive(self.focusWrapper.objectWillChange){
                if self.focusWrapper.wrapped != nil {
                    self.definitionOfDosage.wrapped = DosageSpecificationDefinition(
                        pieceMass: "0",
                        count: "1",
                        actualFood: self.focusWrapper.wrapped!
                    )
                }
            }
            
            
            if searchResultsBuffer.toShowResults.isEmpty {
                if self.definitionOfDosage.wrapped != nil {
                    SpecificationInput(
                        definitionOfDosage: self.definitionOfDosage.wrapped!
                    )
                }
            }
            
            FoodEntryAcceptView(
                controller: self.controller,
                definitionOfDosage: self.definitionOfDosage.wrapped
            )
        }
    }
    
    var controller: AppController
    var searchResultsBuffer: BrowsingBuffer
    var focusWrapper: ObservableWrapper<FoodModel?>
    var definitionOfDosage: ObservableWrapper<DosageSpecificationDefinition?>
    
    init(
        controller: AppController,
        searchResultsBuffer: BrowsingBuffer
    ) {
        self.controller = controller
        self.searchResultsBuffer = searchResultsBuffer
        let auxWrapper = ObservableWrapper<FoodModel?>(wrapped: nil)
        self.focusWrapper = auxWrapper
        self.definitionOfDosage = ObservableWrapper(wrapped: nil)
    }
    
    var body: some View {
        VStack{
            let xButton = CancelAddFoodButton(
                controller: self.controller
            )
            
            StandardContainer(
                rightElement: AnyView(xButton),
                title: "Add food entry",
                shouldBeBackHidden: true
            ) {
            }
            .frame(height: 0)
            
            MainAddFoodBody(
                controller: self.controller,
                definitionOfDosage: self.definitionOfDosage,
                searchResultsBuffer: self.searchResultsBuffer,
                focusWrapper: self.focusWrapper
            )
        }
        .padding(.horizontal)
    }
}

#Preview {
    let buffer=BrowsingBuffer(browser:nil)
    var browser=Browser(buffer: buffer, debugMode: true)
    let v: () = buffer.setBrowser(browser)
    
    let controller = AppController()
    let viewToDisplay = AddFoodEntryView(
        controller: controller,
        searchResultsBuffer: buffer
    )
    let nav = MockNavigation(viewToDisplay: AnyView(viewToDisplay))
    nav
}
