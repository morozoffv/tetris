import Foundation
import UIKit

protocol LoopTimerDelegate: AnyObject {
    func loopTimerDidFire(_ loopTimer: LoopTimer)
}

protocol LoopTimerInput {
    func start()
    func stop()
}

final class LoopTimer: LoopTimerInput {
    private let configuration: GameConfiguration
    private var timer: Timer?
    
    weak var delegate: LoopTimerDelegate?
    
    init(configuration: GameConfiguration = .default) {
        self.configuration = configuration
    }
            
    func start() {
        timer = Timer.scheduledTimer(
            timeInterval: configuration.timerFireFrequency,
            target: self,
            selector: #selector(timerFired),
            userInfo: nil,
            repeats: true
        )
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }

    deinit {
        timer?.invalidate()
    }
    
    @objc private func timerFired() {
        delegate?.loopTimerDidFire(self)
    }
}
