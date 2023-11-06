import SwiftUI
import Foundation

struct ContentView: View {
    @EnvironmentObject var screenshotDetector: ScreenshotDetector
    @State private var circleColors: [Color] = [.red, .green, .blue]
    @State private var isAlertViewVisible = false
    @State private var rectIsEnlarged = false
    @State private var circleIsEnlarged = false
    
    var body: some View {
        ZStack {
            HomeView()
            if isAlertViewVisible {
                AlertView()
            }
            // Add animation and proper overlay settings here
            if screenshotDetector.showView {
                ZStack {
                    RoundedRectangleView(isEnlarged: $rectIsEnlarged)
                        .frame(width: 100, height: 161.8)
                        .foregroundColor(.gray)
                        .opacity(0.5)
                        .position(x: UIScreen.main.bounds.size.width - 60, y: 75)
                        /*.onTapGesture {
                            withAnimation {
                                isEnlarged.toggle()
                            }
                            print("Tapped main box")
                            screenshotDetector.restartTimer()
                        }*/
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    rectIsEnlarged.toggle()
                                    screenshotDetector.restartTimer()
                                }
                                .onEnded { _ in
                                    rectIsEnlarged.toggle()
                                    screenshotDetector.restartTimer()
                                }
                        )
                    // Three small circles inside the rectangle
                    HStack {
                        VStack {
                            // Make this stack have same tap property as parent rect for timer
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                                .onTapGesture {
                                    screenshotDetector.restartTimer()
                                    print("Added photo to Red album") // delete
                                    if let mostRecentImage = PhotoHelper().fetchMostRecentImage() {
                                        let albumName = "Red Album" // Replace with your desired album name
                                        PhotoHelper().addImageToAlbum(image: mostRecentImage, albumName: albumName)
                                    }
                                }
                            
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.green)
                                .onTapGesture {
                                    screenshotDetector.restartTimer()
                                    print("Added photo to Green album") // delete
                                    if let mostRecentImage = PhotoHelper().fetchMostRecentImage() {
                                        let albumName = "Green Album" // Replace with your desired album name
                                        PhotoHelper().addImageToAlbum(image: mostRecentImage, albumName: albumName)
                                    }
                                }
                            
                            CircleView(isEnlarged: $circleIsEnlarged)
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { _ in
                                            circleIsEnlarged.toggle()
                                            screenshotDetector.restartTimer()
                                        }
                                        .onEnded { _ in
                                            circleIsEnlarged.toggle()
                                            screenshotDetector.restartTimer()
                                        }
                                )
                            
                        }
                    }
                    .position(x: UIScreen.main.bounds.size.width - 60, y: 75)
                }
            }
        }
    }
    
    private func getRandomColor() -> Color {
        let colors: [Color] = [.red, .green, .blue, .orange, .purple, .pink]
        return colors.randomElement() ?? .gray
    }
}

struct CircleView: View {
    @Binding var isEnlarged: Bool
    var body: some View {
        Circle()
            .frame(width: isEnlarged ? 33 : 30, height: isEnlarged ? 33 : 30)
            .foregroundColor(.yellow)
            .overlay(
                Circle()
                    .stroke(Color.blue, lineWidth: 2)
            )
    }
}

struct RoundedRectangleView: View {
    @Binding var isEnlarged: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: isEnlarged ? 29.1 : 30)
            .frame(width: isEnlarged ? 100 : 97, height: isEnlarged ? 171.8 : 166.8)
    }
}

struct AlertView: View {
    @State private var showingAlert = false
    @State private var enteredText = ""
    var body: some View {
        Text("")
            .onAppear {
                showingAlert = true
            }
            .alert("Enter new photo album name", isPresented: $showingAlert) {
                TextField("Enter text", text: $enteredText)
                Button() {
                    if let mostRecentImage = PhotoHelper().fetchMostRecentImage() {
                        PhotoHelper().addAssetToNewAlbum(asset: mostRecentImage, albumName: enteredText, isUserCreated: true) // this still makes dupicate albums!?! probably okay to leave for now as will never really be a problem
                    }
                } label: {
                    Text("Submit")
                }
                Button("Cancel", role: .cancel) {
                    // Handle the retry action.
                    print("User cancelled photo album selection.")
                }
            }
    }
}

struct ExampleTextView: View {
    var body: some View {
        Text("EXAMPLE TEXT")
            .transition(.opacity)
    }
}

struct HomeView: View {
    var body: some View {
        Text("Take a screenshot!")
    }
}

