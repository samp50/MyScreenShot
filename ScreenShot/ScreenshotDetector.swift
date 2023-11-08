//
//  ScreenshotDetector.swift
//  ScreenShot
//
//  Created by Samuel Phillips on 10/12/23.
//

import SwiftUI
import Foundation

class ScreenshotDetector: ObservableObject {
    
    static let shared = ScreenshotDetector()
    
    @Published var showView: Bool = false
    @Published var isScreenshotTaken = false
    @Published var timer: Timer?

    init() {
        // Set our two default album names
        let defaults = UserDefaults.standard
        defaults.set("Red Album (Screenshot)", forKey: "0");
        defaults.set("Green Album (Screenshot)", forKey: "1");
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: nil
        ) { _ in
            self.showView = true
            self.restartTimer()
        }
    }

    func restartTimer() {
        print("Called restartTimer")
        timer?.invalidate()
        showView = true
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            self.showView = false
        }
    }

    func stopTimer() {
        timer?.invalidate()
    }
}
