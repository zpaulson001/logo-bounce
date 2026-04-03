//
//  TimerManager.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 3/20/26.
//

import SwiftUI

enum TimerStatus {
    case stopped  // Fresh start, time is at 0 or the initial set value
    case running  // Timer is actively counting down
    case paused  // Timer is held at a specific value
}

@Observable
class TimerManager {
    private var timerDuration: TimeInterval = 0
    var timeRemaining: TimeInterval = 0
    var timerStatus: TimerStatus = .stopped
    private var timer: Timer?
    private var targetDate: Date?
    
    func setTimer(duration: TimeInterval) {
        self.timerDuration = duration
    }
    
    func getTimerDuration() -> TimeInterval {
        timerDuration
    }

    func start() {
        // 1. Set the destination in time
        targetDate = Date().addingTimeInterval(timerDuration)
        
        timeRemaining = timerDuration

        timerStatus = .running

        // 2. Schedule a standard Timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            [weak self] _ in
            self?.update()
        }
    }
    
    func resume() {
        // 1. Set the destination in time
        targetDate = Date().addingTimeInterval(timeRemaining)

        timerStatus = .running

        // 2. Schedule a standard Timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            [weak self] _ in
            self?.update()
        }
    }

    func pause() {
        timerStatus = .paused
        timer?.invalidate()
        timer = nil
        // timeRemaining is already up to date from the last 'update()' call
    }

    private func update() {
        guard let target = targetDate else { return }

        let diff = target.timeIntervalSinceNow

        if diff <= 0 {
            timeRemaining = 0
            stop()
        } else {
            timeRemaining = diff
        }
    }

    func stop() {
        timerStatus = .stopped
        timer?.invalidate()
        timer = nil
    }
}
