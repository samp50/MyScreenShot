//
//  TimerManager.swift
//  ScreenShot
//
//  Created by Samuel Phillips on 10/11/23.
//

import Foundation


class TimerManager {
    var timer: Timer?
    var elapsedTime: TimeInterval = 4.0
    var isRunning = false
    
    func startTimer() {
        if !isRunning {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                self.elapsedTime += 1
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
        }
    }
    
    func resetTimer() {
        stopTimer()
        elapsedTime = 0
        print("Reset timer")
    }
}
