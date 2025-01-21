

import SwiftUI

class MainState: ObservableObject {
    @Published var selectedItem: Int
    @Published var isSidebarVisible: Bool
    
    init(selectedItem: Int = 0, isSidebarVisible: Bool = false) {
        self.selectedItem = selectedItem
        self.isSidebarVisible = isSidebarVisible
    }
}
