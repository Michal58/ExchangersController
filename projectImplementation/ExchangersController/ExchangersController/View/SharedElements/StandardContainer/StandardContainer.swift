

import SwiftUI

struct StandardContainer<Top: View, Bottom: View, Content: View>: View {
    
    static func makeHeaderTitle(_ title: String) -> Text {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
    }
    
    var stickyTop: Top
    var stickyBottom: Bottom
    var content: Content
    
    var leftElement: AnyView? = nil
    var rightElement: AnyView? = nil
    
    var title: String
    var shouldBeBackHidden: Bool = false
    
    init(
            leftElement: AnyView? = nil,
            rightElement: AnyView? = nil,
            title: String,
            shouldBeBackHidden: Bool = false,
            @ViewBuilder top: @escaping () -> Top = { EmptyView() },  // Default closure
            @ViewBuilder bottom: @escaping () -> Bottom = { EmptyView() },  // Default closure
            @ViewBuilder content: @escaping () -> Content
        ) {
            self.leftElement = leftElement
            self.rightElement = rightElement
            self.title = title
            self.shouldBeBackHidden = shouldBeBackHidden
            self.stickyTop = top()
            self.stickyBottom = bottom()
            self.content = content()
        }
    
    var body: some View {
        VStack {
            self.stickyTop
            ScrollView {
                VStack{
                    self.content
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            self.stickyBottom
        }
        .padding(.bottom)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(shouldBeBackHidden)
        .toolbar {
            if let realLeftElement=leftElement {
                ToolbarItem(placement: .navigationBarLeading) {
                    realLeftElement
                }
            }
            
            ToolbarItem(placement: .principal) {
                HStack {
                    StandardContainer.makeHeaderTitle(self.title)
                }
            }
            
            if let realRightElement=rightElement {
                ToolbarItem(placement: .navigationBarTrailing) {
                    realRightElement
                }
            }
        }
    }
}

#Preview {
    let leftButton = Button(action: {
        print("Button tapped!")
    }) {
        Image(systemName: "sidebar.left") // Left side button with an icon
    }
    
    let bodyView = ForEach(1..<10){ i in
        Tile()
    }
    
    let rightButton = Button(action: {
                print("Right button tapped!")
            }) {
                Image(systemName: "sidebar.right")
            }
    
    let stickyTop = EmptyView()
    let stickyBottom = EmptyView()
    
    StandardContainer(
                leftElement: AnyView(leftButton),
                title: "Some Title",
                top: { stickyTop },  // Pass stickyTop as a closure
                bottom: { stickyBottom }  // Pass stickyBottom as a closure
    ){
        bodyView
    }
    .background(.gray)
}
