

import SwiftUI

struct AddGlucoseBody: View {
    static func getDefaultLevelBuffer()->ObservableWrapper<String>{
        ObservableWrapper(wrapped: "")
    }
    
    @ObservedObject var dateBuffer: ObservableWrapper<Date>
    @ObservedObject var levelBuffer: ObservableWrapper<String>
    
    var body: some View{
        DatePicker(
            "",
            selection: $dateBuffer.wrapped,
            displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.wheel)
        .background(StyleElementsGetter.appBackLightGrey)
        .cornerRadius(StyleElementsGetter.boldCorners)
        .padding()
        
        HStack{
            TextField("Glucose level", text: $levelBuffer.wrapped)
                .keyboardType(.numberPad)
                .onChange(of: levelBuffer.wrapped) { old, new in
                    if new.allSatisfy({$0.isNumber}) && new.count < 6 {
                        levelBuffer.wrapped=new
                    }
                    else{
                        levelBuffer.wrapped=old
                    }
                }
                .textFieldStyle(.roundedBorder)
        }
        .padding(.horizontal)
    }
}

#Preview {
    @Previewable @State var bind = false
    
    var doDisp=VStack{
        Button("Go"){
            
            bind=true
            
        }
    }
    
    let currentHour = Calendar.current
    let date=ObservableWrapper(wrapped: Date())
    
    ZStack{
        MockNavigation(viewToDisplay: AnyView(doDisp))
        if bind {
            Popup(
                title: "Add glucose level",
                popupBody:
                    AnyView(
                        AddGlucoseBody(
                            dateBuffer: date,
                            levelBuffer: AddGlucoseBody.getDefaultLevelBuffer()
                        )),
                okClosure: {
                bind=false
                
            }, cancelClosure: {
                bind=false
                
            })
            .onAppear(perform: {print("apper")})
        }
    }
}
