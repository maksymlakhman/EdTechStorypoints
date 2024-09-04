//
//  GameModuleType.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 27.08.2024.
//

import Foundation

enum GameModuleType: Equatable {
    case quiz(QuizModuleProtocol)
    case findPair(FindPairModuleProtocol)
    case chronology(ChronologyModuleProtocol)
    
    static func ==(lhs: GameModuleType, rhs: GameModuleType) -> Bool {
        switch (lhs, rhs) {
        case (.quiz(let lhsModule), .quiz(let rhsModule)):
            return lhsModule.question == rhsModule.question &&
                   lhsModule.image == rhsModule.image &&
                   lhsModule.options == rhsModule.options &&
                   lhsModule.correctAnswer == rhsModule.correctAnswer
        case (.findPair(let lhsModule), .findPair(let rhsModule)):
            return lhsModule.question == rhsModule.question &&
                   lhsModule.correctPairs == rhsModule.correctPairs
        case (.chronology(let lhsModule), .chronology(let rhsModule)):
            return lhsModule.question == rhsModule.question &&
                   lhsModule.correctPairsCronology == rhsModule.correctPairsCronology
        default:
            return false
        }
    }
}
