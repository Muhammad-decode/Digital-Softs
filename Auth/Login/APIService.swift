//import Foundation
//
//struct ResponseModel: Codable {
//    let status: Bool
//    let message: String
//    let data: UserData?
//    let error: String?
//}
//
//struct UserData: Codable {
//    let dbname: String
//    let setupfordomain: SetupForDomain?
//}
//
//struct SetupForDomain: Codable {
//    let id: String
//    let redirect: String
//    let db_name: String
//}
//
//struct LoginRequest: Codable {
//    let email: String
//    let languageID: Int
//
//    enum CodingKeys: String, CodingKey {
//        case email = "user_email"
//        case languageID = "language_id"
//    }
//}
//
//enum APIError: Error, LocalizedError {
//    case networkError
//    case decodingError
//    case serverError(String)
//    
//    var errorDescription: String? {
//        switch self {
//        case .networkError:
//            return "Network error occurred."
//        case .decodingError:
//            return "Failed to decode the response."
//        case .serverError(let message):
//            return message
//        }
//    }
//}
//
//class APIService {
//    static let shared = APIService()
//
//    func login(request: LoginRequest) async throws -> ResponseModel {
//        guard let url = URL(string: "https://master.erp.digitalm.cloud/index.php/user/getUserDataByEmail") else {
//            throw APIError.serverError("Invalid URL.")
//        }
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        do {
//            urlRequest.httpBody = try JSONEncoder().encode(request)
//        } catch {
//            throw APIError.networkError
//        }
//
//        let (data, response) = try await URLSession.shared.data(for: urlRequest)
//
//        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//            throw APIError.serverError("Invalid response from server.")
//        }
//
//        do {
//            let responseModel = try JSONDecoder().decode(ResponseModel.self, from: data)
//            if responseModel.status {
//                return responseModel
//            } else {
//                throw APIError.serverError(responseModel.error ?? "Login failed.")
//            }
//        } catch {
//            throw APIError.decodingError
//        }
//    }
//}
//
