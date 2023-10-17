//
//  ScreenShotApp.swift
//  ScreenShot
//
//  Created by Samuel Phillips on 10/1/23.
//

import SwiftUI
//public var screenShotDetected: Bool = false

@main
struct ScreenShotApp: App {
    @StateObject var screenshotDetectorGPT = ScreenshotDetectorGPT()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(screenshotDetectorGPT)
        }
    }
}
