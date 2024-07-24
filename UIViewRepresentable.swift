//import SwiftUI
//class BackspaceDetectingTextField: UITextField {
//    var onBackspace: (() -> Void)?
//
//    override func deleteBackward() {
//        super.deleteBackward()
//        onBackspace?()
//    }
//}
//
//// UIViewRepresentable wrapper for the custom UITextField
//struct BackspaceTextField: UIViewRepresentable {
//    @Binding var text: String
//    var onBackspace: () -> Void
//
//    func makeUIView(context: Context) -> BackspaceDetectingTextField {
//        let textField = BackspaceDetectingTextField()
//        textField.delegate = context.coordinator
//        textField.onBackspace = onBackspace
//        textField.keyboardType = .numberPad
//        textField.textAlignment = .center
//        textField.font = UIFont.systemFont(ofSize: 24)
//        textField.layer.cornerRadius = 10
//        textField.layer.masksToBounds = true
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.lightGray.cgColor
//        return textField
//    }
//
//    func updateUIView(_ uiView: BackspaceDetectingTextField, context: Context) {
//        uiView.text = text
//        uiView.layer.borderColor = text.isEmpty ? UIColor.lightGray.cgColor : UIColor.orange.cgColor
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UITextFieldDelegate {
//        var parent: BackspaceTextField
//
//        init(_ parent: BackspaceTextField) {
//            self.parent = parent
//        }
//
//        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//            if let text = textField.text as NSString? {
//                parent.text = text.replacingCharacters(in: range, with: string)
//            }
//            return false
//        }
//    }
//}
//private extension UITextField {
//    func setLeftPaddingPoints(_ amount:CGFloat){
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
//        self.leftView = paddingView
//        self.leftViewMode = .always
//    }
//    func setRightPaddingPoints(_ amount:CGFloat) {
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
//        self.rightView = paddingView
//        self.rightViewMode = .always
//    }
//}
//
//struct BackspaceTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        BackspaceTextField(text: .constant(""), onBackspace: {})
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
