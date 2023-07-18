import Foundation
import UIKit

protocol GameCoordinatorDelegate: AnyObject {
    func didRedrawPlayfield(_ coordinator: GameCoordinator, field: [[Bool]])
}

protocol GameCoordinatorInput {
    var delegate: GameCoordinatorDelegate? { get set }
    
    func start()
    func end()
    func restart()
    
    func left()
    func right()
    func rotate()
}

final class GameCoordinator: GameCoordinatorInput {

    private let playfield: PlayfieldInput
    private let loopTimer: LoopTimerInput
    
    weak var delegate: GameCoordinatorDelegate?
        
    init(playfield: PlayfieldInput, loopTimer: LoopTimerInput) {
        self.playfield = playfield
        self.loopTimer = loopTimer
    }
    
    func start() {
        loopTimer.start()
    }

    func end() {
        loopTimer.stop()
    }
    
    func restart() {
        loopTimer.stop()
        playfield.setup()
        loopTimer.start()
    }
    
    func left() {
        playfield.move(x: -1)
    }
    
    func right() {
        playfield.move(x: 1)
    }
    
    func rotate() {
        playfield.rotate()
    }
}

extension GameCoordinator: PlayfieldDelegate {
    func playfieldGameEnded(_ playfield: Playfield) {
        loopTimer.stop()
    }
    
    func didRedrawPlayfield(_ playfield: Playfield, field: [[Bool]]) {
        delegate?.didRedrawPlayfield(self, field: field)
    }
}

extension GameCoordinator: LoopTimerDelegate {
    func loopTimerDidFire(_ loopTimer: LoopTimer) {
        playfield.moveDown()
    }
}
