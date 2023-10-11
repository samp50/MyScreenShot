//
//  ScreenshotDetector.swift
//  ScreenShot
//
//  Created by Samuel Phillips on 10/9/23.
//

import SwiftUI
import Foundation

// ObservableObject to detect and store screenshot status
class ScreenshotDetector: ObservableObject {
    @EnvironmentObject var screenshotDetector: ScreenshotDetector
    // Published property to track screenshot detection
    @Published var isScreenshotDetected = false
    @Published var showWidget = false
    
    init() {
        // Add an observer for screenshot notifications
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotTaken), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    @objc func screenshotTaken() {
        // Screenshot detected, update the variable
        print("screenshotTaken variable called")
        isScreenshotDetected = true
        // Make this timer public so it can be reset from logic in ContentView
        // Delete block below when showWidget variable works
        /*let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            // Callback for widget onTap?
            print("Timer fired!")
            self.isScreenshotDetected = false
        }*/
        startTimer()
    }
    
    var timer: Timer?
    var elapsedTime: TimeInterval = 4.0
    var isRunning = false
    
    func startTimer() {
        // Still needs animation
        if !isRunning {
            self.showWidget = true
            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
                self.elapsedTime += 1
                self.showWidget = false
            }
            isRunning = true
            print("Started timer")
        }
    }
    
    func stopTimer() {
        if isRunning {
            timer?.invalidate()
            timer = nil
            isRunning = false
            showWidget = false
        }
    }
    
    func resetTimer() {
        stopTimer()
        elapsedTime = 0
        print("Reset timer")
    }
}
