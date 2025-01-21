

import SwiftUI

struct InputAttr: View {
    var complexLeftView: AnyView?
    var name: String
    var textFieldWidth: CGFloat
    var keyPad:UIKeyboardType
    var unit: String = ""
    var stackSpacing: CGFloat = 10
    
    @Binding var valueBuffer: String
    @State var clickValueBuffer: String
    
    // these flags allow buffers to change only once
    @State var clickFlag: Bool = false
    @State var valFlag: Bool = false
    
    init(name: String,
         textFieldWidth: CGFloat = .infinity,
         keyPad: UIKeyboardType = .numberPad,
         unit: String = "",
         stackSpacing: CGFloat = 10,
         valueBufferInitValue: String = "") {
        self.complexLeftView = nil
        
        self.name = name
        self.textFieldWidth = textFieldWidth
        self.keyPad = keyPad
        self.unit = unit
        self.stackSpacing = stackSpacing
        self._valueBuffer = .constant(valueBufferInitValue)
        
        self.clickValueBuffer = valueBufferInitValue
    }
    
    init(name: String,
         textFieldWidth: CGFloat = .infinity,
         keyPad: UIKeyboardType = .numberPad,
         unit: String = "",
         stackSpacing: CGFloat = 10,
         outerBuffer: Binding<String>) {
        self.complexLeftView = nil
        
        self.name = name
        self.textFieldWidth = textFieldWidth
        self.keyPad = keyPad
        self.unit = unit
        self.stackSpacing = stackSpacing
        self._valueBuffer = outerBuffer
        
        self.clickValueBuffer = outerBuffer.wrappedValue
    }
    
    init(complexLeftView: AnyView,
         textFieldWidth: CGFloat = .infinity,
         keyPad: UIKeyboardType = .numberPad,
         unit: String = "",
         stackSpacing: CGFloat = 10,
         valueBuffer: String = ""
    ) {
        self.complexLeftView = complexLeftView
        self.name = ""
        self.textFieldWidth = textFieldWidth
        self.keyPad = keyPad
        self.unit = unit
        self.stackSpacing = stackSpacing
        self._valueBuffer = .constant(valueBuffer)
        
        self.clickValueBuffer = valueBuffer
    }
    
    init(complexLeftView: AnyView,
         textFieldWidth: CGFloat = .infinity,
         keyPad: UIKeyboardType = .numberPad,
         unit: String = "",
         stackSpacing: CGFloat = 10,
         outerBuffer: Binding<String>
    ) {
        self.complexLeftView = complexLeftView
        self.name = ""
        self.textFieldWidth = textFieldWidth
        self.keyPad = keyPad
        self.unit = unit
        self.stackSpacing = stackSpacing
        self._valueBuffer = outerBuffer
        
        self.clickValueBuffer = outerBuffer.wrappedValue
    }
    
    func assignBuffer(_ value:String)->Void {
        self.valueBuffer = value
        self.clickValueBuffer = value
    }
    
    private func determineActualValue(_ new:String, _ old:String)->String {
        if (keyPad == .numberPad &&
            !new.allSatisfy({$0.isNumber})) ||
            new.count > 9 {
            old
        }
        else {
            new
        }
    }
    
    var body: some View {
        HStack(spacing: self.stackSpacing){
            if complexLeftView == nil {
                Text(self.name)
            }
            else {
                self.complexLeftView!
            }
            Spacer()
            TextField("", text: $clickValueBuffer)
                .keyboardType(keyPad)
                .onChange(of: clickValueBuffer) { old,new in
                    clickFlag = true
                    
                    if old == new {
                        return
                    }
                    
                    if !valFlag {
                        clickValueBuffer = determineActualValue(new, old)
                        valueBuffer = clickValueBuffer
                    }
                    else {
                        clickValueBuffer = new
                        valFlag = false
                        clickFlag = false
                    }
                    
                }
                .onChange(of: valueBuffer) { old, new in
                    valFlag = true
                    
                    if !clickFlag{
                        clickValueBuffer = valueBuffer
                    }
                    else {
                        clickFlag = false
                        valFlag = false
                    }
                }
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: self.textFieldWidth)
            Text(self.unit)
            
        }
        .frame(maxWidth: .infinity)
    }
}


class WrapObj: ObservableObject {
    @Published var aux: String = "10"
}

#Preview {
    @Previewable @ObservedObject var aux = WrapObj()
    
    let nutr: Nutritient = .carb
    let toInsert = HStack {
        Text(getNutriteintName(nutr))
            .padding(.leading, NameValuePair.leadingInset)
            .font(.body)
            .frame(maxWidth: .infinity, alignment: .leading)
        HStack {
            getImageForNutr(nutr)
                .font(.title3)
        }
    }
    
    InputAttr(complexLeftView: AnyView(toInsert),textFieldWidth: 250, unit: "g", outerBuffer: $aux.aux)
    Button("Click \(aux.aux)") {
        aux.aux += "9"
    }
    .onReceive(aux.objectWillChange, perform: {print(aux.aux)})
}
