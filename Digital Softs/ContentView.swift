import SwiftUI

struct ContentView: View {
    @State private var isActive = false
    var username : String
    
    var body: some View {
        VStack {
            if isActive {
                
                SignIn() // Your main view appears after the splash
            } else {
                SplashView() // Your splash screen content
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // Delay before animation starts
                            withAnimation(.easeIn(duration: 1.5)) { // Animation for logo and text coming in
                                self.isActive = true
                }
            }
        }
    }
    
    struct SplashView: View {
        @State private var logoScale: CGFloat = 1.0
        @State private var logoOpacity: Double = 0.0
        @State private var offsetY: CGFloat = 100.0
        @State private var textScale: CGFloat = 0.5
        @State private var textOpacity: Double = 0.0

        var body: some View {
            VStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 10)
                    .frame(width: 200, height: 200)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .offset(y: offsetY)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            logoScale = 1.2
                            logoOpacity = 1.0
                            offsetY = 0.0
                        }
                    }
                    .padding()
                Text("DIGITALMANAGER")
                    .font(.title).fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 5)
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(10)
                    .scaleEffect(textScale)
                    .opacity(textOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.0).delay(0.5)) {
                            textScale = 1.0
                            textOpacity = 1.0
                        }
                    }
                Text("BUSINESS MANAGEMENT SOFTWARE")
                    .font(.subheadline).foregroundColor(.gray)
                    
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(10)
                    .scaleEffect(textScale)
                    .opacity(textOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.0).delay(0.5)) {
                            textScale = 1.0
                            textOpacity = 1.0
                        }
                    }
                Spacer()
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }
    }


}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(username: "username")
    }
}
