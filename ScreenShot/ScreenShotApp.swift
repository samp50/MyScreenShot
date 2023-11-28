//
//  ScreenShotApp.swift
//  ScreenShot
//
//  Created by Samuel Phillips on 10/1/23.
//

import SwiftUI

@main
struct ScreenShotApp: App {
    @StateObject var screenshotDetector = ScreenshotDetector()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(screenshotDetector)
        }
    }
}
