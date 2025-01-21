

import SwiftUI
import MessageUI

struct ReportUpload: View {
    var controller: AppController
    @ObservedObject var proxy: EmailsProxy
    var emailBuffer: ObservableWrapper<String>
    
    var presence: PopupPresenceObserver
    var rangeManipulationElement: RangeManipultaion
    
    var manipulationStartDate: ObservableWrapper<Date>
    var manipulationEndDate: ObservableWrapper<Date>
    
    
    struct RangeManipultaion: View {
        @ObservedObject var startDate: ObservableWrapper<Date>
        @ObservedObject var endDate: ObservableWrapper<Date>
        
        var body: some View {
            DatePicker("Start date", selection: $startDate.wrapped, displayedComponents: .date)
                .datePickerStyle(.compact)
            DatePicker("End date", selection: $endDate.wrapped, displayedComponents: .date)
                .datePickerStyle(.compact)
        }
    }
    
    init(controller: AppController, presence: PopupPresenceObserver){
        self.controller = controller
        self.presence = presence
        
        self.manipulationStartDate = ObservableWrapper(
            wrapped: Date()
        )
        self.manipulationEndDate = ObservableWrapper(
            wrapped: Date()
        )
        
        self.emailBuffer = ObservableWrapper(wrapped: "")
        self.rangeManipulationElement = RangeManipultaion(
            startDate: self.manipulationStartDate,
            endDate: self.manipulationEndDate
        )
        
        self.proxy = EmailsProxy(dataModel: controller.getModel())
    }

    
    static func getEmailPopupClosure(
        navigationPopupPresence: PopupPresenceObserver,
        bufferWrapper: ObservableWrapper<String>,
        proxy: EmailsProxy)->(()->Void){
        {
            bufferWrapper.wrapped = ""
            let emailBody = EmailAddPopupBody(
                emailBuffer: bufferWrapper
            )
            withAnimation(.easeInOut){
                navigationPopupPresence.popup = AnyView(
                    Popup(title: "Indicate email",
                          popupBody: AnyView(emailBody),
                          okClosure: {
                              withAnimation(.easeInOut){
                                  withAnimation(.smooth){
                                      proxy.addEmail(bufferWrapper.wrapped)
                                  }
                                  navigationPopupPresence.popup=nil
                              }
                          },
                          cancelClosure: {
                              withAnimation(.easeInOut){
                                  navigationPopupPresence.popup=nil
                              }
                          }))
            }
        }
    }
    
    struct ReportsStickyBottom: View {
        var dateModel: DataModel
        
        @ObservedObject var startDate: ObservableWrapper<Date>
        @ObservedObject var endDate: ObservableWrapper<Date>
        
        @State var wasReportSent: Bool = false
        @State var isAlertPresented: Bool = false
        
        @State var result: Result<MFMailComposeResult, Error>? = nil
        @State var isShowingMailView = false
        
        func getAlertTitle()->String{
            if self.wasReportSent {
                "Report sent"
            }
            else {
                "Failure"
            }
        }
        
        func getAlertMessage()->String {
            if self.wasReportSent{
                "Your glucose levels repotr was prepared and sent to indicated emails."
            }
            else {
                "Report couldn't be sent"
            }
        }
        
        var body: some View {
            HStack{
                let isButtonDisabled = normallizeDateToYMMD(self.endDate.wrapped) < normallizeDateToYMMD(self.startDate.wrapped) ||
                !MFMailComposeViewController.canSendMail()
                
                AppButton(
                    action: {
                        self.isShowingMailView.toggle()
                    },
                    extraElement: AnyView(
                        getSendReportComposition()
                    ),
                    disableIndicator: isButtonDisabled
                )
                .disabled(isButtonDisabled)
                .sheet(isPresented: $isShowingMailView) {
                    let (messageData, imagesData) = self.dateModel.prepareTextAndImagesForMail(
                        self.startDate.wrapped,
                        self.endDate.wrapped
                    )
                    MailView(
                        controllerResult: self.$result,
                        recipients: self.dateModel.getCopyOfEmails(),
                        subject: "Glucose report",
                        message: messageData,
                        images: imagesData
                    )
                }
            }
        }
    }
    
    var body: some View {
        StandardContainer(
            leftElement: AnyView(
                getGoBackButton(
                    closure: {
                        self.controller.goFromChartToMain()
                    }
                )
            ),
            title: "Reports",
            shouldBeBackHidden: true,
            bottom: {
                ReportsStickyBottom(
                    dateModel: self.proxy.dataModel,
                    startDate: self.rangeManipulationElement.startDate,
                    endDate: self.rangeManipulationElement.endDate)
                    .padding(.horizontal)
            }){
                VStack{
                    HStack {
                        Text("Indicated email addreses")
                        Spacer()
                    }
                    .font(.title3)
                    ForEach(proxy.emails.indices, id: \.self) {index in
                        let email = proxy.emails[index]
                        HStack {
                            ScrollView(.horizontal) {
                                Text(email)
                            }
                            Spacer()
                            Button(action: {
                                withAnimation(.smooth){
                                    proxy.removeAtIndex(index)
                                }
                            }) {
                                    Image(systemName: "xmark")
                                    .foregroundColor(.red)
                                }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(StyleElementsGetter.appStrongGray)
                        .cornerRadius(StyleElementsGetter.boldCorners)
                        .font(.title3)
                    }
                }
                .padding()
                .background(StyleElementsGetter.appBackLightGrey)
                .cornerRadius(StyleElementsGetter.boldCorners)
                .padding()
                HStack {
                    AppButton(action: ReportUpload.getEmailPopupClosure(navigationPopupPresence: self.presence, bufferWrapper: self.emailBuffer, proxy: self.proxy)
                    , extraElement: AnyView(getAddEmailComposition()))
                }
                .padding(.horizontal)
                self.rangeManipulationElement
                    .padding(.horizontal)
            }
    }
}

#Preview {
    var presence = PopupPresenceObserver()
    let controller = AppController()
    
    let viewToDisplay = ReportUpload(
        controller: controller, presence: presence
    )
    let nav = MockNavigation(viewToDisplay: AnyView(viewToDisplay), presence: presence)
    nav
}
