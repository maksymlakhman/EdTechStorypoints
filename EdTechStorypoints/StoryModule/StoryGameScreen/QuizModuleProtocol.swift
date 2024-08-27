//
//  QuizModuleProtocol.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 27.08.2024.
//

import Foundation

struct QuizModuleProtocol: GameModuleProtocol {
    typealias AnswerType = Int
    
    var question: String
    var image: String
    var options: [String]
    var correctAnswer: Int
}
