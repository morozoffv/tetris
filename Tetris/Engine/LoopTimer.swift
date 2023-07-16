import Foundation
import UIKit

protocol LoopTimerDelegate: AnyObject {
    func loopTimerDidFire(_ loopTimer: LoopTimer, with countdown: Int)
}

final class LoopTimer {
    
    private var countdown: Int = 0
    private var timer: Timer?
    
    weak var delegate: LoopTimerDelegate?
            
    func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 1 / 2,
            target: self,
            selector: #selector(timerFired),
            userInfo: nil,
            repeats: true
        )
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    deinit {
        timer?.invalidate()
    }
    
    @objc private func timerFired() {
        //TODO :do i need countdown?
        countdown += 1
        delegate?.loopTimerDidFire(self, with: countdown)
    }
}
