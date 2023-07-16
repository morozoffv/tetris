import Foundation
import UIKit


enum ShapeType {
    
}

struct Shape {
    let points: [CGPoint]
    var offset: CGPoint = CGPoint(x: 5, y: 0)
    
    //TODO: refactor
    func rotated() -> Shape {
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
        
        return Shape(points: shiftedPoints, offset: self.offset)
    }
}

final class ShapeFactory {
    
    // TODO: make enum?
    func generate() -> Shape {
//        switch Int.random(in: 0..<5) {
//        case 0:
            return I()
//        case 1:
//            return L()
//        case 2:
//            return T()
//        case 3:
//            return S()
//        case 4:
//            return square()
//        default:
//            fatalError()
//        }
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


// What to do on left/right/rotate
protocol InputHandler: AnyObject {
    func leftDidTapped()
    func rightDidTapped()
    func rotateDidTapped()
}
