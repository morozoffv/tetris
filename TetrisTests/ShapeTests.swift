import XCTest
@testable import Tetris

final class ShapeTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testIShapeRotate() {
        let shape = Shape(type: .I, points: ShapeType.I.points)
        let rotatedShape = shape.rotated()
        let rotatedPoints = [
            CGPoint(x: 3, y: 1),
            CGPoint(x: 2, y: 1),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 0, y: 1)
        ]
        XCTAssertEqual(rotatedShape.points, rotatedPoints)
    }
    
    func testLShapeRotate() {
        let shape = Shape(type: .L, points: ShapeType.L.points)
        let rotatedShape = shape.rotated()
        let rotatedPoints = [
            CGPoint(x: 2, y: 1),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0, y: 2)
        ]
        XCTAssertEqual(rotatedShape.points, rotatedPoints)
    }
    func testTShapeRotate() {
        let shape = Shape(type: .T, points: ShapeType.T.points)
        let rotatedShape = shape.rotated()
        let rotatedPoints = [
            CGPoint(x: 1, y: 0),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 1, y: 2),
            CGPoint(x: 0, y: 1)
        ]
        XCTAssertEqual(rotatedShape.points, rotatedPoints)
    }
    func testSShapeRotate() {
        let shape = Shape(type: .S, points: ShapeType.S.points)
        let rotatedShape = shape.rotated()
        let rotatedPoints = [
            CGPoint(x: 2, y: 1),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 1, y: 2),
            CGPoint(x: 0, y: 2)
        ]
        XCTAssertEqual(rotatedShape.points, rotatedPoints)
    }
    func testSquareShapeRotate() {
        let shape = Shape(type: .square, points: ShapeType.square.points)
        let rotatedShape = shape.rotated()
        let rotatedPoints = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 1, y: 1)
        ]
        XCTAssertEqual(rotatedShape.points, rotatedPoints)
    }
}
