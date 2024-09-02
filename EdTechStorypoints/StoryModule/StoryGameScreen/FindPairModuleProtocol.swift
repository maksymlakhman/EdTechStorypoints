//
//  FindPairModuleProtocol.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 27.08.2024.
//

import Foundation

struct FindPairModuleProtocol: GameModuleProtocol {
    typealias AnswerType = [String: String]
    
    var question: String
    var correctPairs: AnswerType
    
//    func checkAnswer(_ answer: AnswerType) -> Bool {
//        return answer == correctPairs
//    }
}
