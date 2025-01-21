

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

@main
struct ExchangersControllerApp: App {
    var controller: AppController = AppController()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView(controller: self.controller)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .background:
                PersistenceManager.shared.saveState(self.controller.getModel())
            default:
                break
            }
        }
    }
}
