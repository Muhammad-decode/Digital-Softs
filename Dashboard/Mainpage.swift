import SwiftUI
import Combine

struct Post: Identifiable, Codable {
    let id = UUID()
    let mainnav_id: String
    let vr_title: String
    let vr_type: String
    
    enum CodingKeys: String, CodingKey {
        case mainnav_id
        case vr_title
        case vr_type
    }
}

struct APIResponse: Codable {
    let status: Bool
    let message: String
    let data: [Post]
}

class ItemListViewModel: ObservableObject {
    @Published var items: [Post] = []
    private var cancellable: AnyCancellable?
    
    func fetchItems(for type: String) {
        let urlString = "https://testerp.digitalm.cloud/api/your-endpoint" // Replace with the actual API endpoint
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer your_api_token", forHTTPHeaderField: "Authorization") // Add headers if required
        
        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                if let httpResponse = output.response as? HTTPURLResponse {
                    print("Status Code: \(httpResponse.statusCode)")
                    print("Headers: \(httpResponse.allHeaderFields)")
                }
                guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .handleEvents(receiveOutput: { data in
                print("Raw data: \(String(data: data, encoding: .utf8) ?? "N/A")")
            })
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .map { response in
                response.data.filter { $0.vr_type == type }
            }
            .catch { error -> Just<[Post]> in
                print("Error fetching data: \(error)")
                return Just([])
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.items, on: self)
    }
}

struct ItemListView: View {
    var type: String
    @StateObject private var viewModel = ItemListViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Items for \(type.capitalized)")
                .font(.headline)
                .padding()
            
            List(viewModel.items) { item in
                Text(item.vr_title)
            }
            .listStyle(PlainListStyle())
            .onAppear {
                viewModel.fetchItems(for: type)
            }
        }
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct MainView: View {
    var username: String
    
    @State private var selectedTab: Tab? = nil
    
    enum Tab {
        case reports
        case vouchers
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HeaderView(username: username)
                TabsView(selectedTab: $selectedTab)
                
                if let selectedTab = selectedTab {
                    ItemListView(type: selectedTab == .reports ? "reports" : "vouchers")
                }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}
struct HeaderView: View {
    let username: String
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.orange.opacity(0.8),
                    Color.orange.opacity(0.6)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .background(Color.orange)
            
            HStack {
                Text(username)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                Spacer()
                
                NavigationLink(destination: NotificationView()) {
                    Image(systemName: "bell.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }
            }
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .edgesIgnoringSafeArea(.top)
    }
}



struct TabsView: View {
    @Binding var selectedTab: MainView.Tab?
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                selectedTab = .reports
            }) {
                Text("Reports")
                    .font(.headline)
                    .foregroundColor(selectedTab == .reports ? .black : .gray)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedTab == .reports ? Color.white : Color.clear)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    )
                    .cornerRadius(10)
                
            }
            
            Button(action: {
                selectedTab = .vouchers
            }) {
                Text("Vouchers")
                    .font(.headline)
                    .foregroundColor(selectedTab == .vouchers ? .black : .gray)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedTab == .vouchers ? Color.white : Color.clear)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    )
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
        .background(Color.gray.opacity(0.5))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(username: "John Doe")
    }
}
