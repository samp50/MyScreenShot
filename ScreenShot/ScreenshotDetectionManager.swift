//
//  ScreenshotHelper.swift
//  ScreenShot
//
//  Created by Samuel Phillips on 10/4/23.
//

import UIKit

class ScreenshotDetectionManager {
    static let shared = ScreenshotDetectionManager()
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotDetected), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        print("ScreenshotDetectionManager init")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("ScreenshotDetectionManager deinit")
    }
    
    @objc private func screenshotDetected() {
        // Handle screenshot detection here
        print("Screenshot taken!")
        let mostRecentAsset = PhotoHelper.fetchMostRecentPhoto()
        PhotoHelper.addPhotoToAlbum(fetchResult: mostRecentAsset!, albumName: "Newsom")
    }
}
