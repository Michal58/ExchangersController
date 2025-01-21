

import SwiftUI

struct BrowserView: View {
    @ObservedObject var resultsBuffer: BrowsingBuffer
    @ObservedObject var focusWrapper: ObservableWrapper<FoodModel?>
    
    func togglePair(iconName: String, binding: Binding<Bool>) -> some View {
        HStack(alignment: .center){
            Image(systemName: iconName)
                .font(.title)
            Toggle("", isOn: binding)
                .labelsHidden()
        }
    }
    
    func tapOnChoice(_ selectedResult: FoodModel)->Void {
        resultsBuffer.searchTerm=""
        focusWrapper.wrapped = selectedResult
    }

    
    var body: some View {
        VStack{
            HStack{
                togglePair(iconName: "network", binding: $resultsBuffer.shouldSearchRemotely)
                togglePair(iconName: "house", binding: $resultsBuffer.shouldSearchLocally)
                togglePair(iconName: "fork.knife", binding: $resultsBuffer.shouldSearchComplex)
                Spacer()
            }
            List{
                ForEach(resultsBuffer.toShowResults, id:\.name){result in
                    HStack{
                        FoodNotation(foodModel: result)
                    }
                    .listRowBackground(StyleElementsGetter.appMediumGrey)
                    .onTapGesture {
                        withAnimation(.smooth){
                            tapOnChoice(result)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .searchable(text: $resultsBuffer.searchTerm)
            .onSubmit(of: .search){
                self.resultsBuffer.submitSearchTerm()
            }
            .frame(maxHeight: resultsBuffer.toShowResults.isEmpty ? 0 : .infinity)
            
            .cornerRadius(StyleElementsGetter.boldCorners)
        }
        .padding()
        .background(StyleElementsGetter.appBackLightGrey)
        .cornerRadius(StyleElementsGetter.boldCorners)
        
        if self.focusWrapper.wrapped != nil && resultsBuffer.toShowResults.isEmpty {
            ResultPresentation(
                actualResult: self.focusWrapper.wrapped!
            )
        }
    }
}

#Preview {
    let buffer=BrowsingBuffer(browser:nil)
    var browser=Browser(buffer: buffer, debugMode: true)
    let v: () = buffer.setBrowser(browser)
    
    let focusWrapper = ObservableWrapper<FoodModel?>(wrapped: nil)
    
    let viewToDisplay = BrowserView(resultsBuffer: buffer, focusWrapper: focusWrapper)
    let nav = MockNavigation(viewToDisplay: AnyView(viewToDisplay))
    nav
    
}
