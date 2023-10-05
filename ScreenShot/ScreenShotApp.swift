//
//  ScreenShotApp.swift
//  ScreenShot
//
//  Created by Samuel Phillips on 10/1/23.
//

import SwiftUI

@main
struct ScreenShotApp: App {
    let beginScreenshotDetection = ScreenshotDetectionManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
