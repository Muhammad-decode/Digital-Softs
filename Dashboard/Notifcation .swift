import SwiftUI

struct NotificationView: View {
    var body: some View {
        VStack {
            Text("Notifications")
                .font(.largeTitle)
                .padding()
            
            // Add your notification content here
            
            Spacer()
        }
        .navigationBarTitle("Notifications", displayMode: .inline)
//        .navigationBarHidden(true) 
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
