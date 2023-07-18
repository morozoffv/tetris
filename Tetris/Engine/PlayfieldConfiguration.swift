import Foundation

struct GameConfiguration {
    let width: Int
    let height: Int
    let timerFireFrequency: TimeInterval
}

extension GameConfiguration {
    static let `default` = GameConfiguration(width: 10,
                                             height: 20,
                                             timerFireFrequency: 1 / 2)
}
