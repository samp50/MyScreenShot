import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            Rectangle()
                .frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.height / 5)
                .cornerRadius(20)
                .foregroundColor(.blue)
                .padding(.trailing, 20)
                .padding(.top, 20)

            VStack(spacing: 10) {
                CircleView()
                CircleView()
                CircleView()
            }
            .padding(.trailing, 20)
            .padding(.top, 20)
        }
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
            .onTapGesture {
                // Handle tap on the circle here
                // print("Circle Tapped!")
                PhotoHelper.createNewPhotoAlbum()
            }
    }
}
