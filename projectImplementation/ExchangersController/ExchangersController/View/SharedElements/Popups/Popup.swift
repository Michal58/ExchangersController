

import SwiftUI

struct Popup: View {
    var title: String
    var popupBody: AnyView
    
    var okClosure: ()->Void
    var cancelClosure: ()->Void
    
    var body: some View {
        ZStack{
            VStack {
                VStack(alignment: .center){
                    VStack {
                        HStack(alignment: .top){
                            Text(self.title)
                                .font(.title2)
                        }
                    }
                    .padding(.top)
                    VStack {
                        self.popupBody
                    }
                    .padding(.horizontal)
                    VStack(spacing: 0) {
                        Divider()
                        
                        HStack(spacing: 0) {
                            Button(action: {okClosure()}){
                                HStack{
                                    Spacer()
                                    Text("Ok")
                                    Spacer()
                                }
                            }
                            
                            Divider()
                            Button(role: .destructive, action: {cancelClosure()}){
                                HStack{
                                    Spacer()
                                    Text("Cancel")
                                    Spacer()
                                }
                            }
                        }
                        .frame(height: 50)
                    }
                }
                .background(StyleElementsGetter.appStrongGray)
                .cornerRadius(StyleElementsGetter.boldCorners)
                Spacer()
            }
        }
        .ignoresSafeArea()
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.7))
    }
}

#Preview {
    let currentHour = Calendar.current
    let date=ObservableWrapper(wrapped: Date())
    
    var presence = PopupPresenceObserver()
    
    let pop = Popup(title: "Add glucose level", popupBody: AnyView(
        AddGlucoseBody(
            dateBuffer: date,
            levelBuffer: AddGlucoseBody.getDefaultLevelBuffer()
        )
    ),
                    okClosure: {
        withAnimation {
            presence.popup = nil
        }
    }, cancelClosure: {
        withAnimation{
            presence.popup = nil
        }
    })
    .onAppear(perform: {print("apper")})
    
    var doDisp=VStack {
        StandardContainer(title: "Title", shouldBeBackHidden: false){
            }
        .frame(height: 0)
        HStack{
            HStack{
                
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(.black)
        }
        .padding(.horizontal)

        Button("Go"){
            withAnimation {
                presence.popup = AnyView(pop)
            }
            
        }
        List {
            ForEach(0..<100, id: \.self){_ in
                HStack {
                    Spacer()
                    Button("Some text"){
                        
                    }
                }
                .background(.red)
            }
        }
    }
    

    MockNavigation(viewToDisplay: AnyView(doDisp), presence: presence)
    
}
