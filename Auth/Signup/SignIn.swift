import SwiftUI
import UIKit

struct defaultsKeys {
    static let beforeSessionUserId = "beforeSessionUserId"
    static let beforeSessionUserName = "beforeSessionUserName"
}

struct SignIn: View {
    @State private var password: String = ""
    @State private var selectedFinancialYear: FinancialYear? // Selected financial year
    @State private var isLoginSuccessful: Bool = false
    @State private var isLoading: Bool = false
    @State private var settings: [Setting] = []
    @State private var financialYears: [FinancialYear] = []
    @State private var navigateToOTPScreen: (Bool, String, String) = (false, "", "")
    @FocusState private var focusedField: Field?
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    @State private var progressBarVisible: Bool = false
    @State private var showOTP: Bool = false
    @State private var userId: String = ""
    @State private var username: String = ""
       @State private var isLoggedIn: Bool = false

    enum Field: Hashable {
        case username, password
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    Image("logo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding(.top, 20)
                    
                    Text("DIGITALMANAGER")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, -5)
                    
                    Text("BUSINESS MANAGEMENT SOFTWARE")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    VStack(spacing: 13) {
                        Picker(selection: $selectedFinancialYear, label: Text("")) {
                            ForEach(financialYears, id: \.fn_id) { year in
                                Text(year.fname)
                                    .foregroundColor(.black)
                                    .tag(year as FinancialYear?)
                            }
                        }
                        .padding()
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 310, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        .padding(.horizontal)
                        
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            .padding(.horizontal)
                            .frame(width: 340, height: 50)
                            .autocapitalization(.none)
                            .focused($focusedField, equals: .username)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            .padding(.horizontal)
                            .frame(width: 340, height: 50)
                            .focused($focusedField, equals: .password)
                    }
                    .padding([.horizontal, .top], 20)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                focusedField = nil
                            }
                        }
                    }
                    .padding(.bottom, 20)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                    .padding(.horizontal, 10)
                    .padding(.top, 30)
                    
                    Button(action: {
                        self.isLoading = true
                        self.signIn()
                    }) {
                        Text("Sign In")
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
                    }
                    .frame(width: 300, height: 80)
                    .disabled(isLoading)

                    NavigationLink(
                        destination: OtpView(username: username)
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true),
                        isActive: $navigateToOTPScreen.0
                    ) {
                        EmptyView()
                    }
                    .hidden()

                    Spacer()
                    Text("DIGITALSOFTS | DIGITAL MANAGER")
                        .fontWeight(.thin)
                        .foregroundColor(.gray)
                        .padding(.bottom, 70)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: EmptyView(), trailing: EmptyView())
                .navigationBarTitleDisplayMode(.inline)
                .overlay(
                    ZStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                                .scaleEffect(3)
                                .frame(width: 300, height: 300)
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                )
            }
            .padding(.bottom, keyboardResponder.currentHeight)
            .edgesIgnoringSafeArea(keyboardResponder.currentHeight > 0 ? .bottom : [])
            .onAppear {
                fetchSettings()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func fetchSettings() {
        guard let url = URL(string: "https://testerp.digitalm.cloud/index.php/welcome/fetchsettings?pkrs=ZXJwX2RpZ2l0YWxtX2Nsb3Vk") else {
            print("Invalid URL")
            showAlert(type: .danger, message: "Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error)")
                    showAlert(type: .danger, message: "Network error")
                } else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        settings = try decoder.decode([Setting].self, from: data)
                        fetchFinancialYears()
                    } catch {
                        print("Error decoding JSON: \(error)")
                        showAlert(type: .danger, message: "Error decoding settings")
                    }
                }
            }
        }
        task.resume()
    }

    func fetchFinancialYears() {
        guard let url = URL(string: "https://erp.digitalm.cloud/index.php/welcome/fetchallfinancialyears?pkrs=ZXJwX2RpZ2l0YWxtX2Nsb3Vk") else {
            print("Invalid URL")
            showAlert(type: .danger, message: "Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error)")
                    showAlert(type: .danger, message: "Network error")
                } else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        financialYears = try decoder.decode([FinancialYear].self, from: data)
                        // Optionally, you can set the financialYear to the first item or let the user choose
                        if let firstYear = financialYears.first {
                            selectedFinancialYear = firstYear
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                        showAlert(type: .danger, message: "Error decoding financial years")
                    }
                }
            }
        }
        task.resume()
    }

    func signIn() {
        let cookieStorage = HTTPCookieStorage.shared
        cookieStorage.cookieAcceptPolicy = .always
        let uname = self.username.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = self.password.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let fn_dropdown = self.selectedFinancialYear?.fname else {
            showAlert(type: .danger, message: "Please select a financial year")
            self.isLoading = false
            return
        }

        if uname.isEmpty || pass.isEmpty || fn_dropdown.isEmpty {
            showAlert(type: .danger, message: "Invalid credentials")
            self.isLoading = false
            return
        }

        guard let url = URL(string: "https://testerp.digitalm.cloud/index.php/welcome/login?pkrs=ZXJwX2RpZ2l0YWxtX2Nsb3Vk") else {
            print("Invalid URL")
            showAlert(type: .danger, message: "Invalid URL")
            self.isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: String] = [
            "uname": uname,
            "pass": pass,
            "fn_dropdown": fn_dropdown
        ]

        request.httpBody = parameters.percentEncoded()

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    print("Error: \(error)")
                    self.showAlert(type: .danger, message: "Network error")
                } else if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                        self.parseResponse(responseString)

                        if let cookies = HTTPCookieStorage.shared.cookies {
                            for cookie in cookies {
                                let name = cookie.name
                                let value = cookie.value
                                print("Cookie Name:\(name), Value: \(value)")
                                UserDefaults.standard.set(value, forKey: name)
                            }
                        }
                    } else {
                        print("Unable to convert data to UTF-8 string.")
                    }
                }
            }
        }
        task.resume()
    }

    func parseResponse(_ responseString: String?) {
        guard let responseString = responseString else {
            showAlert(type: .danger, message: "Invalid response from server")
            return
        }

        do {
            let jsonData = Data(responseString.utf8)

            let decoder = JSONDecoder()
            let responseModel = try decoder.decode(ApiResponse.self, from: jsonData)

            if responseModel.status {
                showAlert(type: .success, message: responseModel.message)
                let defaults = UserDefaults.standard
                defaults.set(responseModel.data?.uid, forKey: defaultsKeys.beforeSessionUserId)
                defaults.set(responseModel.data?.uname, forKey: defaultsKeys.beforeSessionUserName)
                self.userId = responseModel.data?.uid ?? ""
                self.username = responseModel.data?.uname ?? ""
                navigateToOTPScreen = (true, userId, username)
                showOTP = true
            } else {
                showAlert(type: .danger, message: responseModel.message)
                print("Login failed")
            }
        } catch {
            print("Error decoding JSON: \(error)")
            showAlert(type: .danger, message: "Error decoding response")
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

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}

extension Dictionary where Key == String, Value == String {
    func percentEncoded() -> Data? {
        let queryItems = self.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        var components = URLComponents()
        components.queryItems = queryItems
        return components.percentEncodedQuery?.data(using: .utf8)
    }
}

struct ToastView: View {
    var message: String

    var body: some View {
        VStack {
            Text(message)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(15)
        }
    }
}

struct ActivityIndicator: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(1.5, anchor: .center)
            .padding(.leading, 10)
    }
}
