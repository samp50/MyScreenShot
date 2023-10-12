/*
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
    @Published var widgetTapped = false
    
    init() {
        // Add an observer for screenshot notifications
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotTaken), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    @objc func screenshotTaken() {
        print("screenshotTaken variable called")
        isScreenshotDetected = true
        startTimerOriginal()
    }
    
    var timer: Timer?
    var globalTimer: Timer?
    var elapsedTime: TimeInterval = 4.0
    var isRunning = false
    
    func displayWidgetTESTER() { //del!
        showWidget = true
    }
    
    func startTimerOriginal() {
        print("called startTimerOriginal")
        showWidget = true
        let globalTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            // Callback for widget onTap?
            self.showWidget = false
        }
    }
    
    func stopTimer() {
        if isRunning {
            globalTimer?.invalidate()
            globalTimer = nil
            isRunning = false
        }
    }
    
    func resetTimer() {
        print("called resetTimer")
        globalTimer?.invalidate()
        globalTimer = nil
        isRunning = false
        startTimerOriginal()
    }
}
*/
