//
//  GameModuleProtocol.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 27.08.2024.
//

import Foundation

protocol GameModuleProtocol {
    associatedtype AnswerType
    var question: String { get }
//    func checkAnswer(_ answer: AnswerType) -> Bool
}
