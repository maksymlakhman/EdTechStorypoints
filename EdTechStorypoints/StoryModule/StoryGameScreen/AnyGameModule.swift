//
//  AnyGameModule.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 27.08.2024.
//

import Foundation

struct AnyGameModule {
    let moduleType: GameModuleType
    
    init(_ quizModule: QuizModuleProtocol) {
        self.moduleType = .quiz(quizModule)
    }
    
    init(_ findPairModule: FindPairModuleProtocol) {
        self.moduleType = .findPair(findPairModule)
    }
    
    init(_ chronologyModule: ChronologyModuleProtocol) {
        self.moduleType = .chronology(chronologyModule)
    }
    
//    func checkAnswer(_ answer: Any) -> Bool {
//        switch moduleType {
//        case .quiz(let quizModule):
//            return quizModule.checkAnswer(answer as! Int)
//        case .findPair(let findPairModule):
//            return findPairModule.checkAnswer(answer as! [String: String])
//        case .chronology(let chronologyModule):
//            return chronologyModule.checkAnswer(answer as! [String: String])
//        }
//    }
}
