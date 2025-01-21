

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var controllerResult: Result<MFMailComposeResult, Error>?
    
    var recipients: [String]
    var subject: String
    var message: String
    var images: [ImageData]
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(
            presentation: Binding<PresentationMode>,
            result: Binding<Result<MFMailComposeResult, Error>?>
        ) {
            _presentation = presentation
            _result = result
        }
        
        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(
            presentation: presentation,
            result: $controllerResult
        )
    }
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<MailView>
    ) -> MFMailComposeViewController {
        let mailComposition = MFMailComposeViewController()
        mailComposition.mailComposeDelegate = context.coordinator
        
        mailComposition.setToRecipients(self.recipients)
        mailComposition.setSubject(self.subject)
        mailComposition.setMessageBody(
            self.message,
            isHTML: true
        )
        
        for imageSample in self.images {
            mailComposition.addAttachmentData(
                imageSample.actualImage,
                mimeType: "image/png",
                fileName: imageSample.imageName
            )
        }
        
        return mailComposition
    }
    
    func updateUIViewController(
        _ uiViewController: MFMailComposeViewController,
        context: UIViewControllerRepresentableContext<MailView>
    ) {
    }
}

#Preview {
    @Previewable @State var result: Result<MFMailComposeResult, Error>? = nil
    if (MFMailComposeViewController.canSendMail()){
        MailView(
            controllerResult: $result,
            recipients: ["abc@abc"],
            subject: "Abc",
            message: "<p>abc</p>",
            images: []
        )
    }
}
