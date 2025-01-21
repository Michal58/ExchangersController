

import SwiftUI

struct ContentView: View {
    var controller: AppController
    
    var body: some View {
        MainScreen(controller: self.controller)
    }
}

#Preview {
    let controller = AppController()
    ContentView(controller: controller)
}
