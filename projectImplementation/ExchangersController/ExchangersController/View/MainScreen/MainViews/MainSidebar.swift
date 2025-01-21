

import SwiftUI

struct MainSidebar: View {
    var conroller: AppController
    var currentGeometry: GeometryProxy
    @Binding var isSidebarVisible: Bool
    var title: String = "Options"
    var spacing:CGFloat = 10
    var optionsSpacing:CGFloat = 15
    
    var body: some View {
        ZStack{
            if isSidebarVisible {
                HStack {
                    VStack(spacing: self.spacing) {
                        ZStack{
                            HStack(alignment: .top) {
                                Button(action: {
                                    isSidebarVisible=false
                                }) {
                                    Image(systemName: "sidebar.left")
                                        .font(.title2)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            HStack(alignment: .top) {
                                StandardContainer<AnyView, AnyView, AnyView>.makeHeaderTitle(self.title)
                            }
                        }
                        VStack(spacing: self.optionsSpacing) {
                            AppButton(action: {
                                isSidebarVisible = false
                                self.conroller.goFromMainToDatabaseEdition()
                            },text: "Local database", extraElement: AnyView(Image("DatabaseImg").font(AppButton.fontType)), shouldBeSquezzed: false)
                            AppButton(action: {
                                isSidebarVisible = false
                                self.conroller.goFromMainToSearch()
                            },text: "Products search", extraElement: AnyView(Image("SearchImg").font(AppButton.fontType)), shouldBeSquezzed: false)
                            AppButton(action: {
                                isSidebarVisible = false
                                self.conroller.goFromMainToGlucoseLevelsInsertion()
                            },text: "Add glucose levels", extraElement: AnyView(Image("DropImg").font(AppButton.fontType)), shouldBeSquezzed: false)
                            AppButton(action: {
                                isSidebarVisible = false
                                self.conroller.goFromMainToCharts()
                            },text: "Charts", extraElement: AnyView(Image("ChartImg").font(AppButton.fontType)), shouldBeSquezzed: false)
                            AppButton(action: {
                                isSidebarVisible = false
                                self.conroller.goFromMainToReports()
                            },text: "Reports", extraElement: AnyView(Image("FileImg").font(AppButton.fontType)), shouldBeSquezzed: false)
                            
                            Spacer()
                        }
                        .padding(self.optionsSpacing)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.background.secondary)
                        .cornerRadius(StyleElementsGetter.normalCorners)
                    }
                    .frame(width: currentGeometry.size.width*0.75)
                    .padding()
                    .background(.white)
                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: isSidebarVisible)
        .background(
            Color.black
            .opacity(0.5))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
