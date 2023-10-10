import SwiftUI
import Foundation

struct ContentView: View {
    @EnvironmentObject var screenshotDetector: ScreenshotDetector
    @State private var isShowing = false
    @State private var isAnimating = false
    
    var body: some View {
        if screenshotDetector.isScreenshotDetected {
            DisappearingWidgetView()
        } else {
            TextView()
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .environmentObject(ScreenshotDetector())
        }
    }
    
    struct DisappearingWidgetView: View {
        @State private var isAnimating = true
        @State private var isShowing = true
        var body: some View {
            if isShowing {
                WidgetView()
                    .animation(.easeInOut(duration: 3.0))
                    .opacity(isAnimating ? 1.0 : 0.2)
                    .onAppear { // make sure to stop+reset timer when user is interacting with widget
                        Timer.scheduledTimer(withTimeInterval: 7.0, repeats: false) { _ in
                            withAnimation {
                                isShowing = false
                            }
                        }
                    }
            }
        }
    }
    
    struct WidgetView: View {
        @State private var isAlertViewVisible = false
        var body: some View {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.height / 5)
                .cornerRadius(20)
                .foregroundColor(.blue)
                .padding(.trailing, 20)
                .padding(.top, 20)
            
            VStack(spacing: 10) {
                // Placeholder 1
                CircleView().onTapGesture {
                    
                }
                // Placeholder 2
                CircleView().onTapGesture {
                    
                }
                // Placeholder 3
                CircleView().onTapGesture {
                    isAlertViewVisible = true
                }
            }
            .padding(.trailing, 20)
            .padding(.top, 20)
        }
    }
    
    struct CircleView: View {
        var body: some View {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
                .overlay(
                    Circle()
                        .stroke(Color.blue, lineWidth: 2)
                )
        }
    }
    
    struct AlertView: View {
        @State private var showingAlert = false
        @State private var enteredText = ""
        var body: some View {
            Button("Show Alert") {
                showingAlert = true
            }
            .alert("Enter new photo album name", isPresented: $showingAlert) {
                TextField("Enter text", text: $enteredText)
                Button() {
                    // Handle the deletion.
                    PhotoHelper.createNewPhotoAlbum(albumName: enteredText)
                } label: {
                    Text("Submit")
                }
                Button("Cancel", role: .cancel) {
                    // Handle the retry action.
                    print("User cancelled photo album selection.")
                }
            }
            .padding()
        }
    }
    
    struct TextView: View {
        var body: some View {
            Text("Fading View")
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
//                .animation(.easeInOut(duration: 5)) // not working
        }
    }
    
    struct ExampleAnimationView: View {
        @State private var isAnimating = false // A state variable to control the animation

        var body: some View {
            VStack {
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .opacity(isAnimating ? 1.0 : 0.2) // Change opacity based on state
                    .scaleEffect(isAnimating ? 1.5 : 1.0) // Change scale based on state
                    .rotationEffect(isAnimating ? .degrees(45) : .degrees(0)) // Change rotation based on state
                    //.animation(.easeInOut(duration: 5.0)) // Apply animation to the view

                Button("Animate") {
                    withAnimation {
                        self.isAnimating.toggle() // Toggle animation with smooth transitions
                    }
                }
            }
        }
    }
    
}
