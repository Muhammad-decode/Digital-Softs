import SwiftUI

struct OtpEntryView: View {
    @Binding var otpDigits: [String]
    @FocusState var focusedIndex: Int?

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<4, id: \.self) { index in
                BackspaceTextField(text: $otpDigits[index], onBackspace: {
                    handleBackspace(at: index)
                })
                .frame(width: 50, height: 50)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .focused($focusedIndex, equals: index)
                .onChange(of: otpDigits[index]) { newValue in
                    processInput(at: index, newValue: newValue)
                }
            }
        }
        .padding()
    }

    private func processInput(at index: Int, newValue: String) {
        let filtered = newValue.filter { "0123456789".contains($0) }
        if filtered.count > 1 {
            otpDigits[index] = String(filtered.last!)
        } else {
            otpDigits[index] = filtered
        }

        if newValue.count == 1 && index < otpDigits.count - 1 {
            focusedIndex = index + 1
        }
    }

    private func handleBackspace(at index: Int) {
        if otpDigits[index].isEmpty && index > 0 {
            focusedIndex = index - 1
        }
    }
}

struct BackspaceTextField: UIViewRepresentable {
    @Binding var text: String
    var onBackspace: () -> Void

    func makeUIView(context: Context) -> BackspaceDetectingTextField {
        let textField = BackspaceDetectingTextField()
        textField.delegate = context.coordinator
        textField.onBackspace = onBackspace
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        return textField
    }

    func updateUIView(_ uiView: BackspaceDetectingTextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: BackspaceTextField

        init(_ parent: BackspaceTextField) {
            self.parent = parent
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text as NSString? {
                parent.text = text.replacingCharacters(in: range, with: string)
            }
            return false
        }
    }
}

class BackspaceDetectingTextField: UITextField {
    var onBackspace: (() -> Void)?

    override func deleteBackward() {
        if text?.isEmpty == true {
            onBackspace?()
        }
        super.deleteBackward()
    }
}
//
//struct OtpEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        OtpEntryView()
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
