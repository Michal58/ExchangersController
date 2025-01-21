

import SwiftUI

struct DishEntry: View {
    private var conroller: AppController
    private var dish: Dish?
    
    private var dateBuffer: ObservableWrapper<Date>
    
    @ObservedObject private var dosages: ObservableWrapper<[DosageSpecificationDefinition]>
    // these are copies
    var elementsSpacing: CGFloat = 10
    
    
    struct DishDateExpansion: View {
        @ObservedObject var dateBuffer: ObservableWrapper<Date>
        var body: some View {
            HStack{
                Spacer()
                DatePicker(
                    "",
                    selection: $dateBuffer.wrapped,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                Spacer()
            }
        }
    }
    
    struct DishEntryGoBackButon: View {
        var conroller: AppController
        @ObservedObject var isModDiscard: ObservableWrapper<Bool>
        
        init(conroller: AppController){
            self.conroller = conroller
            self.isModDiscard = .init(wrapped: false)
        }
        
        var body: some View {
            Button(action: {
                isModDiscard.wrapped.toggle()
            }){
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
            }
            .alert("Modification discard", isPresented: $isModDiscard.wrapped) {
                    HStack {
                        Button("Cancel", role: .cancel) {
                        }
                        Button("Ok", role: .destructive) {
                            self.conroller.discardDishEntry()
                        }
                    }
                } message: {
                    Text("The modifcation of food entry will be discarded. Are your sure about your decision?")
                }
        }
    }
    
    struct DishDeletionButton: View {
        var conroller: AppController
        @ObservedObject var isFoodDeleted: ObservableWrapper<Bool>
        var originalDishId: UUID?
        
        init(conroller: AppController, originalDishId: UUID? = nil) {
            self.conroller = conroller
            self.isFoodDeleted = .init(wrapped: false)
            self.originalDishId = originalDishId
        }
        
        var body: some View {
            let isFoodNew = originalDishId == nil
            Button(action: {
                isFoodDeleted.wrapped.toggle()
            }) {
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)
                    .opacity(isFoodNew ? 0.3 : 1)
            }
            .disabled(isFoodNew)
            .alert("Food entry deletion", isPresented: $isFoodDeleted.wrapped) {
                    HStack {
                        Button("Cancel", role: .cancel) {
                        }
                        Button("Ok", role: .destructive) {
                            self.conroller.deleteDishEntry(
                                originalDishId: self.originalDishId!
                            )
                        }
                    }
                } message: {
                    Text("This food entry will be permanently removed from your history. Are you sure about your decision?")
                }
        }
    }
    
    init(
        conroller: AppController,
        dish: Dish?,
        elementsSpacing: CGFloat = 10) {
        self.conroller = conroller
        self.dish = dish
        self.dateBuffer = ObservableWrapper(
            wrapped: dish != nil ? self.dish!.date : Date()
        )
        self.elementsSpacing = elementsSpacing
            
        let dosagesAsSpecs = dish?.getDosages().map {
            DosageSpecificationDefinition(readyDosage: $0)
        }
        self.dosages=ObservableWrapper(
            wrapped: dosagesAsSpecs ?? []
        )
    }
    
    func closureOfXButton(_ index: Int) -> Void {
        withAnimation(.smooth){
            self.dosages.wrapped.remove(at: index)
        }
    }
    
    var body: some View {
        let goBackButton = DishEntryGoBackButon(
            conroller: self.conroller
        )
        
        let dishDeletion = DishDeletionButton(
            conroller: self.conroller,
            originalDishId: self.dish?.id ?? nil
        )
        
        let addFoodButton = AppButton(
            action: {
                self.conroller.getFromAddFoodContentForDishEntry(
                    dosages: self.dosages
                )
            },
            text: "Add food  ",
            extraElement: AnyView(AppButton.transformImageFromSystemName(name: "plus"))
        )
        
        let acceptButton = AppButton(
            action: {
                self.conroller.acceptDishEntry(
                    originalId: self.dish?.id ?? nil,
                    date: self.dateBuffer.wrapped,
                    dosages: self.dosages.wrapped.map(
                        {$0.dynamicDosage()}
                    )
                )
            },
            text: "Accept  ",
            extraElement: AnyView(AppButton.transformImageFromSystemName(name: "checkmark"))
        )
        
        StandardContainer(
            leftElement: AnyView(goBackButton),
            rightElement: AnyView(dishDeletion),
            title: "Dish entry", shouldBeBackHidden: true,
            bottom: {
                HStack {
                    acceptButton
                }
                .padding(.horizontal)
            }){
            VStack(spacing: self.elementsSpacing) {
                HStack {
                    Text("Dish time to set")
                        .font(.title2)
                    Spacer()
                    if self.dish == nil {
                        SimpleDateWrapper(
                            dateBuffer: self.dateBuffer,
                            text: ""
                        )
                    }
                }
                DishDateExpansion(dateBuffer: self.dateBuffer)
                HStack{
                    Text("Parts of the dish (actual food)")
                        .font(.title2)
                    Spacer()
                }
                addFoodButton
                let indicesOfDosages = Array(dosages.wrapped.indices)
                ForEach(indicesOfDosages, id:\.self){index in
                    let dosage = dosages.wrapped[index]
                    FoodSpecification(
                        readyDosageSpec: dosage,
                        closureOfXButton: {
                            withAnimation(.smooth){
                                closureOfXButton(index)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    let dataToDisplay = [
        Example.simDosages[0],
        Example.simDosages[1].nonLoaclCopy(),
        Example.complexDosages[2]
    ]
    
    let dish = Dish(date: Date(), foodDosages: dataToDisplay)
    
    let controller = AppController()
    
    let viewToDisplay = DishEntry(
        conroller: controller,
        dish: dish
    )
    let nav = MockNavigation(viewToDisplay: AnyView(viewToDisplay))
    nav
}
