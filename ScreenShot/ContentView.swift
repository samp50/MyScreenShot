import SwiftUI
import Foundation

struct ContentView: View {
    @EnvironmentObject var screenshotDetector: ScreenshotDetector
    
    @State private var isUserMessageVisible = false
    @State private var isAlertViewVisible = false
    @State private var rectIsEnlarged = false
    @State private var circleIsEnlarged: [Bool] = [false, false, false, false, false, false] // 2 default Album name values + 5 extras -- make sure to write in alert for >7 album
    //@State private var circleColors: [UIColor] = [UIColor(hex: 0x020887), UIColor(hex: 0x334195), UIColor(hex: 0x647AA3), UIColor(hex: 0x95B2B0), UIColor(hex: 0xC6EBBE), UIColor(hex: 0x3498db)]
    //@State private var albumNames = ["Red Album (Screenshot)", "Green Album (Screenshot)", "", "", "", "", nil]
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
    //@State private var dummyDict: [String: Bool] = ["Red Album": false, "Green Album": false, "Blue Album": false]
    let defaults = UserDefaults.standard // del
    @State private var yOffset: CGFloat = 0.0
    let lowerLimit: CGFloat = -100.0
    let upperLimit: CGFloat = 100.0
    
    
    var body: some View {
        ZStack {
            HomeView()
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
                    //.frame(width: 100, height: 161.8)
                        .foregroundColor(.gray)
                        .opacity(0.5)
                        .position(x: UIScreen.main.bounds.size.width - 60, y: 75)
                    /*.onTapGesture {
                     rectIsEnlarged.toggle()
                     delay(seconds: 0.25) {
                     rectIsEnlarged.toggle()
                     }
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
                    // 🔴 🔵 🟢
                    ScrollViewReader { scrollViewProxy in
                        ScrollView {
                            // Three small circles inside the rectangle
                            HStack {
                                VStack {
                                    GeometryReader { geo in
                                        Color.clear.preference(
                                            key: ViewOffsetKey.self,
                                            value: geo.frame(in: .named("scroll")).origin.y
                                        )
                                    }
                                    .onPreferenceChange(ViewOffsetKey.self) { value in
                                        yOffset = value
                                    }
                                    // Make this stack have same tap property as parent rect for timer
                                    let ssUserDefaultsData = filterUserDefaultsData(withPrefix:" SS-")
                                    ForEach(0..<3) { index in
                                        /*Text("Item \(index)")
                                         .frame(width: 200, height: 50)
                                         .background(Color.blue)
                                         .cornerRadius(10)
                                         */
                                        CircleView(isEnlarged: $circleIsEnlarged[0])
                                        // Rewrite button actions as function for readability
                                        //.foregroundColor(.red)
                                            .onTapGesture {
                                                let savedAlbumName = defaults.object(forKey: "0")
                                                buttonIsTapped(circleNum: 0, albumName: savedAlbumName as! String)
                                            }
                                    }
                                    /*
                                     CircleView(isEnlarged: $circleIsEnlarged[0])
                                     // Rewrite button actions as function for readability
                                     .foregroundColor(.red)
                                     .onTapGesture {
                                     let savedAlbumName = defaults.object(forKey: "0")
                                     buttonIsTapped(circleNum: 0, albumName: savedAlbumName as! String)
                                     }
                                     
                                     CircleView(isEnlarged: $circleIsEnlarged[1])
                                     .foregroundColor(.green)
                                     .onTapGesture {
                                     let savedAlbumName = defaults.object(forKey: "1")
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
                                     */
                                    .offset(y: yOffset)
                                                    .id("scroll")
                                                    .clipped()
                                                    .coordinateSpace(name: "scroll")
                                }
                                .onAppear {
                                                scrollViewProxy.scrollTo("scroll", anchor: .top)
                                            }
                                //.frame(width: 33.0, height: 105.8) // Possible dimension contraints for ScrollView to allow tapping on RoundedRectangle
                            }
                            .position(x: UIScreen.main.bounds.size.width - 60, y: 75)
                        }
                    }
                }
            }
        }
    }
    
    private func filterUserDefaultsData(withPrefix prefix: String) -> [String: Any] {
        var filteredData: [String: Any] = [:]
        
        let allUserDefaultsData = UserDefaults.standard.dictionaryRepresentation()
        for (key, value) in allUserDefaultsData {
            if key.hasPrefix(prefix) {
                filteredData[key] = value
            }
        }
        //print(filteredData)
        return filteredData
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
            .foregroundColor(.yellow)
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
    var body: some View {
        Text("Take a screenshot!")
    }
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0.0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
