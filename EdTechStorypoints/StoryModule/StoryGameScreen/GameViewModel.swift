//
//  GameViewModel.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 27.08.2024.
//

import SwiftUI

enum ModuleType {
    case quiz(QuizModuleProtocol)
    case findPair(FindPairModuleProtocol)
    case chronology(ChronologyModuleProtocol)
}

struct Module {
    let moduleType: ModuleType
}

class GameViewModel: ObservableObject {
    @Published var modules: [Module]
    @Published var showCorrectSheet = false
    @Published var showIncorrectSheet = false
    @Published var currentModule: Module
    @Published var isGameFinished = false
    private var currentModuleIndex: Int = 0
    @Published var progress: Double = 0.0
    @Published var showFreemiumSheet = false
    @Published var freemiumIsActive = false
    @Published var isFirstAIAssistantIsUser = false
    
    var correctPhrases = [
        "Spot on! You're a genius!",
        "Bullseye! Nailed it!",
        "Boom! You're on fire!",
        "Absolutely correct! Keep it up!",
        "Crushed it! You're unstoppable!",
        "You're on point! Great job!",
        "Bingo! You've got it!",
        "Right on the money! Well done!",
        "Perfect! You hit the mark!",
        "Bang! You're a rockstar!"
    ]
    
    var incorrectPhrases = [
        "Oops! Not quite right.",
        "Close, but not correct.",
        "Try again, you got this!",
        "Don't worry, keep going!",
        "Missed it, but you're learning!",
        "No worries, everyone slips up!",
        "Almost there, give it another shot!",
        "Not your best, but keep at it!",
        "Don't sweat it, try once more!",
        "You'll get it next time!"
    ]
    
    var quizViewModel: QuizViewModel?
    var findPairViewModel: FindPairViewModel?
    var chronologyViewModel: ChronologyViewModel?

    init() {
        let loadedModules = GameViewModel.loadModules()
        self.modules = loadedModules
        self.currentModule = loadedModules.first ?? Module(moduleType: .quiz(QuizModuleProtocol(question: "", image: "", options: [], correctAnswer: 0)))
        setupViewModels()
    }

    private func setupViewModels() {
        switch currentModule.moduleType {
        case .quiz(let module):
            quizViewModel = QuizViewModel(module: module)
        case .findPair(let module):
            findPairViewModel = FindPairViewModel(module: module)
        case .chronology(let module):
            chronologyViewModel = ChronologyViewModel(module: module)
        }
    }

    private static func loadModules() -> [Module] {
        return [
            Module(moduleType: .quiz(QuizModuleProtocol(
                question: "Хто зображений на картинці?",
                image: "BohdanKhmelnytsky",
                options: ["Іван Мазепа", "Тарас Шевченко", "Богдан Хмельницький", "Михайло Грушевський"],
                correctAnswer: 2
            ))),
            Module(moduleType: .findPair(FindPairModuleProtocol(
                question: "Match the authors to their works",
                correctPairs: ["Author1": "Work1", "Author2": "Work2"]
            ))),
            Module(moduleType: .chronology(ChronologyModuleProtocol(
                question: "Place these events in chronological order",
                events: ["Event1": "Year1", "Event2": "Year2"]
            )))
        ]
    }

    func checkAnswer() -> Bool {
        switch currentModule.moduleType {
        case .quiz:
            return quizViewModel?.checkAnswer() ?? false
        case .findPair:
            return findPairViewModel?.checkAnswer() ?? false
        case .chronology:
            return chronologyViewModel?.checkAnswer() ?? false
        }
    }

    func nextModule() {
        if currentModuleIndex < modules.count - 1 {
            currentModuleIndex += 1
            currentModule = modules[currentModuleIndex]
            setupViewModels()
        } else {
            isGameFinished = true
        }
    }

    func restartGame() {
        self.modules.shuffle()
        self.currentModuleIndex = 0
        self.currentModule = self.modules.first ?? Module(moduleType: .quiz(QuizModuleProtocol(
            question: "", image: "", options: [], correctAnswer: 0
        )))
        setupViewModels()
    }

    func updateProgress() {
        DispatchQueue.main.async {
            withAnimation(.linear(duration: 1.5)) {
                self.progress += 0.1
            }
        }
    }
}
