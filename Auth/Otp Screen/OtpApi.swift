//import Foundation
//
//class OtpApi {
//    static let shared = OtpApi()
//    
//    private init() {}
//
//    func verifyOtp(otp: String, completion: @escaping (Result<ResponseModel, Error>) -> Void) {
//        guard let url = URL(string: "https://testerp.digitalm.cloud/index.php/welcome/fetchverificationemail?pkrs=ZXJwX2RpZ2l0YWxtX2Nsb3Vk") else {
//            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
//            return
//        }
//
//        let boundary = UUID().uuidString
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("multipart/form-data,JSON; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        let parameters: [String: String] = [
//            "code": otp,
//            "user_agent": "ios",
//            "device_token": "sd",
//            "before_session_userid": UserDefaults.standard.string(forKey: defaultsKeys.beforeSessionUserId) ?? "",
//            "before_session_username": UserDefaults.standard.string(forKey: defaultsKeys.beforeSessionUserName) ?? ""
//        ]
//
//        request.httpBody = createMultipartBody(with: parameters, boundary: boundary)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "No data", code: 400, userInfo: nil)))
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let responseModel = try decoder.decode(ResponseModel.self, from: data)
//                completion(.success(responseModel))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//
//    private func createMultipartBody(with parameters: [String: String], boundary: String) -> Data {
//        var body = Data()
//
//        for (key, value) in parameters {
//            body.append("--\(boundary)\r\n")
//            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//            body.append("\(value)\r\n")
//        }
//
//        body.append("--\(boundary)--\r\n")
//        return body
//    }
//}
