

import SwiftUI

struct NavBody: View {
    @ObservedObject var presence: PopupPresenceObserver
    var body: some View {
        if presence.popup != nil {
            presence.popup!
        } else {
            EmptyView()
        }
    }
}
