import SwiftUI

// Протокол для модулів гри
protocol GameModule {
    associatedtype AnswerType
    var question: String { get }
    func checkAnswer(_ answer: AnswerType) -> Bool
}

// Реалізація модуля Quiz
struct QuizModule: GameModule {
    typealias AnswerType = Int
    
    var question: String
    var image: String
    var options: [String]
    var correctAnswer: Int
    
    func checkAnswer(_ answer: AnswerType) -> Bool {
        return answer == correctAnswer
    }
}

// Реалізація модуля FindPair
struct FindPairModule: GameModule {
    typealias AnswerType = [String: String]
    
    var question: String
    var correctPairs: AnswerType
    
    func checkAnswer(_ answer: AnswerType) -> Bool {
        return answer == correctPairs
    }
}

// Реалізація модуля Chronology
struct ChronologyModule: GameModule {
    typealias AnswerType = [String: String]
    
    var question: String
    var events: AnswerType
    
    func checkAnswer(_ answer: AnswerType) -> Bool {
        return answer == events
    }
}

// Перерахування типів модулів гри
enum GameModuleType: Equatable {
    case quiz(QuizModule)
    case findPair(FindPairModule)
    case chronology(ChronologyModule)
    
    static func ==(lhs: GameModuleType, rhs: GameModuleType) -> Bool {
        switch (lhs, rhs) {
        case (.quiz(let lhsModule), .quiz(let rhsModule)):
            return lhsModule.question == rhsModule.question &&
                   lhsModule.image == rhsModule.image &&
                   lhsModule.options == rhsModule.options &&
                   lhsModule.correctAnswer == rhsModule.correctAnswer
        case (.findPair(let lhsModule), .findPair(let rhsModule)):
            return lhsModule.question == rhsModule.question &&
                   lhsModule.correctPairs == rhsModule.correctPairs
        case (.chronology(let lhsModule), .chronology(let rhsModule)):
            return lhsModule.question == rhsModule.question &&
                   lhsModule.events == rhsModule.events
        default:
            return false
        }
    }
}

// Клас для зберігання будь-якого модуля гри
struct AnyGameModule {
    let moduleType: GameModuleType
    
    init(_ quizModule: QuizModule) {
        self.moduleType = .quiz(quizModule)
    }
    
    init(_ findPairModule: FindPairModule) {
        self.moduleType = .findPair(findPairModule)
    }
    
    init(_ chronologyModule: ChronologyModule) {
        self.moduleType = .chronology(chronologyModule)
    }
    
    func checkAnswer(_ answer: Any) -> Bool {
        switch moduleType {
        case .quiz(let quizModule):
            return quizModule.checkAnswer(answer as! Int)
        case .findPair(let findPairModule):
            return findPairModule.checkAnswer(answer as! [String: String])
        case .chronology(let chronologyModule):
            return chronologyModule.checkAnswer(answer as! [String: String])
        }
    }
}

class GameViewModel: ObservableObject {
    @Published var modules: [AnyGameModule]
    @Published var showCorrectSheet = false
    @Published var showIncorrectSheet = false
    @Published var currentModule: AnyGameModule
    @Published var userAnswer: Any?
    @Published var isGameFinished = false
    private var currentModuleIndex: Int = 0
    @Published var progress: Double = 0.0
    
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
    
    init() {
        // Инициализируй свойства
        let loadedModules = GameViewModel.loadModules()
        self.modules = loadedModules
        
        // Установи currentModule после инициализации modules
        self.currentModule = loadedModules.first ?? AnyGameModule(QuizModule(question: "", image: "", options: [], correctAnswer: 0))
    }
    
    private static func loadModules() -> [AnyGameModule] {
        return [
            AnyGameModule(QuizModule(
                question: "Which is the largest continent?",
                image: "continent_image",
                options: ["Africa", "Asia", "Europe", "America"],
                correctAnswer: 1
            )),
            AnyGameModule(FindPairModule(
                question: "Match the authors to their works",
                correctPairs: ["Author1": "Work1", "Author2": "Work2"]
            )),
            AnyGameModule(ChronologyModule(
                question: "Place these events in chronological order",
                events: ["Event1": "Year1", "Event2": "Year2"]
            ))
        ]
    }

    
    func viewModelForModule() -> Any? {
        switch currentModule.moduleType {
        case .quiz(let module):
            return QuizViewModel(module: module)
        case .findPair(let module):
            return FindPairViewModel(module: module)
        case .chronology(let module):
            return ChronologyViewModel(module: module)
        }
    }
    
    func checkAnswer() -> Bool {
        switch currentModule.moduleType {
        case .quiz(_):
            return (viewModelForModule() as? QuizViewModel)?.checkAnswer() ?? false
        case .findPair(_):
            return (viewModelForModule() as? FindPairViewModel)?.checkAnswer() ?? false
        case .chronology(_):
            return (viewModelForModule() as? ChronologyViewModel)?.checkAnswer() ?? false
        }
    }
    
    func nextModule() {
        if currentModuleIndex < modules.count - 1 {
            currentModuleIndex += 1
            currentModule = modules[currentModuleIndex]
        } else {
            isGameFinished = true
        }
    }

    
    func restartGame() {
        self.modules.shuffle()
        self.currentModuleIndex = 0
        self.currentModule = self.modules.first ?? AnyGameModule(QuizModule(question: "", image: "", options: [], correctAnswer: 0))
    }
    
    func updateProgress() {
        DispatchQueue.main.async {
            withAnimation(.linear(duration: 1.5)) {
                self.progress += 0.1
            }
        }
    }
}



struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var showFreemiumSheet = false
    @State private var freemiumIsActive = false
    @State private var isFirstAIAssistantIsUser = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            if viewModel.isGameFinished {
                PriceScreen()
                    .environmentObject(viewModel)
            } else {
                VStack(spacing: 0) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundStyle(.white)
                                .contentTransition(.symbolEffect(.replace.upUp.byLayer))
                                .accessibilityLabel("Back Button to ARScreen")
                        }
                        .clipShape(Circle())
                        .tint(Color.blue.opacity(0.1))
                        .buttonStyle(.borderedProminent)
    
                        Spacer()
    
                        ProgressBarView(progress: $viewModel.progress)
                        
                        Spacer()
                        
                        HStack() {
                            Button {
                                if isFirstAIAssistantIsUser {
                                    // Ваш код
                                } else {
                                    showFreemiumSheet = true
                                }
                            } label: {
                                Image("CossackLarge")
                                    .resizable()
                                    .frame(width: 40)
                            }

                            Button {
                                print("AI 2")
                            } label: {
                                Image("CossackLong")
                                    .resizable()
                                    .frame(width: 40)
                            }
                            .disabled(!freemiumIsActive)
                            .opacity(freemiumIsActive ? 1.0 : 0.5)

                            Button {
                                print("AI 3")
                            } label: {
                                Image("CossackSmall")
                                    .resizable()
                                    .frame(width: 40)
                            }
                            .disabled(!freemiumIsActive)
                            .opacity(freemiumIsActive ? 1.0 : 0.5)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .padding()
                    Spacer()
                    switch viewModel.currentModule.moduleType {
                    case .quiz(let module):
                        QuizView()
                            .environmentObject(QuizViewModel(module: module))
                    case .findPair(let module):
                        FindPairView()
                            .environmentObject(FindPairViewModel(module: module))
                    case .chronology(let module):
                        ChronologyView()
                            .environmentObject(ChronologyViewModel(module: module))
                    }
                    
                    Spacer()
                    Button("Check") {
                        let isCorrect = viewModel.checkAnswer()
                        if isCorrect {
                            viewModel.showCorrectSheet = true
                        } else {
                            viewModel.showIncorrectSheet = true
                        }
                    }
                }
                .sheet(isPresented: $showFreemiumSheet) {
                    VStack {
                        Text("Купити додаткові 2 AI асистенти?")
                            .padding()
                        
                        Button {
                            freemiumIsActive = true
                            showFreemiumSheet = false
                        } label: {
                            Label("Buy", systemImage: "brain.fill")
                                .foregroundStyle(.black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.yellow)
                                )
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue)
                    .presentationDetents([.fraction(0.15)])
                }
                .sheet(isPresented: $viewModel.showCorrectSheet) {
                    HStack {
                        if let randomPhrase = viewModel.correctPhrases.randomElement() {
                            Label(randomPhrase, systemImage: "face.smiling.inverse")
                                .foregroundColor(.green)
                                .padding()
                                .font(.headline)
                        }
                        Spacer()
                        Button("Next") {
                            viewModel.nextModule()
                            viewModel.showCorrectSheet = false
                            viewModel.showIncorrectSheet = false
                            viewModel.updateProgress()
                        }
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue)
                    .presentationDetents([.fraction(0.15)])
                }
                .sheet(isPresented: $viewModel.showIncorrectSheet) {
                    HStack(alignment: .center, spacing: 0) {
                        if let randomPhrase = viewModel.incorrectPhrases.randomElement() {
                            Label(randomPhrase, systemImage: "xmark.octagon")
                                .foregroundColor(.red)
                                .font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue)
                    .presentationDetents([.fraction(0.15)])
                }
            }
        }

    }
}



// View для Quiz
struct QuizView: View {
    @EnvironmentObject var viewModel: QuizViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.module.question)
                .font(.title2)
                .padding()
            
            ForEach(0..<viewModel.module.options.count, id: \.self) { index in
                Button(action: {
                    viewModel.userAnswer = index
                }) {
                    Text(viewModel.module.options[index])
                        .padding()
                        .background(viewModel.userAnswer == index ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(8)
                        .foregroundColor(.black)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// ViewModel для Quiz
class QuizViewModel: ObservableObject {
    @Published var userAnswer: Int?
    let module: QuizModule
    
    init(module: QuizModule) {
        self.module = module
    }
    
    func checkAnswer() -> Bool {
//        guard let userAnswer = userAnswer else { return false }
//        return module.checkAnswer(userAnswer)
        return true
    }
}

// View для FindPair
struct FindPairView: View {
    @EnvironmentObject var viewModel: FindPairViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text(viewModel.module.question)
            // Ваша логіка для FindPairView
            Button {
                dismiss()
            } label: {
                Image(systemName: "house")
            }
        }
    }
}

// ViewModel для FindPair
class FindPairViewModel: ObservableObject {
    @Published var userPairs: [String: String] = [:]
    let module: FindPairModule
    
    init(module: FindPairModule) {
        self.module = module
    }
    
    func checkAnswer() -> Bool {
//        return module.checkAnswer(userPairs)
        return true
    }
}

// View для Chronology
struct ChronologyView: View {
    @EnvironmentObject var viewModel: ChronologyViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text(viewModel.module.question)
            // Ваша логіка для ChronologyView
            Button {
                dismiss()
            } label: {
                Image(systemName: "house")
            }
        }
    }
}

// ViewModel для Chronology
class ChronologyViewModel: ObservableObject {
    @Published var userEvents: [String: String] = [:]
    let module: ChronologyModule
    
    init(module: ChronologyModule) {
        self.module = module
    }
    
    func checkAnswer() -> Bool {
//        return module.checkAnswer(userEvents)
        return true
    }
}

#Preview {
    GameView()
}
