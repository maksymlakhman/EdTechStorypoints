//import SwiftUI
//
//class GameViewModel: ObservableObject {
//    @Published var modules: [AnyGameModule] = []
//    @Published var currentModuleIndex: Int = 0
//    @Published var progress: Double = 0.0
//    @Published var isGameFinished = false
//    @Published var showCorrectSheet = false
//    @Published var showIncorrectSheet = false
//    @Published var selectedAnswer: Int?
//    
//    @Published var selectedPairs: [String: String] = [:]
//
//    ///QuizModule
//    @Published var optionsRandom: [QuizModule] = [
//        QuizModule(question: "Who is depicted in the photo?", image: "BohdanKhmelnytsky", options: ["Bohdan Khmelnytsky", "Ivan Mazepa", "Taras Shevchenko", "Petro Konashevych-Sahaidachny"], correctAnswer: 0),
//        QuizModule(question: "Who is depicted in the photo?", image: "BohdanKhmelnytsky", options: ["Bohdan Khmelnytsky", "Ivan Mazepa", "Taras Shevchenko", "Petro Konashevych-Sahaidachny"], correctAnswer: 0),
//        QuizModule(question: "Who is depicted in the photo?", image: "BohdanKhmelnytsky", options: ["Bohdan Khmelnytsky", "Ivan Mazepa", "Taras Shevchenko", "Petro Konashevych-Sahaidachny"], correctAnswer: 0),
//        QuizModule(question: "Who is depicted in the photo?", image: "BohdanKhmelnytsky", options: ["Bohdan Khmelnytsky", "Ivan Mazepa", "Taras Shevchenko", "Petro Konashevych-Sahaidachny"], correctAnswer: 0),
//    ]
//    
//    ///FindPairModule
//    @Published var findPairRandom: [FindPairModule] = [
//        FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]),
//        FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]),
//        FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]),
//        FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]),
//        FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]),
//        FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]),
//        FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]),
//        FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]),
//    ]
//    
//    ///ChronologyModule
//    @Published var chronologyRandom: [ChronologyModule] = [
//        ChronologyModule(
//            question: "Розмісти події в хронологічному порядку:",
//            events: [
//                "988": "Хрещення Київської Русі",
//                "1240": "Захоплення Києва монголо-татарами",
//                "1648": "Початок Національно-визвольної війни під проводом Богдана Хмельницького",
//                "1996": "Запровадження гривні як національної валюти України"
//            ]
//        ),
//        ChronologyModule(
//            question: "Розмісти події в хронологічному порядку:",
//            events: [
//                "1654": "Переяславська рада",
//                "1709": "Полтавська битва",
//                "1861": "Відміна кріпацтва в Україні",
//                "2014": "Революція Гідності"
//            ]
//        ),
//        ChronologyModule(
//            question: "Розмісти події в хронологічному порядку:",
//            events: [
//                "1917": "Проголошення Української Народної Республіки",
//                "1921": "Завершення Української революції",
//                "1939": "Початок Другої світової війни",
//                "1986": "Чорнобильська катастрофа"
//            ]
//        ),
//        ChronologyModule(
//            question: "Розмісти події в хронологічному порядку:",
//            events: [
//                "1918": "Бій під Крутами",
//                "1932": "Початок Голодомору в Україні",
//                "1941": "Напад Німеччини на СРСР",
//                "1991": "Референдум за незалежність України"
//            ]
//        ),
//    ]
//    
//
//
//    @Published var eventList: [String] = []
//
//
//    init() {
//        loadModules()
//        shuffleModules()
//        updateProgress()
//    }
//
//    func loadModules() {
//        // Вибір випадкового модуля з кожного масиву
//        let quiz = optionsRandom.randomElement() ?? QuizModule(question: "Default Question?", image: "BohdanKhmelnytsky", options: ["Option 1", "Option 2"], correctAnswer: 0)
//        let findPair = findPairRandom.randomElement() ?? FindPairModule(question: "Default Question?", correctPairs: ["Author": "Work"])
//        let chronology = chronologyRandom.randomElement() ?? ChronologyModule(question: "Default Question?", events: [:])
//        
//        // Додавання випадкових модулів до списку модулів
//        modules = [
//            AnyGameModule(quiz),
//            AnyGameModule(findPair),
//            AnyGameModule(chronology)
//        ]
//    }
//
//    func shuffleModules() {
//        modules.shuffle()
//    }
//
//    func updateProgress() {
//        progress = Double(currentModuleIndex) / Double(modules.count)
//    }
//
//    func checkAnswer<AnswerType>(_ answer: AnswerType) -> Bool {
//        let currentModule = modules[currentModuleIndex]
//        let result = currentModule.checkAnswer(answer)
//        
//        if result {
//            showCorrectSheet = true
//        } else {
//            showIncorrectSheet = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                self.showIncorrectSheet = false
//            }
//        }
//        
//        return result
//    }
//
//    func completeModule() {
//        if currentModuleIndex < modules.count - 1 {
//            currentModuleIndex += 1
//        } else {
//            isGameFinished = true
//        }
//        updateProgress()
//    }
//
//    func checkOrder(eventList: [String]) -> Bool {
//        print("Checking Order with: \(eventList)")
//        let currentModule = modules[currentModuleIndex]
//        
//        if case .chronology(let chronologyModule) = currentModule.moduleType {
//            let correctOrder = chronologyModule.events.sorted { $0.key < $1.key }.map { $0.value }
//            
//            print("Correct Order: \(correctOrder)")
//            
//            return eventList == correctOrder
//        }
//        
//        return false
//    }
//}
