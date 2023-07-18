import Foundation
import UIKit

final class Presenter {
    
    private let gameCoordinator: GameCoordinatorInput
    
    weak var view: ViewInput?
    
    init(gameCoordinator: GameCoordinatorInput) {
        self.gameCoordinator = gameCoordinator
    }
}

extension Presenter: ViewOutput {
    func onViewDidLoad() {
        gameCoordinator.start()
    }
    
    func left() {
        gameCoordinator.left()
    }
    
    func right() {
        gameCoordinator.right()
    }
    
    func rotate() {
        gameCoordinator.rotate()
    }
    
    func restart() {
        gameCoordinator.restart()
    }
}

extension Presenter: GameCoordinatorDelegate {
    func didRedrawPlayfield(_ coordinator: GameCoordinator, field: [[Bool]]) {
        var result: String = ""
        for i in 0..<field.count {
            var row = ""
            for j in 0..<field[i].count {
                let element = field[i][j]
                if element {
                    row.append("⬜")
                } else {
                    row.append("⬛")
                }
            }
            result.append("\(row)\n")
            row = ""
        }

        view?.redraw(string: result)
    }
}
