//
//  TutorialView.swift
//  ScreenShot
//
//  Created by Samuel Phillips on 11/27/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct TutorialView: View {
    @State private var currentPage = 0
    @State private var tutorialShown = false

    let tutorialPages = [
        TutorialPage(title: "Welcome to Screenshotter", imageName: "TutorialAppIcon", caption: "Screenshotter allows you to organize your screenshots as you take them. This app is basic demonstration of a useful native feature that might be considered in a future iOS release."),
        TutorialPage(title: "", imageName: "InitialScreenshotWithButton.gif", caption: "Start by taking a screenshot as the animations play. A widget appears in the corner of your screen with each button representing an album to save your photos."),
        TutorialPage(title: "", imageName: "TapToAdd.gif", caption: "When you tap a button, the screenshot you just took is saved to the corresponding album in your Photos app."),
        TutorialPage(title: "", imageName: "ScreenshotWithNewAlbum.gif", caption: "The first two categories represent “Mammals” and “Birds”. You can tap the plus icon to name a new category to add images. A new button appears to save screenshots to your new category in the future."),
        TutorialPage(title: "", imageName: "DisplayDeletion.gif", caption: "When you're done using the app. Press the “Options” button to erase all Screenshotter-created albums and photos from your library. You can also reset your photos permissions or restart this tutorial."),
        TutorialPage(title: "Let's begin! You'll need to tap 'Allow Full Access' to use Screenshotter properly.", imageName: "AllowFullAccess.gif", caption: ""), // test screen
    ]

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<tutorialPages.count) { index in
                    TutorialPageView(tutorialPage: tutorialPages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))

            Button(action: {
                if currentPage < tutorialPages.count - 1 {
                    currentPage += 1
                } else {
                    PhotoHelper().requestPhotoLibraryPermission()
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
    let caption: String
}

struct TutorialPageView: View {
    let tutorialPage: TutorialPage
    @State private var isGifVisible = false
    
    var body: some View {
        VStack {
            if tutorialPage.imageName == "TutorialAppIcon" {
                Image(tutorialPage.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
            } else {
                GeometryReader { geometry in
                    VStack {
                        //Spacer()
                        HStack {
                            //Spacer()
                            if isGifVisible {
                                AnimatedImage(name: tutorialPage.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            //Spacer()
                        }
                        //Spacer()
                    }
                }
                .onAppear {
                    isGifVisible = true
                }
                .onDisappear {
                    isGifVisible = false
                }
            }
            
            Text(tutorialPage.title)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text(tutorialPage.caption)
                .font(.title3)
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
