//
//  TutorialView.swift
//  ScreenShot
//
//  Created by Samuel Phillips on 11/27/23.
//

import SwiftUI

struct TutorialView: View {
    @State private var currentPage = 0
    @State private var tutorialShown = false

    let tutorialPages = [
        TutorialPage(title: "Welcome to MyApp", imageName: "tutorial1"),
        TutorialPage(title: "Explore Features", imageName: "tutorial2"),
        TutorialPage(title: "Get Started Now!", imageName: "tutorial3")
    ]

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<tutorialPages.count) { index in
                    TutorialPageView(tutorialPage: tutorialPages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

            Button(action: {
                if currentPage < tutorialPages.count - 1 {
                    currentPage += 1
                } else {
                    UserDefaults.standard.set(true, forKey: "hasSeenTutorial")
                }
            }) {
                Text(currentPage == tutorialPages.count - 1 ? "Get Started" : "Next")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .opacity(currentPage == tutorialPages.count - 1 ? 1 : 0.8)
            .animation(.easeInOut)
        }
    }

}

struct TutorialPage: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}

struct TutorialPageView: View {
    let tutorialPage: TutorialPage

    var body: some View {
        VStack {
            Image(tutorialPage.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)

            Text(tutorialPage.title)
                .font(.title)
                .fontWeight(.bold)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
