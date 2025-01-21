

import SwiftUI

struct TileWrapperOfGlucoseLevels: View {
    @ObservedObject var insertionState: GlucoseAtDateState
    
    var body: some View {
        GlucoseLevelsCollapsibleList(
            state: self.insertionState)
    }
}
