

import Foundation

class EmailsProxy: ObservableObject {
    var dataModel: DataModel
    @Published var emails: [String]
    
    init(dataModel: DataModel) {
        self.dataModel = dataModel
        self.emails = dataModel.getCopyOfEmails()
    }
    
    func removeAtIndex(_ index: Int) {
        dataModel.removeEmailAt(index)
        self.emails = dataModel.getCopyOfEmails()
    }
    
    func addEmail(_ email: String) {
        self.dataModel.addEmail(email)
        self.emails = dataModel.getCopyOfEmails()
    }
}
