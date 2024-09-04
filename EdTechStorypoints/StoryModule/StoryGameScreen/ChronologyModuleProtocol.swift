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
    var correctPairsCronology: AnswerType
}
