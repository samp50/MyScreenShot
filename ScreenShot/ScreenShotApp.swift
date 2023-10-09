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
    //let beginScreenshotDetection = ScreenshotDetectionManager.shared
    @StateObject var screenshotDetector = ScreenshotDetector()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(screenshotDetector) // Pass the detector to ContentView
        }
    }
}
