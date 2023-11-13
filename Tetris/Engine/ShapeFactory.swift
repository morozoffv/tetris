import Foundation

protocol ShapeFactoryInput {
    func generate() -> Shape
}

final class ShapeFactory: ShapeFactoryInput {
    func generate() -> Shape {
        guard let randomShape = ShapeType.allCases.randomElement() else {
            return Shape(type: .I, points: ShapeType.I.points)
        }
        return Shape(type: randomShape, points: randomShape.points)
    }
}
