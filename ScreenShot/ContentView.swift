import SwiftUI
import Foundation

struct ContentView: View {
    @EnvironmentObject var screenshotDetector: ScreenshotDetector
    
    @State private var isUserMessageVisible = false
    @State private var isAlertViewVisible = false
    @State private var rectIsEnlarged = false
    @State private var circleIsEnlarged: [Bool] = [false, false, false, false, false, false, false] // 2 default Album name values + 5 extras -- make sure to write in alert for >7 album creation attempts
    //@State private var albumNames = ["Red Album (Screenshot)", "Green Album (Screenshot)", "", "", "", "", nil]
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
    //@State private var dummyDict: [String: Bool] = ["Red Album": false, "Green Album": false, "Blue Album": false]
    let defaults = UserDefaults.standard
    
    var body: some View {
        ZStack {
            //HomeView()
            TransitionView()
            if isUserMessageVisible {
                UserMessageView()
            }
            if isAlertViewVisible {
                AlertView()
            }
            // Add animation and proper overlay settings here
            if screenshotDetector.showView {
                ZStack {
                    RoundedRectangleView(isEnlarged: $rectIsEnlarged)
                        .frame(width: 100, height: 161.8) // RoundedRect dimensions
                        .foregroundColor(.gray)
                        .opacity(0.5)
                        .position(x: UIScreen.main.bounds.size.width - 60, y: 75)
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
                    ScrollView {
                        VStack {
                            // Make this stack have same tap property as parent rect for timer
                            CircleView(isEnlarged: $circleIsEnlarged[0])
                            // Rewrite button actions as function for readability
                                .foregroundColor(.red)
                                .onTapGesture {
                                    let savedAlbumName = defaults.object(forKey: "SS-0")
                                    buttonIsTapped(circleNum: 0, albumName: savedAlbumName as! String)
                                }
                            
                            CircleView(isEnlarged: $circleIsEnlarged[1])
                                .foregroundColor(.green)
                                .onTapGesture {
                                    let savedAlbumName = defaults.object(forKey: "SS-1")
                                    buttonIsTapped(circleNum: 1, albumName: savedAlbumName as! String)
                                }
                            
                            CircleView(isEnlarged: $circleIsEnlarged[6])
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    isAlertViewVisible.toggle()
                                    circleIsEnlarged[6].toggle()
                                    delay(seconds: 0.25) {
                                        circleIsEnlarged[6].toggle()
                                    }
                                }
                        }
                    }
                    .frame(width: 100, height: 161.8 / 1.5)
                    .position(x: UIScreen.main.bounds.size.width - 60, y: 75)
                    .background(Color.gray.opacity(0.1))
                }
            }
        }
    }
    
    
    private func delay(seconds: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            closure()
        }
    }
    
    private func buttonIsTapped(circleNum: Int, albumName: String) {
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
        circleIsEnlarged[circleNum].toggle()
        if let mostRecentImage = PhotoHelper().fetchMostRecentImage() {
            PhotoHelper().addImageToAlbum(image: mostRecentImage, albumName: albumName)
        }
        delay(seconds: 0.25) {
            circleIsEnlarged[circleNum].toggle()
            impactFeedbackgenerator.impactOccurred()
        }
        isUserMessageVisible.toggle()
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            isUserMessageVisible.toggle()
        }
    }
}

struct CircleView: View {
    @Binding var isEnlarged: Bool
    var body: some View {
        Circle()
            .frame(width: isEnlarged ? 33 : 30, height: isEnlarged ? 33 : 30)
        //.foregroundColor(.yellow)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 1)
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

struct UserMessageView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30.0)
                .frame(width: 225, height: 75)
                .position(x: UIScreen.main.bounds.size.width / 2, y: (UIScreen.main.bounds.size.height / 5) * 4)
                .foregroundColor(.gray)
                .opacity(0.5)
                .cornerRadius(10)
            Text("Added image to album")
                .foregroundColor(.white)
                .font(.body)
                .position(x: UIScreen.main.bounds.size.width / 2, y: (UIScreen.main.bounds.size.height / 5) * 4)
                .multilineTextAlignment(.center)
        }
    }
}

struct HomeView: View {
    @State private var backgroundColor: Color = Color.blue
    var body: some View {
        VStack {
            // Place rotating LottieView struct here - should also change background
            // color with cool transition and dynamic background effect
            Rectangle()
                .foregroundColor(backgroundColor)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    // Start the timer when the view appears
                    startAnimationBackgroundTransition()
                }
            /*LottieView(animationName: "Starfish", loopMode: .loop)
                .frame(width: 200, height: 200) // temporary fix: forces bottom text up and may only work on iPhone 11
             */
            Text("Take a screenshot!")
            Text("Animation credit: @tomfabre")
        }
    }
    
    private func startAnimationBackgroundTransition() {
        // Create a timer that fires every five seconds
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            // Change the background color here
            // For demonstration, I'm alternating between blue and red
            if backgroundColor == Color.blue {
                backgroundColor = Color.red
            } else {
                backgroundColor = Color.blue
            }
        }
    }
}

struct TransitionView: View {
    @State private var backgroundColors: [Color] = [.red, .green, .blue, .orange]
    @State private var currentIndex = 0

    var body: some View {
        ZStack {
            backgroundColors[currentIndex]
                .edgesIgnoringSafeArea(.all)
            VStack {
                LottieView(animationName: "AllAnimals", loopMode: .loop)
                    .frame(width: 400, height: 400) // temporary fix: forces bottom text up and may only work on iPhone 11
                Text("Take a screenshot!")
                Text("Animation credit: @tomfabre")
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % backgroundColors.count
                }
            }
        }
    }
}
