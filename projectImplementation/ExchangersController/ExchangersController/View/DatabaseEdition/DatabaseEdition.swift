

import SwiftUI

struct DatabaseEdition: View {
    private var database: FoodDatabase
    @ObservedObject private var browsingBuffer: BrowsingBuffer
    var controller: AppController
    private var buttonsScale: CGFloat
    
    struct RemoveFromDatabaseButton: View {
        var browsingBuffer: BrowsingBuffer
        var database: FoodDatabase
        var removeID: UUID
        
        var scale: CGFloat
        @State var isDiscardPresented: Bool = false
        
        
        init(
            browsingBuffer: BrowsingBuffer,
            database: FoodDatabase,
            removeID: UUID,
            scale: CGFloat = 1.5
        ) {
            self.browsingBuffer = browsingBuffer
            self.database = database
            self.removeID = removeID
            
            self.scale = scale
            self.isDiscardPresented = isDiscardPresented
        }
        
        var body: some View {
            Button(action: {
                isDiscardPresented = true
            }){
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .scaleEffect(scale)
            .alert("Delete food entry", isPresented: $isDiscardPresented) {
                HStack {
                    Button("Cancel", role: .cancel) {
                        // Nothing
                    }
                    Button("Ok", role: .destructive) {
                        self.database.removeFoodWithID(self.removeID)
                        withAnimation(.smooth){
                            self.browsingBuffer.updateBrowserResults(self.database.getFoodModels())
                        }
                    }
                }
            } message: {
                Text("Are you sure that you want remove pernamently Grandma’s brocolli from database?")
            }
        }
    }
    
    init(/*database: FoodDatabase,*/
         initialBuffer: BrowsingBuffer,
         controller: AppController,
         buttonsScale: CGFloat = 1.5
    ) {
        self.database = controller.getModel().getDatabase()
        self.controller = controller
        self.buttonsScale = buttonsScale
        self.browsingBuffer = initialBuffer
        self.browsingBuffer.updateBrowserResults(database.getFoodModels().map({$0}))
    }
    
    var body: some View {
        StandardContainer(
            leftElement: AnyView(
                getGoBackButton(
                    closure: {
                        self.controller.goFromDatabaseToMain()
                    }
                )
            ),
            title: "Local database",
            shouldBeBackHidden: true) {
            }
            .frame(height: 0)
        VStack{
            HStack(alignment: .center){
                Image(systemName: "fork.knife")
                    .font(.title2) // changed font of title
                Toggle("", isOn: $browsingBuffer.shouldSearchComplex)
                    .labelsHidden()
                Spacer()
            }
            .padding(.bottom, 5)
            ScrollView{
                LazyVStack {
                    
                    ForEach(browsingBuffer.toShowResults, id:\.name){searchResult in
                        HStack(alignment: .center, spacing: 10) {
                            Button(action: {
                                self.controller.modifyFoodFromDatabase(
                                    originalFood: searchResult
                                )
                            })
                            {
                                AppButton.transformImageFromSystemName(name: "square.and.pencil")
                            }
                            .scaleEffect(self.buttonsScale)
                            FoodNotation(foodModel: searchResult)
                            RemoveFromDatabaseButton(
                                browsingBuffer: self.browsingBuffer,
                                database: self.database,
                                removeID: searchResult.idOfFood
                            )
                        }
                        .padding()
                        .background(StyleElementsGetter.appStrongGray)
                        .cornerRadius(StyleElementsGetter.boldCorners)
                    }
                    
                }
                .padding()
            }
            .frame(maxHeight: browsingBuffer.toShowResults.isEmpty ? 0 : .infinity)
            .background(StyleElementsGetter.appBackLightGrey)
            .cornerRadius(StyleElementsGetter.boldCorners)
            .listStyle(.plain)
            .searchable(text: $browsingBuffer.searchTerm, prompt: "Filter")
            Spacer()
            AppButton(action: {
                self.controller.goFromDatabaseToSearch()
            },text: "Find in outer database", extraElement: AnyView(Image("SearchImg").font(AppButton.fontType)))
            AppButton(action: {
                self.controller.startAddingFood(isComlex: false)
            },text: "Add food ingredient      ", extraElement: AnyView(
                AppButton.transformImageFromSystemName(name: "carrot.fill")
                    .scaleEffect(self.buttonsScale)))
            AppButton(action: {
                self.controller.startAddingFood(isComlex: true)
            },
                      text: "Add complex food      ",
                      extraElement: AnyView(AppButton.transformImageFromSystemName(name: "fork.knife")
                .scaleEffect(self.buttonsScale)))
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    let database = FoodDatabase(storedFoodModels: Example.simFoods + Example.complexFood)
    let controller = AppController()
    
    let viewToDisplay = DatabaseEdition(
        initialBuffer:
            BrowsingBuffer(
                browser: nil,
                onEmptyAction: BrowsingBuffer.noFilter
            ),
        controller: controller
    )
    let nav = MockNavigation(viewToDisplay: AnyView(viewToDisplay))
    nav
}
