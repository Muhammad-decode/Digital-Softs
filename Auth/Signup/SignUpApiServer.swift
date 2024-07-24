//import Foundation
//
//class SignUpApiServer {
//    static let shared = SignUpApiServer()
//
//    func signup(request: SignupRequest, completion: @escaping (Result<SignupResponse, Error>) -> Void) {
//        guard let url = URL(string: "https://erp.digitalm.cloud/index.php/welcome/login?pkrs=ZXJwX2RpZ2l0YWxtX2Nsb3Vk") else {
//            completion(.failure(NetworkError.invalidURL))
//            return
//        }
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        do {
//            urlRequest.httpBody = try JSONEncoder().encode(request)
//        } catch {
//            completion(.failure(error))
//            return
//        }
//
//        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                if let data = data, let htmlString = String(data: data, encoding: .utf8) {
//                    print("Received HTML Response: \(htmlString)")
//                }
//                completion(.failure(NetworkError.invalidResponse))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NetworkError.invalidData))
//                return
//            }
//
//            // Log the raw response data
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Response JSON: \(jsonString)")
//            }
//
//            do {
//                let signupResponse = try JSONDecoder().decode(SignupResponse.self, from: data)
//                completion(.success(signupResponse))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//}
