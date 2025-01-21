import SwiftUI

struct FoodSearch: View {
    var conroller: AppController
    var searchResultsBuffer: BrowsingBuffer
    @ObservedObject var focusWrapper: ObservableWrapper<FoodModel?>
    
    init(
        controller: AppController,
        searchResultsBuffer: BrowsingBuffer) {
        self.conroller = controller
        self.searchResultsBuffer = searchResultsBuffer
        self.focusWrapper = ObservableWrapper(wrapped: nil)
    }
    
    func getAddToDatabaseComposition()->AnyView {
        AnyView(
            HStack{
                AppButton.transformImageFromSystemName(name: "plus")
                AppButton.transformImageFromName(name: "DatabaseImg")
            }
                .padding(.horizontal)
        )
    }
    
    func getModifyComposition()->AnyView {
        AnyView(AppButton.transformImageFromSystemName(name: "square.and.pencil")
            .scaleEffect(1.3)
        .padding(.horizontal)
                )
    }
    
    var body: some View {
        let goBackButton = Button(action: {
            self.conroller.goBackFromSearch()
        }){
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
        }
        let localBrowserView = BrowserView(
            resultsBuffer: self.searchResultsBuffer,
            focusWrapper: self.focusWrapper
        )
        
        
        VStack{
            localBrowserView
            Spacer()
        }
        .padding(.horizontal)
        
        StandardContainer(
            leftElement: AnyView(goBackButton),
            title: "Food search",
            shouldBeBackHidden: true) {
            }
            .frame(height: 0)
        Spacer()
        
        HStack{
            if self.focusWrapper.wrapped != nil && !self.focusWrapper.wrapped!.isLocal() {
                AppButton(
                    action: {
                        self.conroller.addFoodToDatabaseFromSearch(
                            focusWrapper: self.focusWrapper
                        )
                    },
                    text: "Add to database",
                    extraElement: self.getAddToDatabaseComposition()
                )
            }
            else {
                AppButton(
                    action: {
                        self.conroller.modifyFoodFromSearch(
                            originalFood: self.focusWrapper.wrapped!
                        )
                    },
                    text: "Modify",
                    extraElement: self.getModifyComposition(),
                    disableIndicator: self.focusWrapper.wrapped == nil
                )
                .disabled(self.focusWrapper.wrapped == nil)
            }
        }
        .padding(.horizontal)
        
    }
}

#Preview {
    let controller = AppController()
    
    let buffer=BrowsingBuffer(browser:nil)
    var browser=Browser(buffer: buffer, debugMode: false, model: controller.getModel())
    let v: () = buffer.setBrowser(browser)
    
    
    let viewToDisplay = FoodSearch(
        controller: controller,
        searchResultsBuffer: buffer
    )
    let nav = MockNavigation(viewToDisplay: AnyView(viewToDisplay))
    nav
}

