//
//  TimerController.swift
//  PowerNapTimer
//
//  Created by Michael Di Cesare on 9/24/19.
//  Copyright © 2019 Michael Di Cesare. All rights reserved.
//

import Foundation

protocol TimerDelegate: class {
    func timerSecondTick()
    func TimerCompleted()
    func TimerStopped()
}

class TimerController {
    // sorce of truth
    var timer: Timer?
    var timeRemaining: TimeInterval?
    
    weak var delegate: TimerDelegate?
    
    var isOn: Bool {
        return timeRemaining != nil ? true : false
    }
    
    
    func timerSecondTick() {
        guard let timeRemaining = timeRemaining else { return }
        if timeRemaining > 0 {
            self.timeRemaining = timeRemaining - 1
            delegate?.timerSecondTick()
        } else {
            timer?.invalidate()
            self.timeRemaining = nil
            delegate?.TimerCompleted()
        }
    }
    
    func startTimer(_ time: TimeInterval) {
        if isOn == false {
            timeRemaining = time
            DispatchQueue.main.async {
                self.timerSecondTick()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                    self.timerSecondTick()
                })
            }
        }
        
    }
    
    
    
    func stopTimer() {
        if isOn == true {
            timeRemaining = nil
            timer?.invalidate()
            delegate?.TimerStopped()
        }
    }
}
