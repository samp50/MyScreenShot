import SwiftUI

struct DeleteView: View {
    @State private var contentHeight: CGFloat = 0
    @State private var scrollViewHeight: CGFloat = 200 // Set your desired height

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(0..<20) { index in
                        Text("Item \(index)")
                            .frame(width: geo.size.width - 40, height: 40)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(
                    GeometryReader { contentGeo in
                        Color.clear
                            .onAppear {
                                self.contentHeight = contentGeo.size.height
                            }
                    }
                )
            }
            .frame(width: geo.size.width, height: min(contentHeight, scrollViewHeight))
            .clipped() // Clip the content that goes beyond the frame
            .border(Color.red) // Optional: Add a border to visualize the frame
        }
        .padding()
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
