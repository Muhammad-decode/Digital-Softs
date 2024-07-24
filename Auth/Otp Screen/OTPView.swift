import SwiftUI

struct OtpView: View {
    var username: String

    @State private var progressBarVisible: Bool = false
    @State private var resultMessage: String = ""
    @State private var showMainPage: Bool = false
    @State private var remainingTime = 120
    @State private var otpDigits = Array(repeating: "", count: 4)
    @FocusState private var focusedIndex: Int?

    var body: some View {
        VStack {
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.top, 80)
                Text("DIGITALMANAGER")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 5)
                Text("BUSINESS MANAGEMENT SOFTWARE")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top, -50)

            OtpEntryView(otpDigits: $otpDigits, focusedIndex: _focusedIndex)
                .padding()

            Text("Time remaining: \(formattedTime)")
                .font(.headline)
                .foregroundColor(.red)

            if progressBarVisible {
                ProgressView()
            }

            Button("Verify OTP") {
                verifyOTP()
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange.opacity(0.8), Color.orange.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(10)
            .shadow(color: Color.orange.opacity(0.4), radius: 10, x: 0, y: 5)
            .padding()

            NavigationLink(
                destination: MainView(username: username)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true),
                isActive: $showMainPage)
            {
                EmptyView()
            }
        }
        .padding()
        .navigationTitle("OTP Verification")
        .onAppear {
            startTimer()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusedIndex = 0
            }
        }
        .onTapGesture {
            dismissKeyboard()
        }
    }

    private func verifyOTP() {
        progressBarVisible = true
        let enteredOTP = otpDigits.joined()

        guard let url = URL(string: "https://testerp.digitalm.cloud/index.php/welcome/fetchverificationemail?pkrs=ZXJwX2RpZ2l0YWxtX2Nsb3Vk") else {
            print("Invalid URL")
            resultMessage = "Invalid URL"
            progressBarVisible = false
            return
        }

        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data,JSON; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let parameters: [String: String] = [
            "code": enteredOTP,
            "user_agent": "ios",
            "device_token": "sd",
            "before_session_userid": UserDefaults.standard.string(forKey: defaultsKeys.beforeSessionUserId) ?? "",
            "before_session_username": UserDefaults.standard.string(forKey: defaultsKeys.beforeSessionUserName) ?? ""
        ]

        request.httpBody = createMultipartBody(with: parameters, boundary: boundary)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.progressBarVisible = false

                if let error = error {
                    self.resultMessage = "Error: \(error.localizedDescription)"
                    print("Error: \(error.localizedDescription)")
                } else if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                        self.parseResponse(responseString)
                    } else {
                        print("Unable to convert data to UTF-8 string.")
                        self.resultMessage = "Unable to convert data to UTF-8 string."
                    }
                }
            }
        }.resume()
    }

    private func createMultipartBody(with parameters: [String: String], boundary: String) -> Data {
        var body = Data()

        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        body.append("--\(boundary)--\r\n")
        return body
    }

    private func parseResponse(_ responseString: String?) {
        guard let responseString = responseString else {
            return
        }

        do {
            let jsonData = Data(responseString.utf8)

            let decoder = JSONDecoder()
            let responseModel = try decoder.decode(ResponseModel.self, from: jsonData)

            if responseModel.status {
                print("Yes")
                self.resultMessage = responseModel.message ?? "Verification successful"
                self.showMainPage = true
            } else {
                print("No")
                self.resultMessage = responseModel.message ?? "Verification failed"
                // Log detailed response for debugging
                print("ResponseModel: \(responseModel)")
            }
        } catch {
            print("Error decoding JSON: \(error)")
            self.resultMessage = "Error decoding JSON: \(error)"
        }
    }

    struct ResponseModel: Codable {
        let status: Bool
        let statusCode: Int?
        let message: String?
        let level: String?
        let data: ApiData?
    }

    struct ApiData: Codable {
        let status: Bool
        let data: UserData?
    }

    struct UserData: Codable {
        let company_id: String?
        let company_mail: String?
        let company_name: String?
        let headoffice: String?
        let tax: String?
        let contact: String?
        let address: String?
        let hr: String?
        let powerdby: String?
        let barcode_print: String?
        let foot_node: String?
        let uid: String?
        let uname: String?
        let header_img: String?
        let pass: String?
        let email: String?
        let user_type: String?
        let failedattempts: String?
        let rgid: String?
        let fullname: String?
        let mobile: String?
        let mob_code: String?
        let desc: String?
        let otp_expire_time: String?
        let token: String?
        let fn_id: String?
        let fstartdate: String?
        let fenddate: String?
        let otp: String?
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                timer.invalidate()
            }
        }
    }

    private var formattedTime: String {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func showAlert(type: AlertComponent.AlertType, message: String) {
        let alertOptions = AlertComponent.AlertOptions(
            title: type.rawValue.capitalized,
            message: message,
            type: type
        )
        AlertComponent.showAlert(options: alertOptions)
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

struct OtpView_Previews: PreviewProvider {
    static var previews: some View {
        OtpView(username: "")
    }
}
