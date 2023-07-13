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
    
    //TODO: try to find better relationships
    func leftDidTapped() {
        playfield.move(x: -1)
    }
    
    func rightDidTapped() {
        playfield.move(x: 1)
    }
    
    func rotateDidTapped() {
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

struct Shape {
    let points: [CGPoint]
    var offset: CGPoint = CGPoint(x: 5, y: 0)
    
//    func rotated() -> [CGPoint] {
//
//    }
}

final class ShapeFactory {
    
    func generate() -> Shape {
        //add random
        return I()
    }

    func I() -> Shape {
        Shape(points: [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 2),
            CGPoint(x: 0, y: 3)
        ])
    }
    
    func L() -> Shape {
        Shape(points: [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 2),
            CGPoint(x: 1, y: 2)
        ])
    }
    
//    func T() -> Shape {
//
//    }
//
//    func S() -> Shape {
//
//    }
//
//    func square() -> Shape {
//
//    }
}

protocol PlayfieldDelegate: AnyObject {
    func playfieldGameEnded()
    func didRedraw(string: String)
}

final class Playfield {
    private var field: Array<Array<Bool>> = []
    private var presentationField: Array<Array<Bool>> = []

    private var currentShape: Shape
    
    private let config: PlayfieldConfiguration
    private let shapeFactory: ShapeFactory
    
    weak var delegate: PlayfieldDelegate?
    
    //TODO: move?
    private var isGameOver: Bool = false
    
    init(config: PlayfieldConfiguration, shapeFactory: ShapeFactory) {
        
        self.config = config
        self.shapeFactory = shapeFactory
        
        for _ in 0..<config.width {
            field.append(Array(repeating: false, count: config.height))
        }
        presentationField = field
        currentShape = shapeFactory.generate()
    }

    func update(with countdown: Int) {
        moveDown()
    }
    
    func moveDown() {
        if !doesCollide(xOffset: currentShape.offset.x, yOffset: currentShape.offset.y + 1) {
            currentShape.offset.y += 1;
        } else {
            placeShapeOnField()
        }
        redraw()
    }
    
    func move(x: CGFloat) {
        if !doesCollide(xOffset: currentShape.offset.x + x, yOffset: currentShape.offset.y) {
            currentShape.offset.x += x;
        }
        redraw()
    }
        
    func doesCollide(xOffset: CGFloat, yOffset: CGFloat) -> Bool {
        for point in currentShape.points {
            let x = Int(point.x + xOffset)
            let y = Int(point.y + yOffset)
            
            if y >= config.height {
                return true
            }
            
            if field[x][y] {
                return true
            }
        }
        return false
    }
    
    func redraw() {
        presentationField = field
        
        for point in currentShape.points {
            let x = Int(point.x + currentShape.offset.x)
            let y = Int(point.y + currentShape.offset.y)
            
            presentationField[x][y] = true
        }
        
        var transpondedPresentationField: Array<Array<Bool>> = []
        
        for _ in 0..<config.height {
            transpondedPresentationField.append(Array(repeating: false, count: config.width))
        }
        
        for i in 0..<presentationField.count {
            for j in 0..<presentationField[i].count {
                transpondedPresentationField[j][i] = presentationField[i][j]
            }
        }

        var result: String = ""
        for i in 0..<transpondedPresentationField.count {
            var row = ""
            for j in 0..<transpondedPresentationField[i].count {
                let element = transpondedPresentationField[i][j]
                if element {
                    row.append("●")
                } else {
                    row.append("○")
                }
            }
            print(row)
            result.append("\(row)\n")
            row = ""
        }
//        print("\n")
        
        delegate?.didRedraw(string: result)
    }
    
    func placeShapeOnField() {
        for point in currentShape.points {
            let x = Int(point.x + currentShape.offset.x)
            let y = Int(point.y + currentShape.offset.y)
            
            field[x][y] = true
        }
        
        // add removal of row
        
        currentShape = shapeFactory.generate()
        
        //TODO: adapt to config
        if doesCollide(xOffset: 5, yOffset: 0) {
            delegate?.playfieldGameEnded()
        }
    }
}

extension Playfield: LoopTimerDelegate {
    func loopTimerDidFire(_ loopTimer: LoopTimer, with countdown: Int) {
        update(with: countdown)
    }
}

struct PlayfieldConfiguration {
    let width: Int
    let height: Int
}

extension PlayfieldConfiguration {
    static let `default` = PlayfieldConfiguration(width: 10, height: 20)
}

// What to do on left/right/rotate
protocol InputHandler: AnyObject {
    func leftDidTapped()
    func rightDidTapped()
    func rotateDidTapped()
}
