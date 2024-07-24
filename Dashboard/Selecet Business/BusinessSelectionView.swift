import SwiftUI

struct Business: Identifiable {
    let id = UUID()
    var name: String
    var isSelected: Bool
}
import SwiftUI
struct BusinessSelectionView: View {
    @Binding var selectedBusiness: String
    @State private var businesses: [Business] = []
    @State private var isAddingBusiness: Bool = false
    @State private var showBusinessFiles: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(businesses) { business in
                        BusinessRow(business: business)
                            .onTapGesture {
                                selectBusiness(business)
                            }
                    }
                    .onDelete(perform: deleteBusiness)
                }
                .listStyle(InsetGroupedListStyle())
                
                Button(action: {
                    isAddingBusiness = true
                }) {
                    Label("Add New Business", systemImage: "plus")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding()
                .sheet(isPresented: $isAddingBusiness) {
                    AddBusinessView(isPresented: $isAddingBusiness, businesses: $businesses)
                }
                
                Spacer()
            }
            .navigationTitle("Businesses")
            .navigationBarItems(leading: EditButton(), trailing: doneButton)
            .onAppear {
                initializeBusinesses()
            }
            .sheet(isPresented: $showBusinessFiles) {
                BusinessFilesView(selectedBusiness: $selectedBusiness)
            }
        }
    }
    
    private func initializeBusinesses() {
        businesses = [
            Business(name: "Business A", isSelected: false),
            Business(name: "Business B", isSelected: false),
            Business(name: "Business C", isSelected: false)
        ]
    }
    
    private func selectBusiness(_ business: Business) {
        businesses.indices.forEach { index in
            businesses[index].isSelected = businesses[index].id == business.id
        }
        selectedBusiness = business.name
        showBusinessFiles = false // Close the popup after selecting a business
    }
    
    private func deleteBusiness(at offsets: IndexSet) {
        businesses.remove(atOffsets: offsets)
    }
    
    private var doneButton: some View {
        Button(action: {
            // Dismiss any modal or sheet view
            showBusinessFiles = false
        }) {
            Text("Done")
                .foregroundColor(.blue)
        }
    }
}

struct BusinessSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessSelectionView(selectedBusiness: .constant("Business A"))
    }
}

struct BusinessRow: View {
    let business: Business
    
    var body: some View {
        HStack {
            Text(business.name)
                .foregroundColor(.orange)
            Spacer()
            if business.isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}

struct AddBusinessView: View {
    @Binding var isPresented: Bool
    @Binding var businesses: [Business]
    @State private var newBusinessName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter business name", text: $newBusinessName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    addNewBusiness()
                }) {
                    Text("Add")
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
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Add New Business")
            .navigationBarItems(trailing:
                Button("Done") {
                    isPresented = false
                }
            )
        }
    }
    
    private func addNewBusiness() {
        if !newBusinessName.isEmpty {
            businesses.append(Business(name: newBusinessName, isSelected: false))
            newBusinessName = ""
            isPresented = false
        }
    }
}

struct BusinessFilesView: View {
    @Binding var selectedBusiness: String
    
    var body: some View {
        VStack {
            Text("Selected Business: \(selectedBusiness)")
                .padding()
            Spacer()
        }
        .navigationBarTitle("Business Files")
    }
}
