import Foundation
import UIKit

protocol GameLauncherDelegate: AnyObject {
    func didUpdate(string: String)
}

final class GameLauncher {

    private let loopTimer: LoopTimer
    private let playfield: Playfield
    private let shapeFactory: ShapeFactory
    
    weak var delegate: GameLauncherDelegate?
        
    init() {
        self.loopTimer = LoopTimer()
        self.shapeFactory = ShapeFactory()
        self.playfield = Playfield(
            config: PlayfieldConfiguration.default,
            shapeFactory: shapeFactory
        )
        
        loopTimer.delegate = playfield
        playfield.delegate = self
    }
    
    func start() {
        loopTimer.startTimer()
    }

    func end() {
        loopTimer.stopTimer()
    }
    
    func clean() {
        loopTimer.stopTimer()
        playfield.setupField()
        loopTimer.startTimer()
    }
    
    //TODO: try to find better relationships
    func leftDidTapped() {
        playfield.move(x: -1)
    }
    
    func rightDidTapped() {
        playfield.move(x: 1)
    }
    
    func rotateDidTapped() {
        playfield.rotate()
    }
}

extension GameLauncher: PlayfieldDelegate {
    func playfieldGameEnded() {
        loopTimer.stopTimer()
    }
    
    //TODO: do better
    func didRedraw(string: String) {
        delegate?.didUpdate(string: string)
    }
}
