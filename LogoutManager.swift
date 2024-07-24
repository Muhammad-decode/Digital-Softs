import Foundation
import SwiftUI

class LogoutManager: ObservableObject {
    static let shared = LogoutManager()

    @Published var isLoggedIn: Bool = true

    func logout() {
        isLoggedIn = false
        // Add any other logout logic here (e.g., clearing tokens, user data)
    }
}
