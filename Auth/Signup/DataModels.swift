import Foundation

struct Setting: Codable, Identifiable {
    let id: String
    let cash: String
    // Add other properties as needed
}

struct FinancialYear: Codable, Identifiable, Hashable {
    var id: String { fn_id }
    let fn_id: String
    let fname: String
    let start_date: String
    let end_date: String
    let remarks: String
    let company_id: String
}

struct ApiResponse: Codable {
    let status: Bool
    let message: String
    let data: UserInformation?
    let error: String?
}

struct UserInformation: Codable {
    let uid: String // Change to String to match the API response
    let uname: String
    let otp: String? // Add the otp field
}
