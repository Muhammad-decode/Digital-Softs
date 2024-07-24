import Foundation

struct LoginRequest: Codable {
    let email: String
    let languageID: Int

    enum CodingKeys: String, CodingKey {
        case email = "user_email"
        case languageID = "language_id"
    }
}

struct UserDataResponse: Codable {
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

enum APIError: Error {
    case networkError
    case decodingError
    case serverError(String)
}
class APIService {
    static let shared = APIService()

    func login(request: LoginRequest) async throws -> UserDataResponse {
        guard let url = URL(string: "https://master.erp.digitalm.cloud/index.php/user/getUserDataByEmail") else {
            throw APIError.serverError("Invalid URL.")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        


        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            throw APIError.networkError
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.serverError("Invalid response from server.")
        }

        do {
            let userDataResponse = try JSONDecoder().decode(UserDataResponse.self, from: data)
            if userDataResponse.status {
                print(userDataResponse.status)
                return userDataResponse
            } else {
                throw APIError.serverError(userDataResponse.error ?? "Login failed.")
            }
        } catch {
            throw APIError.decodingError
        }
    }
}
