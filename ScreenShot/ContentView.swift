import SwiftUI
import Foundation

struct ContentView: View {
    @EnvironmentObject var screenshotDetector: ScreenshotDetector
    //@State private var isShowing = false
    
    var body: some View {
        HomeView() // instructions for taking screenshot + animated, live action background
        if screenshotDetector.showWidget {
            ColorChangeView() // timer is in this function!
                .onTapGesture {
                    // reset the timer
                    //TimerManager().resetTimer()
                }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .environmentObject(ScreenshotDetector())
        }
    }
    
    struct DisappearingWidgetView: View {
        @State private var isShowing = true
        var body: some View {
            if isShowing {
                ColorChangeView()
                    .onAppear {
                        // Start a timer to hide the view after 3 seconds
                        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                            withAnimation {
                                isShowing = false
                            }
                        }
                    }
            }
        }
    }
    
    struct ColorChangeView: View {
        @State private var circleColors: [Color] = [.red, .green, .blue]
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 150)
                    .position(x: UIScreen.main.bounds.width - 50, y: 75)
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                // Rotate the colors of the circles
                                let lastColor = circleColors.popLast()
                                circleColors.insert(lastColor ?? .red, at: 0)
                            }
                    )
                
                VStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(circleColors[index])
                            .frame(width: 50, height: 50)
                            .onTapGesture {
                                // Change the color of the tapped circle
                                withAnimation {
                                    circleColors[index] = getRandomColor()
                                }
                            }
                    }
                }
            }
        }
        
        private func getRandomColor() -> Color {
            let colors: [Color] = [.red, .green, .blue, .orange, .purple, .pink]
            return colors.randomElement() ?? .gray
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
    
    struct HomeView: View {
        var body: some View {
            Text("Take a screenshot!")
        }
    }
    
}
