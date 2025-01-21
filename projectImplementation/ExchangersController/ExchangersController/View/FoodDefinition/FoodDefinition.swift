

import SwiftUI

struct FoodDefinition: View {
    private var controller: AppController
    private var refeneceOfFood: FoodModel?
    private var bufferFood: FoodModel
    
    private var foodSpecification: FoodModelSpecification
    
    struct DiscardButton: View {
        var controller: AppController
        @State var isDiscardPresented: Bool
        
        init(
            isDiscardPresented: Bool = false,
            controller: AppController
        ) {
            self.controller = controller
            self.isDiscardPresented = isDiscardPresented
        }
        
        var body: some View {
            Button(action: {
                isDiscardPresented.toggle()
            }){
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
            }
                .foregroundStyle(.red)
                .alert("Discard definition", isPresented: $isDiscardPresented) {
                    HStack {
                        Button("Cancel", role: .cancel) {
                            // Nothing
                        }
                        Button("Ok", role: .destructive) {
                            self.controller.cancelFoodDefinition()
                        }
                    }
                } message: {
                    Text("Your changes will be permanetly discarded. Are you sure about your decision?")
                }
        }
    }
    
    struct AcceptButton: View {
        var referenceFood: FoodModel?
        @ObservedObject var foodSpec: FoodModelSpecification
        var controller: AppController
        
        var body: some View {
            AppButton(
                action: {
                    if self.referenceFood != nil {
                        self.controller.commitModification(
                            specification: self.foodSpec,
                            reference: self.referenceFood!
                        )
                    }
                    else {
                        self.controller.commitAddFood(
                            specification: self.foodSpec
                        )
                    }
                },
                text: "Accept  ",
                extraElement: AnyView(
                    AppButton.transformImageFromSystemName(
                        name: "checkmark"
                    )
                ),
                disableIndicator: !foodSpec.isValid()
            )
            .disabled(!foodSpec.isValid())
            .padding(.horizontal)
        }
    }
    
    init(isComplex: Bool, controller: AppController) {
        self.controller = controller
        self.bufferFood = isComplex ? ComplexFood.createDefaultModel() : SimpleFood.createDefaultModel()
        self.refeneceOfFood = nil
        
        if isComplex {
            self.foodSpecification = ComplexFoodSpecification(
                actualFoodModel: self.bufferFood as! ComplexFood
            )
        }
        else {
            self.foodSpecification = SimpleFoodSpecification(
                actualFoodModel: self.bufferFood as! SimpleFood
            )
        }
    }
    
    init(referenceOfFood: FoodModel, controller: AppController) {
        self.controller = controller
        self.refeneceOfFood = referenceOfFood
        self.bufferFood = referenceOfFood.copy()
        
        if referenceOfFood is ComplexFood {
            self.foodSpecification = ComplexFoodSpecification(
                actualFoodModel: self.bufferFood as! ComplexFood
            )
        }
        else {
            self.foodSpecification = SimpleFoodSpecification(
                actualFoodModel: self.bufferFood as! SimpleFood
            )
        }
    }
    
    var body: some View {
        let xButton = DiscardButton(controller: self.controller)
        
        let acceptButton = AnyView(
            AcceptButton(
                referenceFood: self.refeneceOfFood,
                foodSpec: self.foodSpecification,
                controller: self.controller
            )
        )

        StandardContainer(
            leftElement: AnyView(xButton),
            title: "Define food",
            shouldBeBackHidden: true,
            bottom: {acceptButton}) {
                VStack {
                    if self.bufferFood is SimpleFood {
                        SimpleFoodDefinition(
                            simpleSpecification: self.foodSpecification as! SimpleFoodSpecification
                        )
                    }
                    else {
                        ComplexFoodDefinition(
                            complexSpecification: self.foodSpecification as! ComplexFoodSpecification,
                            controller: self.controller
                        )
                    }
                }
                .padding(.horizontal)
        }
    }
}

#Preview {
    let controller = AppController()
    let viewToDisplay = FoodDefinition(
        referenceOfFood: Example.complexFood[0],
        controller: controller
    )
    let nav = MockNavigation(viewToDisplay: AnyView(viewToDisplay))
    nav
}
