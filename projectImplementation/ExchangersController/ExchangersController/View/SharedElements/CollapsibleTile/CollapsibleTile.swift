

import SwiftUI
import Observation

@Observable
class MiniCollapsibleState {
    var isDisclosed: Bool
    init(isDisclosed: Bool) {
        self.isDisclosed = isDisclosed
    }
}

struct CollapsibleTile: View {
    static var fontOfChevron = Font.title2
    
    var miniState: MiniCollapsibleState = MiniCollapsibleState(isDisclosed: true)
    
    var shouldGoRight:Bool = true
    
    var headerContent: AnyView
    var contentToExpand: AnyView
    
    var stickyContent: AnyView = AnyView(EmptyView())
    
    var topPadding: CGFloat = 10
    var leadingPadding: CGFloat = 10
    var trailingPadding: CGFloat = 10
    var bottomPadding: CGFloat = 10
    
    var colorOfHeader: Color = StyleElementsGetter.appStrongGray
    
    func toggleTile(){
        withAnimation(.smooth) {
            self.miniState.isDisclosed.toggle()
        }
    }
        
    var body: some View {
        let expansionButton = Button {
            toggleTile()
        } label: {
            Label("Graph", systemImage: "chevron.right")
                .font(CollapsibleTile.fontOfChevron)
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .rotationEffect(.degrees(!miniState.isDisclosed ? 90 : 0))
                .padding()
        }
        .foregroundColor(.primary)
        
        VStack {
            HStack{
                if !shouldGoRight {
                    expansionButton
                    Spacer()
                }
                headerContent
                if shouldGoRight {
                    Spacer()
                    expansionButton
                }
            }
            .padding(.top, self.topPadding)
            .padding(.leading, self.leadingPadding)
            .padding(.trailing, self.trailingPadding)
            .padding(.bottom, self.bottomPadding)
            .frame(maxWidth: .infinity)
            VStack(spacing: 0){
                if !miniState.isDisclosed {
                    contentToExpand
                        .transition(.opacity)
                }
                stickyContent
            }
        }
        .background(self.colorOfHeader)
        .cornerRadius(StyleElementsGetter.boldCorners)
    }
}

#Preview {
    let toExpand = HStack{
        Text("Expanded")
        Spacer()
    }
    .padding()
    .background(StyleElementsGetter.appBackLightGrey)
    
    let smallView = HStack(alignment: .center, spacing: 10) {
        Button(action: {}) {
            Image(systemName: "square.and.pencil")
                .font(.title)
                .foregroundColor(.primary)
        }
        Text("06:51")
            .font(Font.title2)
          .multilineTextAlignment(.center)
          .foregroundColor(.black)
          .frame(width: 110, height: 39, alignment: .center)
    }
    .padding(10)
    let cTile =
    CollapsibleTile(headerContent: AnyView(smallView),contentToExpand: AnyView(toExpand))
    cTile
    Button(action: {
        cTile.toggleTile()
    }) {
        Text("Outer")
    }
}
