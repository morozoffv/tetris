import Foundation
import UIKit

enum ShapeType: CaseIterable {
    case I, L, T, S, square
    
    var points: [CGPoint] {
        switch self {
        case .I: return I()
        case .L: return L()
        case .T: return T()
        case .S: return S()
        case .square: return square()
        }
    }
}

extension ShapeType {
    func I() -> [CGPoint] {
        [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 2),
            CGPoint(x: 0, y: 3)
        ]
    }
    
    func L() -> [CGPoint] {
        [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 2),
            CGPoint(x: 1, y: 2)
        ]
    }
    
    func T() -> [CGPoint] {
        [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 2, y: 0),
            CGPoint(x: 1, y: 1)
        ]
    }

    func S() -> [CGPoint] {
        [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 1, y: 2)
        ]
    }

    func square() -> [CGPoint] {
        [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 1, y: 1)
        ]
    }
}

struct Shape {
    let type: ShapeType
    var points: [CGPoint]
    var offset: CGPoint
    
    init(type: ShapeType,
         points: [CGPoint],
         configuration: GameConfiguration = .default) {
        
        self.type = type
        self.points = points
        self.offset = CGPoint(x: CGFloat(configuration.width / 2).rounded(), y: 0)
    }
    
    init(type: ShapeType,
         points: [CGPoint],
         configuration: GameConfiguration = .default,
         offset: CGPoint) {
        
        self.type = type
        self.points = points
        self.offset = offset
    }
    
    //TODO: refactor
    func rotated() -> Shape {
        guard type != .square else { return self }
        
        let centerX: CGFloat = points[1].x
        let centerY: CGFloat = points[1].y
        
        let rotatedPoints: [CGPoint] = points.map { point in
            let deltaX = point.x - centerX
            let deltaY = point.y - centerY
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
        
        return Shape(type: self.type, points: shiftedPoints, offset: self.offset)
    }
}
