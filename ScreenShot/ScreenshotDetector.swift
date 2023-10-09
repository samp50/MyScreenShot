//
//  ScreenshotDetector.swift
//  ScreenShot
//
//  Created by Samuel Phillips on 10/9/23.
//

import SwiftUI

// ObservableObject to detect and store screenshot status
class ScreenshotDetector: ObservableObject {
    // Published property to track screenshot detection
    @Published var isScreenshotDetected = false

    init() {
        // Add an observer for screenshot notifications
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotTaken), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }

    @objc func screenshotTaken() {
        // Screenshot detected, update the variable
        print("screenshotTaken variable called")
        isScreenshotDetected = true
    }
}
