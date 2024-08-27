//
//  ChronologyModuleProtocol.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 27.08.2024.
//

import Foundation

struct ChronologyModuleProtocol: GameModuleProtocol {
    typealias AnswerType = [String: String]
    
    var question: String
    var events: AnswerType
    
    func checkAnswer(_ answer: AnswerType) -> Bool {
        return answer == events
    }
}
