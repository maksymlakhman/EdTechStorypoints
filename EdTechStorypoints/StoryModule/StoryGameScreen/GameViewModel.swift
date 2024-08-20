import SwiftUI

class GameViewModel: ObservableObject {
    @Published var modules: [AnyGameModule] = []
    @Published var currentModuleIndex: Int = 0
    @Published var progress: Double = 0.0
    @Published var isGameFinished = false
    @Published var showCorrectSheet = false
    @Published var showIncorrectSheet = false
    @Published var selectedAnswer: Int?
    ///QuizModule
    @Published var optionsRandom: [QuizModule] = [
        QuizModule(question: "Who is depicted in the photo?", options: ["Bohdan Khmelnytsky", "Ivan Mazepa", "Taras Shevchenko", "Petro Konashevych-Sahaidachny"], correctAnswer: 0),
        QuizModule(question: "Who is depicted in the photo?", options: ["Bohdan Khmelnytsky", "Ivan Mazepa", "Taras Shevchenko", "Petro Konashevych-Sahaidachny"], correctAnswer: 1),
        QuizModule(question: "Who is depicted in the photo?", options: ["Bohdan Khmelnytsky", "Ivan Mazepa", "Taras Shevchenko", "Petro Konashevych-Sahaidachny"], correctAnswer: 2),
        QuizModule(question: "Who is depicted in the photo?", options: ["Bohdan Khmelnytsky", "Ivan Mazepa", "Taras Shevchenko", "Petro Konashevych-Sahaidachny"], correctAnswer: 3),
        QuizModule(question: "Who is depicted in the photo?", options: ["Bohdan Khmelnytsky", "Ivan Mazepa", "Taras Shevchenko", "Petro Konashevych-Sahaidachny"], correctAnswer: 0),
        QuizModule(question: "Who is depicted in the photo?", options: ["Bohdan Khmelnytsky", "Ivan Mazepa", "Taras Shevchenko", "Petro Konashevych-Sahaidachny"], correctAnswer: 1),
        QuizModule(question: "Who is depicted in the photo?", options: ["Bohdan Khmelnytsky", "Ivan Mazepa", "Taras Shevchenko", "Petro Konashevych-Sahaidachny"], correctAnswer: 2),
        QuizModule(question: "Who is depicted in the photo?", options: ["Bohdan Khmelnytsky", "Ivan Mazepa", "Taras Shevchenko", "Petro Konashevych-Sahaidachny"], correctAnswer: 3)
    ]
    
    ///FindPairModule
    @Published var findPairRandom: [FindPairModule] = [
        FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]),
        FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]),
        FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]),
        FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]),
        FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]),
        FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]),
        FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]),
        FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]),
    ]
    
    ///ChronologyModule
    @Published var chronologyRandom: [ChronologyModule] = [
        ChronologyModule(
            question: "Розмісти події в хронологічному порядку:",
            events: [
                "1798": "Тарас Шевченко публікує 'Кобзар'",
                "1867": "Іван Франко публікує 'Захар Беркут'",
                "1934": "Перший конгрес письменників України",
                "1991": "Проголошення незалежності України"
            ]
        ),
        ChronologyModule(
            question: "Розмісти події в хронологічному порядку:",
            events: [
                "1798": "Тарас Шевченко публікує 'Кобзар'",
                "1867": "Іван Франко публікує 'Захар Беркут'",
                "1934": "Перший конгрес письменників України",
                "1991": "Проголошення незалежності України"
            ]
        ),
        ChronologyModule(
            question: "Розмісти події в хронологічному порядку:",
            events: [
                "1798": "Тарас Шевченко публікує 'Кобзар'",
                "1867": "Іван Франко публікує 'Захар Беркут'",
                "1934": "Перший конгрес письменників України",
                "1991": "Проголошення незалежності України"
            ]
        ),
        ChronologyModule(
            question: "Розмісти події в хронологічному порядку:",
            events: [
                "1798": "Тарас Шевченко публікує 'Кобзар'",
                "1867": "Іван Франко публікує 'Захар Беркут'",
                "1934": "Перший конгрес письменників України",
                "1991": "Проголошення незалежності України"
            ]
        ),
    ]
    
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
        eventList = events.values.shuffled()
        updateProgress()
    }

    func loadModules() {
        // Вибір випадкового модуля з кожного масиву
        let quiz = optionsRandom.randomElement() ?? QuizModule(question: "Default Question?", options: ["Option 1", "Option 2"], correctAnswer: 0)
        let findPair = findPairRandom.randomElement() ?? FindPairModule(question: "Default Question?", correctPairs: ["Author": "Work"])
        let chronology = chronologyRandom.randomElement() ?? ChronologyModule(question: "Default Question?", events: [:])
        
        // Додавання випадкових модулів до списку модулів
        modules = [
            AnyGameModule(quiz),
            AnyGameModule(findPair),
            AnyGameModule(chronology)
        ]
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
