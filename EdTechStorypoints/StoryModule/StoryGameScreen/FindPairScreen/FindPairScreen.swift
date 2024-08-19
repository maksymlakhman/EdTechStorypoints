//import SwiftUI
//
//
//protocol GameModule {
//    associatedtype AnswerType
//    var question: String { get }
//    var options: [String] { get }
//    func checkAnswer(_ answer: AnswerType) -> Bool
//}
//
//
//
//struct QuizModule: GameModule {
//    typealias AnswerType = Int
//    
//    var question: String
//    var options: [String]
//    var correctAnswer: Int
//    
//    func checkAnswer(_ answer: Int) -> Bool {
//        return answer == correctAnswer
//    }
//}
//
//
//struct FindPairModule: GameModule {
//    typealias AnswerType = [String: String]
//    
//    var question: String
//    var options: [String]
//    var correctPairs: [String: String]
//    
//    func checkAnswer(_ answer: [String: String]) -> Bool {
//        return answer == correctPairs
//    }
//}
//
//
//struct ChronologyModule: GameModule {
//    typealias AnswerType = [String]
//    
//    var question: String
//    var options: [String]
//    var correctOrder: [String]
//    
//    func checkAnswer(_ answer: [String]) -> Bool {
//        return answer == correctOrder
//    }
//}
//
//
//struct AnyGameModule {
//    private let _question: () -> String
//    private let _options: () -> [String]
//    private let _checkAnswer: (Any) -> Bool
//    
//    var question: String {
//        _question()
//    }
//    
//    var options: [String] {
//        _options()
//    }
//    
//    init<M: GameModule>(_ module: M) {
//        _question = { module.question }
//        _options = { module.options }
//        _checkAnswer = { answer in
//            guard let typedAnswer = answer as? M.AnswerType else { return false }
//            return module.checkAnswer(typedAnswer)
//        }
//    }
//    
//    func checkAnswer(_ answer: Any) -> Bool {
//        return _checkAnswer(answer)
//    }
//}
//
//
//
//class GameViewModel: ObservableObject {
//    @Published var modules: [AnyGameModule] = []
//    @Published var currentModuleIndex: Int = 0
//    @Published var progress: Double = 0.0
//    @Published var isGameFinished = false
//    
//    init() {
//        loadModules()
//        shuffleModules()
//    }
//    
//    func loadModules() {
//        let quiz = AnyGameModule(QuizModule(question: "Who is depicted in the photo?", options: ["Bohdan Khmelnytsky", "Ivan Mazepa", "Taras Shevchenko", "Petro Konashevych-Sahaidachny"], correctAnswer: 0))
//        let findPair = AnyGameModule(FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", options: [], correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]))
//        let chronology = AnyGameModule(ChronologyModule(question: "Виберіть правильний порядок подій", options: [], correctOrder: ["Хрещення Русі", "Заснування Києва"]))
//        
//        modules = [quiz, findPair, chronology]
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
//    func checkAnswer(_ answer: Any) -> Bool {
//        let currentModule = modules[currentModuleIndex]
//        let result = currentModule.checkAnswer(answer)
//        if result {
//            completeModule()
//        }
//        return result
//    }
//    
//    func completeModule() {
//        if currentModuleIndex < modules.count - 1 {
//            currentModuleIndex += 1
//            updateProgress()
//        } else {
//            isGameFinished = true
//        }
//    }
//}
//
//struct GameView: View {
//    @StateObject private var viewModel = GameViewModel()
//    @State private var selectedAnswer: Any? = nil
//    
//    var body: some View {
//        if viewModel.isGameFinished {
//            Text("Game Finished")
//                .font(.largeTitle)
//                .foregroundColor(.green)
//        } else {
//            let currentModule = viewModel.modules[viewModel.currentModuleIndex]
//            VStack {
//                Text(currentModule.question)
//                    .font(.headline)
//                
//                // Відображення опцій та вибору відповіді для поточного модуля
//                ForEach(currentModule.options.indices, id: \.self) { index in
//                    Button(action: {
//                        selectedAnswer = index
//                    }) {
//                        Text(currentModule.options[index])
//                            .padding()
//                            .background(selectedAnswer as? Int == index ? Color.blue : Color.gray)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                }
//                
//                Button("Check Answer") {
//                    if let answer = selectedAnswer {
//                        if viewModel.checkAnswer(answer) {
//                            selectedAnswer = nil // Скидаємо вибір після успішного проходження модуля
//                        }
//                    }
//                }
//                .padding()
//                .background(Color.green)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//                
//                // Додаємо кнопку переходу до іншого випадкового модуля
//                Button("Next Random Module") {
//                    viewModel.shuffleModules()
//                    viewModel.currentModuleIndex = 0 // Перехід до першого (випадкового) модуля після перемішування
//                }
//                .padding()
//                .background(Color.orange)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
//            .padding()
//        }
//    }
//}
//
//
//
//#Preview {
//    GameView()
//}
