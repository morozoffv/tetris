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
        countdown += 1
        delegate?.loopTimerDidFire(self, with: countdown)
    }
}


////TODO: is there a way to not rely on CADisplayLink?
//final class LoopTimer {
//
//    private var countdown: Int = 0
//    private var displayLink: CADisplayLink?
//    //TODO: why i use display link?
//
//    weak var delegate: LoopTimerDelegate?
//
//    func initTimer() {
//        let displayLink = CADisplayLink(target: self, selector: #selector(timerFired))
//        self.displayLink = displayLink
//        displayLink.preferredFramesPerSecond = 30
//        displayLink.isPaused = true
//        displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
//    }
//
//    func startTimer() {
//        displayLink?.isPaused = false
//    }
//
//    func stopTimer() {
//        displayLink?.isPaused = true
//    }
//
//    deinit {
//        displayLink?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
//    }
//
//    @objc private func timerFired() {
//        countdown += 1
//        delegate?.loopTimerDidFire(self, with: countdown)
//    }
//}
