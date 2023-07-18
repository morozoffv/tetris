import Foundation
import UIKit

final class GameAssembly {
    func assemble() -> GameCoordinatorInput {
        let loopTimer = LoopTimer()
        let shapeFactory = ShapeFactory()
        let playfield = Playfield(configuration: GameConfiguration.default, shapeFactory: shapeFactory)
        let gameCoordinator = GameCoordinator(playfield: playfield, loopTimer: loopTimer)
        
        loopTimer.delegate = gameCoordinator
        playfield.delegate = gameCoordinator
        
        return gameCoordinator
    }
}
