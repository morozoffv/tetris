import Foundation
import UIKit

protocol PlayfieldDelegate: AnyObject {
    func playfieldGameEnded(_ playfield: Playfield)
    func didRedrawPlayfield(_ playfield: Playfield, field: [[Bool]])
}

protocol PlayfieldInput {
    func setup()
    func moveDown()
    func move(x: CGFloat)
    func rotate()
}

final class Playfield: PlayfieldInput {
    private var field: [[Bool]] = []
    private var presentationField: [[Bool]] = []
    private var currentShape: Shape = Shape(type: .I, points: [])
    
    private let configuration: GameConfiguration
    private let shapeFactory: ShapeFactory
    
    weak var delegate: PlayfieldDelegate?
        
    init(configuration: GameConfiguration, shapeFactory: ShapeFactory) {
        self.configuration = configuration
        self.shapeFactory = shapeFactory
        setup()
    }
    
    // MARK: - Public
    
    func setup() {
        field = []
        for _ in 0..<configuration.width {
            field.append(Array(repeating: false, count: configuration.height))
        }
        presentationField = field
        currentShape = shapeFactory.generate()
    }
    
    func moveDown() {
        if !doesCollide(shape: currentShape,
                        xOffset: currentShape.offset.x,
                        yOffset: currentShape.offset.y + 1) {
            currentShape.offset.y += 1;
        } else {
            placeShapeOnField()
        }
        redraw()
    }
    
    func move(x: CGFloat) {
        if !doesCollide(shape: currentShape,
                        xOffset: currentShape.offset.x + x,
                        yOffset: currentShape.offset.y) {
            currentShape.offset.x += x;
            redraw()
        }
    }
    
    func rotate() {
        let rotatedShape = currentShape.rotated()
        if !doesCollide(shape: rotatedShape,
                        xOffset: rotatedShape.offset.x,
                        yOffset: rotatedShape.offset.y) {
            currentShape = rotatedShape
            redraw()
        }
    }
    
    // MARK: - Private
            
    private func doesCollide(shape: Shape, xOffset: CGFloat, yOffset: CGFloat) -> Bool {
        for point in shape.points {
            let x = Int(point.x + xOffset)
            let y = Int(point.y + yOffset)
            
            // If shape isn't within bounds of a field, or there is already a block in that coordinates,
            // then shape collides
            if y >= configuration.height || !(0..<configuration.width).contains(x) || field[x][y] {
                return true
            }
        }
        return false
    }
    
    //TODO: refactor
    private func redraw() {
        presentationField = field
        
        for point in currentShape.points {
            let x = Int(point.x + currentShape.offset.x)
            let y = Int(point.y + currentShape.offset.y)
            
            presentationField[x][y] = true
        }
        
        //TODO: change in place
        var transpondedPresentationField: [[Bool]] = []
        
        for _ in 0..<configuration.height {
            transpondedPresentationField.append(Array(repeating: false, count: configuration.width))
        }
        
        for i in 0..<presentationField.count {
            for j in 0..<presentationField[i].count {
                transpondedPresentationField[j][i] = presentationField[i][j]
            }
        }
        
        delegate?.didRedrawPlayfield(self, field: transpondedPresentationField)
    }
    
    private func placeShapeOnField() {
        for point in currentShape.points {
            let x = Int(point.x + currentShape.offset.x)
            let y = Int(point.y + currentShape.offset.y)
            
            field[x][y] = true
        }
        
        removeRowsIfNeeded()
        
        currentShape = shapeFactory.generate()
        
        if doesCollide(shape: currentShape,
                       xOffset: currentShape.offset.x,
                       yOffset: currentShape.offset.y) {
            delegate?.playfieldGameEnded(self)
        }
    }
        
    private func removeRowsIfNeeded() {
        var spaceBetweenColumns = false
        var j = configuration.height
        while j >= 1 {
            j -= 1
            spaceBetweenColumns = false
            for i in 0...configuration.width - 1 {
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
            for i in 0...configuration.width - 1 {
                field[i][j + 1] = field[i][j]
            }
        }
    }
}
