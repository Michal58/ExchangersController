import SwiftUI


class PopupPresenceObserver: ObservableObject {
    @Published var popup: AnyView?
    
    init(popup: AnyView? = nil) {
        self.popup = popup
    }
}

struct MockNavigation: View {
    @State private var navigationPath = NavigationPath()  // Navigation state
    private var presence: PopupPresenceObserver
    
    var viewToDisplay: AnyView
    
    init(viewToDisplay: AnyView, presence: PopupPresenceObserver = PopupPresenceObserver()) {
        self.viewToDisplay = viewToDisplay
        self.presence = presence
        _navigationPath = State(initialValue: NavigationPath([0]))
    }
    
    func mockFunction()->EmptyView{
        print(presence.popup == nil)
        return EmptyView()
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                Text("This is the Main Screen")
                    .font(.title)
                    .padding()
                Button(action: {
                    navigationPath.append(0)
                }, label: {
                    Text("Go to Detail Screen")
                })
            }
            .navigationTitle("Main Screen")
            .navigationDestination(for: Int.self) { _ in
                viewToDisplay
            }
        }
        .overlay(content: {NavBody(presence: self.presence)})
    }
}
