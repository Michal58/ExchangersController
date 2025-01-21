

import SwiftUI

struct EmailAddPopupBody: View {
    @ObservedObject var emailBuffer: ObservableWrapper<String>
    
    var body: some View {
        HStack{
            TextField("Mail", text: $emailBuffer.wrapped)
                .keyboardType(.default)
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
    let date=Date()
    
    ZStack{
        MockNavigation(viewToDisplay: AnyView(doDisp))
        if bind {
            Popup(title: "Indicate email", popupBody: AnyView(EmailAddPopupBody(emailBuffer: ObservableWrapper(wrapped: ""))),okClosure: {
                bind=false
                
            }, cancelClosure: {
                bind=false
                
            })
            .onAppear(perform: {print("apper")})
        }
    }
}
