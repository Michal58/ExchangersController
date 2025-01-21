

import SwiftUI

struct MainScreen: View {
    var controller: AppController
    var selectedItem: ObservableWrapper<Int>
    var isSidebarVisible: ObservableWrapper<Bool>
    @ObservedObject var navigationPath: ObservableWrapper<NavigationPath>
    
    struct MainScreenExpansion: View {
        class DateSpecWrapper {
            var date: Date?
            init(date: Date? = nil) {
                self.date = date
            }
        }
        
        var conroller: AppController
        @ObservedObject var selectedItem: ObservableWrapper<Int>
        var sidebarButton: AnyView
        var dateSpecific: DateSpecWrapper = DateSpecWrapper()
        
        func getIntervalFromItem(item: Int? = nil)->GroupingInterval{
            var selectedNumber = 0
            if item != nil {
                selectedNumber = item!
            }
            else {
                selectedNumber = self.selectedItem.wrapped
            }
            
            
            if selectedNumber == 0 {
                return .day
            }
            else if selectedNumber == 1 {
                return .month
            }
            else {
                return .year
            }
        }
        
        
        func getInfoAccToShow()->[OverviewInfoAcc]{
            if dateSpecific.date != nil {
                let destNumber = self.selectedItem.wrapped
                
                return conroller
                    .getModel()
                    .getSummedUpExchangers(
                        srcContextDate: dateSpecific.date!,
                        srcInteravl: getIntervalFromItem(
                            item: destNumber+1
                        ),
                        destInterval: self.getIntervalFromItem())
            }
            else {
                return conroller
                    .getModel()
                    .getSummedUpExchangers(
                        interval: getIntervalFromItem()
                    )
            }
        }
        
        var body: some View {
            StandardContainer(leftElement: AnyView(self.sidebarButton), title: "Overview", top: {
                VStack {
                    Picker(
                        "Selection",
                        selection: $selectedItem.wrapped
                    ) {
                        Text("Days").tag(0)
                        Text("Months").tag(1)
                        Text("Years").tag(2)
                    }.pickerStyle(.segmented)
                }
                .padding(.horizontal)
            },
                              bottom: {
                VStack{
                    AppButton(
                        action: {
                            self.conroller.goFromMainScreenToDishEntry()
                        },
                        extraElement: AnyView(getAddFoodComposition())
                    )
                }
                .padding(.horizontal)
            }) {
                LazyVStack{
                    let overviewAccs = getInfoAccToShow()
                    ForEach(overviewAccs, id: \.date) {infoAcc in
                        let buttonClosure = {
                            let selectedNumber = self.selectedItem.wrapped
                            if selectedNumber == 0 {
                                self.conroller.goToExtendedDaySummary(infoAcc.date)
                            }
                            else if selectedNumber == 1 {
                                self.dateSpecific.date = infoAcc.date
                                self.selectedItem.wrapped = 0
                            }
                            else {
                                self.dateSpecific.date = infoAcc.date
                                self.selectedItem.wrapped = 1
                            }
                        }
                        BriefDayInfoTile(
                            overViewInfoAcc: infoAcc,
                            interval: getIntervalFromItem(),
                            closure: buttonClosure
                        )
                        mockView({
                            self.dateSpecific.date = nil
                        })
                    }
                }
            }
        }
    }
    
    struct MainSidebarExansion: View {
        var controller: AppController
        @ObservedObject var isSidebarVisible: ObservableWrapper<Bool>
        var geo: GeometryProxy
        
        var body: some View {
            MainSidebar(
                conroller: self.controller,
                currentGeometry: geo,
                isSidebarVisible: $isSidebarVisible.wrapped
            )
        }
    }
    
    init(controller: AppController){
        self.controller = controller
        self.selectedItem = ObservableWrapper(wrapped: 0)
        self.isSidebarVisible = ObservableWrapper(wrapped: false)
        self.navigationPath = controller.getNavigationPath()
    }
    
    
    var body: some View {
        let sideBarButton: AnyView = AnyView(
            Button(action: {
                if isSidebarVisible.wrapped {
                    isSidebarVisible.wrapped = false
                }
                else {
                    isSidebarVisible.wrapped = true
                }
            }) {
                Image(systemName: "sidebar.left")
                    .resizable()
                    .scaledToFit()
            }
        )
        ZStack {
            GeometryReader{geo in
                NavigationStack(path: $navigationPath.wrapped) {
                    MainScreenExpansion(
                        conroller: self.controller,
                        selectedItem: self.selectedItem,
                        sidebarButton: sideBarButton)
                    .navigationDestination(for: ViewState.self) { _ in
                        AnyView(
                            self.controller.getViewToDisplay().viewToDisplay
                        )
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                                .fontWeight(.bold)
                                
                            }
                        }
                    }
                }
                .overlay(content: {
                    NavBody(
                        presence: self.controller.getMainPopupPresence()
                    )
                })
                MainSidebarExansion(
                    controller: self.controller,
                    isSidebarVisible: self.isSidebarVisible,
                    geo: geo)
            }
        }
        
    }
}

#Preview {
    let conroller = AppController()
    MainScreen(controller: conroller)
}
