import Foundation
import UIKit

protocol PlayfieldDelegate: AnyObject {
    func playfieldGameEnded()
    func didRedraw(string: String)
}

final class Playfield {
    private var field: Array<Array<Bool>> = []
    private var presentationField: Array<Array<Bool>> = []

    private var currentShape: Shape = Shape(points: [])
    
    private let config: PlayfieldConfiguration
    private let shapeFactory: ShapeFactory
    
    weak var delegate: PlayfieldDelegate?
        
    init(config: PlayfieldConfiguration, shapeFactory: ShapeFactory) {
        self.config = config
        self.shapeFactory = shapeFactory
        
        setupField()
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
                    row.append("🐽")
                } else {
                    row.append("⬛")
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
    
//    func removeRowsIfNeeded() {
//        var spaceBetweenColumns = false
//        for j in (0..<config.height).reversed() {
//            for i in 0..<config.width {
//                spaceBetweenColumns = !field[i][j]
//                if spaceBetweenColumns {
//                    break
//                }
//            }
//            if !spaceBetweenColumns {
//                removeRow(row: j)
//            }
//        }
//    }
    
    
    func removeRowsIfNeeded() {
        var spaceBetweenColumns = false
        var j = 20
        while j >= 1 {
            j -= 1
            spaceBetweenColumns = false
            for i in 0...9 {
                if field[i][j] == false {
                    spaceBetweenColumns = true
                    break
                }
            }
            if !spaceBetweenColumns {
                removeRow(row: j)
                j += 1
            }
        }
    }

    
    private func removeRow(row: Int) {
        for j in (0..<row).reversed() {
            for i in 0...9 {
                field[i][j + 1] = field[i][j]
            }
        }
    }
    
//    private func removeRow(row: Int) {
//        for j in 0...row {
//            for i in 0..<config.width {
//                field[i][j] = field[i][j - 1]
//            }
//        }
//    }
    
    func setupField() {
        field = []
        for _ in 0..<config.width {
            field.append(Array(repeating: false, count: config.height))
        }
        presentationField = field
        currentShape = shapeFactory.generate()
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
