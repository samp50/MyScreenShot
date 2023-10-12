//
//  ScreenshotDetectorGPT.swift
//  ScreenShot
//
//  Created by Samuel Phillips on 10/12/23.
//

import SwiftUI
import Foundation

class ScreenshotDetectorGPT: ObservableObject {
    static let shared = ScreenshotDetectorGPT()
    
    @Published var showView: Bool = false

    var timer: Timer?

    init() {
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
        timer?.invalidate()
        self.showView = true
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            self.showView = false
        }
    }

    func stopTimer() {
        timer?.invalidate()
    }
}
