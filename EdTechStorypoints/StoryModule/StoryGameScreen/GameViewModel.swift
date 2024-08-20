//
//  GameViewModel.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 19.08.2024.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var modules: [AnyGameModule] = []
    @Published var currentModuleIndex: Int = 0
    @Published var progress: Double = 0.0
    @Published var isGameFinished = false
    @Published var showCorrectSheet = false
    @Published var showIncorrectSheet = false
    
    init() {
        loadModules()
        shuffleModules()
        progress = 0.0
    }
    
    func loadModules() {
        let quiz = AnyGameModule(QuizModule(question: "Who is depicted in the photo?", options: ["Bohdan Khmelnytsky", "Ivan Mazepa", "Taras Shevchenko", "Petro Konashevych-Sahaidachny"], correctAnswer: 0))
        let findPair = AnyGameModule(FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]))
        
        let eventsWithYears = [
            1919: "Підписання Акта Злуки",
            1991: "Проголошення незалежності України",
            2004: "Початок Помаранчевої революції",
            2014: "Революція Гідності"
        ]
        
        
        let chronology = AnyGameModule(ChronologyModule(
            eventsWithYears: eventsWithYears, question: "Розмістіть події в хронологічному порядку"
        ))
        
        modules = [quiz, findPair, chronology]
    }
    
    func shuffleModules() {
        modules.shuffle()
    }
    
    func updateProgress() {
        progress = Double(currentModuleIndex) / Double(modules.count)
    }
    
    func checkAnswer<AnswerType>(_ answer: AnswerType) -> Bool {
        let currentModule = modules[currentModuleIndex]
        let result = currentModule.checkAnswer(answer)
        
        if result {
            showCorrectSheet = true
        } else {
            showIncorrectSheet = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.showIncorrectSheet = false
            }
        }
        
        return result
    }

    func completeModule() {
        if currentModuleIndex < modules.count - 1 {
            currentModuleIndex += 1
        } else {
            isGameFinished = true
        }
        updateProgress()
    }
}
