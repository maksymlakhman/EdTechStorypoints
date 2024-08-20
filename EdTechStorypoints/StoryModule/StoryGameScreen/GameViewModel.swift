import SwiftUI

class GameViewModel: ObservableObject {
    @Published var modules: [AnyGameModule] = []
    @Published var currentModuleIndex: Int = 0
    @Published var progress: Double = 0.0
    @Published var isGameFinished = false
    @Published var showCorrectSheet = false
    @Published var showIncorrectSheet = false

    @Published var events: [String: String] = [
        "1798": "Тарас Шевченко публікує 'Кобзар'",
        "1867": "Іван Франко публікує 'Захар Беркут'",
        "1934": "Перший конгрес письменників України",
        "1991": "Проголошення незалежності України"
    ]

    @Published var eventList: [String] = []

    private var correctOrder: [String] {
        return events.sorted(by: { $0.key < $1.key }).map { $0.value }
    }

    init() {
        loadModules()
        shuffleModules()
        eventList = events.values.shuffled() // Initialize after properties are set
        updateProgress()
    }

    func loadModules() {
        let quiz = AnyGameModule(QuizModule(question: "Who is depicted in the photo?", options: ["Bohdan Khmelnytsky", "Ivan Mazepa", "Taras Shevchenko", "Petro Konashevych-Sahaidachny"], correctAnswer: 0))
        
        let findPair = AnyGameModule(FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]))
        
        let chronology = AnyGameModule(ChronologyModule(
            question: "Розмісти події в хронологічному порядку:",
            events: events
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

    func checkOrder(eventList: [String]) {
        print("Correct Order: \(correctOrder)")
        print("Current Event List: \(eventList)")
        
        if eventList == correctOrder {
            showCorrectSheet = true
        } else {
            showIncorrectSheet = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.showIncorrectSheet = false
            }
        }
    }
}
