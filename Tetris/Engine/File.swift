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

struct Shape {
    let points: [CGPoint]
    var offset: CGPoint = CGPoint(x: 5, y: 0)
    
    func rotated() -> Shape {
        let centerX = Int(round(points.reduce(0) { $0 + $1.x } / CGFloat(points.count)))
        let centerY = Int(round(points.reduce(0) { $0 + $1.y } / CGFloat(points.count)))
        
        let rotatedPoints: [CGPoint] = points.map { point in
            let deltaX = Int(point.x) - centerX
            let deltaY = Int(point.y) - centerY
            let rotatedX = centerX - deltaY
            let rotatedY = centerY + deltaX
            return CGPoint(x: rotatedX, y: rotatedY)
        }
        
        var yShift: CGFloat = 0
        var xShift: CGFloat = 0
        for point in rotatedPoints {
            if point.x < xShift { xShift = point.x }
            if point.y < yShift { yShift = point.y }
        }
        
        let shiftedPoints: [CGPoint] = rotatedPoints.map { point in
            let shiftedX = point.x - xShift
            let shiftedY = point.y - yShift
            return CGPoint(x: shiftedX, y: shiftedY)
        }
        
        return Shape(points: shiftedPoints, offset: self.offset)
    }
}

final class ShapeFactory {
    
    // TODO: make enum?
    func generate() -> Shape {
        switch Int.random(in: 0..<5) {
        case 0:
            return I()
        case 1:
            return L()
        case 2:
            return T()
        case 3:
            return S()
        case 4:
            return square()
        default:
            fatalError()
        }
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
    
    func T() -> Shape {
        Shape(points: [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 2, y: 0),
            CGPoint(x: 1, y: 1)
        ])
    }

    func S() -> Shape {
        Shape(points: [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 1, y: 2)
        ])
    }

    func square() -> Shape {
        Shape(points: [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 1, y: 1)
        ])
    }
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
        if !doesCollide(shape: currentShape, xOffset: currentShape.offset.x, yOffset: currentShape.offset.y + 1) {
            currentShape.offset.y += 1;
        } else {
            placeShapeOnField()
        }
        redraw()
    }
    
    func move(x: CGFloat) {
        if !doesCollide(shape: currentShape, xOffset: currentShape.offset.x + x, yOffset: currentShape.offset.y) {
            currentShape.offset.x += x;
            redraw()
        }
    }
    
    func rotate() {
        let rotatedShape = currentShape.rotated()
        if !doesCollide(shape: rotatedShape, xOffset: rotatedShape.offset.x, yOffset: rotatedShape.offset.y) {
            currentShape = rotatedShape
            redraw()
        }
    }
        
    func doesCollide(shape: Shape, xOffset: CGFloat, yOffset: CGFloat) -> Bool {
        for point in shape.points {
            let x = Int(point.x + xOffset)
            let y = Int(point.y + yOffset)
            
            if y >= config.height {
                return true
            }
            
            if !(0..<config.width).contains(x) {
                return true
            }
                        
            if field[x][y] {
                return true
            }
        }
        return false
    }
    
    //TODO: refactor
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
                    row.append("■")
                } else {
                    row.append("□")
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
        
        removeRowsIfNeeded()
        
        currentShape = shapeFactory.generate()
        
        //TODO: adapt to config
        if doesCollide(shape: currentShape, xOffset: 5, yOffset: 0) {
            delegate?.playfieldGameEnded()
        }
    }
    
    func removeRowsIfNeeded() {
        var spaceBetweenColumns = false
        for j in (0..<config.height).reversed() {
            for i in 0..<config.width {
                spaceBetweenColumns = !field[i][j]
                if spaceBetweenColumns {
                    break
                }
            }
            if !spaceBetweenColumns {
                removeRow(row: j)
            }
        }
    }
    
    private func removeRow(row: Int) {
        for j in (0..<row - 1).reversed() {
            for i in 1..<config.width {
                field[i][j + 1] = field[i][j]
            }
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
