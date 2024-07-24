import SwiftUI
import UIKit

struct Masterlogin: View {
    @State private var email: String = ""
    @State private var isLoading: Bool = false
    @State private var isLoginSuccessful: Bool = false
    @FocusState private var focusedField: FocusableField?
    
    enum FocusableField: Hashable {
        case email
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    Image("logo").resizable().frame(width: 100, height: 100).padding(.top, 20)
                    Text("DIGITALMANAGER").font(.title).fontWeight(.bold).padding(.top, 1)
                    Text("BUSINESS MANAGEMENT SOFTWARE").font(.subheadline).foregroundColor(.gray)
                    Text("Login page").font(.title).foregroundColor(.gray).padding()

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Please Enter the Registered Email")
                            .foregroundColor(.gray)
                            .font(.system(size: 15, weight: .light))
                        VStack {
                            TextField("Enter Registered Email", text: $email)
                                .padding()
                                .frame(width: 310, height: 50)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                .keyboardType(.emailAddress)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 1))
                                .focused($focusedField, equals: .email)
                                .autocapitalization(.none)
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    focusedField = nil  // Clear the focused field when "Done" is tapped
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    if isLoading {
                        ProgressView()
                    } else {
                        Button("Login") {
                            login()
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
                        .frame(width: 300, height: 80)
                        .padding(.bottom, 20)
                    }
                    Spacer()

                    NavigationLink("", destination: SignIn(), isActive: $isLoginSuccessful)
                        .hidden()
                }
               Spacer()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationViewStyle(StackNavigationViewStyle()) // Use this for single view navigation
        }
    }
    
    struct ResponseModel: Codable {
        let status: Bool
        let message: String
        let data: UserData?
        let error: String?
    }

    struct UserData: Codable {
        let dbname: String
        let setupfordomain: SetupForDomain?
    }

    struct SetupForDomain: Codable {
        let id: String
        let redirect: String
        let db_name: String
    }

    func login() {
        guard !email.isEmpty else {
            showAlert(type: .danger, message: "Please check your email.")
            return
        }

        isLoading = true

        guard let url = URL(string: "https://master.erp.digitalm.cloud/index.php/user/getUserDataByEmail") else {
            showAlert(type: .danger, message: "Invalid URL.")
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: String] = ["user_email": email, "financialYear": "7", "user_agent": "ios"]
        request.httpBody = parameters.percentEncoded()

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                    showAlert(type: .danger, message: "Failed to decode response or no data.")
                    return
                }

                parseResponse(responseString)
            }
        }.resume()
    }

    private func parseResponse(_ responseString: String) {
        let decoder = JSONDecoder()
        if let jsonData = responseString.data(using: .utf8) {
            do {
                let response = try decoder.decode(ResponseModel.self, from: jsonData)
                if response.status {
                    isLoginSuccessful = true
                    showAlert(type: .success, message: response.message)
                } else {
                    showAlert(type: .danger, message: "Please check your email.")
                }
            } catch {
                showAlert(type: .danger, message: "Error decoding JSON: \(error.localizedDescription)")
            }
        } else {
            showAlert(type: .danger, message: "Error converting response string to Data.")
        }
    }

    private func showAlert(type: AlertComponent.AlertType, message: String) {
        let alertOptions = AlertComponent.AlertOptions(
            title: type.rawValue.capitalized,
            message: message,
            type: type
        )
        AlertComponent.showAlert(options: alertOptions)
    }
}

struct Masterlogin_Previews: PreviewProvider {
    static var previews: some View {
        Masterlogin()
    }
}
