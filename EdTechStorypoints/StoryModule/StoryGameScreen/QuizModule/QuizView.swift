import SwiftUI

struct ProgressBarView: View {
    @Binding var progress: Double
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack(alignment: .center) {
                ProgressView(value: progress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(height: 10)
                LinearGradient(gradient: Gradient(colors: [.white, .cyan, .blue]), startPoint: .leading, endPoint: .trailing)
                    .mask(
                        ProgressView(value: progress, total: 1.0)
                            .progressViewStyle(LinearProgressViewStyle())
                            .frame(height: 10)
                    )
            }
            .animation(.linear(duration: 1.5), value: progress)
        }
    }
}


enum GameModuleType {
    case quiz(QuizModule)
    case findPair(FindPairModule)
    case chronology(ChronologyModule)
}

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
            return chronologyModule.checkAnswer(answer as! [String])
        }
    }
}



protocol GameModule {
    associatedtype AnswerType
    var question: String { get }
    var options: [String] { get }
    func checkAnswer(_ answer: AnswerType) -> Bool
}

struct QuizModule: GameModule {
    typealias AnswerType = Int
    
    var question: String
    var options: [String]
    var correctAnswer: Int
    
    func checkAnswer(_ answer: Int) -> Bool {
        return answer == correctAnswer
    }
}

struct FindPairModule: GameModule {
    typealias AnswerType = [String: String]
    
    var question: String
    var options: [String]
    var correctPairs: [String: String]
    
    func checkAnswer(_ answer: [String: String]) -> Bool {
        return answer == correctPairs
    }
}

struct ChronologyModule: GameModule {
    typealias AnswerType = [String]
    
    var question: String
    var options: [String]
    var correctOrder: [String]
    
    func checkAnswer(_ answer: [String]) -> Bool {
        return answer == correctOrder
    }
}


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
        let findPair = AnyGameModule(FindPairModule(question: "Знайдіть пари відомих авторів та їх творів", options: [], correctPairs: ["Шевченко": "Кобзар", "Франко": "Захар Беркут"]))
        let chronology = AnyGameModule(ChronologyModule(question: "Виберіть правильний порядок подій", options: [], correctOrder: ["Хрещення Русі", "Заснування Києва"]))
        
        modules = [quiz, findPair, chronology]
    }
    
    func shuffleModules() {
        modules.shuffle()
    }
    
    func updateProgress() {
        progress = Double(currentModuleIndex) / Double(modules.count)
    }
    
    func checkAnswer(_ answer: Any) -> Bool {
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



struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var selectedAnswer: Any? = nil
    let correctPhrases = [
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
    
    let incorrectPhrases = [
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
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        if viewModel.isGameFinished {
            PriceScreen()
        } else {
            let currentModule = viewModel.modules[viewModel.currentModuleIndex]
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
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .padding()
                Spacer()
                switch currentModule.moduleType {
                case .quiz(let quizModule):
                    QuizModuleView(quizModule: quizModule, selectedAnswer: $selectedAnswer)
                case .findPair(let findPairModule):
                    FindPairModuleView(findPairModule: findPairModule)
                case .chronology(let chronologyModule):
                    ChronologyModuleView(chronologyModule: chronologyModule)
                }
                Spacer()
                
                Button {
                    if let answer = selectedAnswer {
                        let isCorrect = viewModel.checkAnswer(answer)
                        viewModel.showCorrectSheet = isCorrect
                        if !isCorrect {
                            viewModel.showIncorrectSheet = true
                        }
                    }
                } label: {
                    CheckAnimationBTN()
                }
                .padding(.horizontal)
                
                Button("Next Random Module") {
                    viewModel.completeModule()
                    selectedAnswer = nil
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                BlueBackgroundAnimatedGradient()
            }
            .sheet(isPresented: $viewModel.showCorrectSheet) {
                HStack {
                    if let randomPhrase = correctPhrases.randomElement() {
                        Label(randomPhrase, systemImage: "face.smiling.inverse")
                            .foregroundColor(.green)
                            .padding()
                            .font(.headline)
                    }
                    Spacer()
                    Button("Next") {
                        viewModel.completeModule()
                        selectedAnswer = nil
                        viewModel.showCorrectSheet = false
                        viewModel.showIncorrectSheet = false
                        viewModel.updateProgress()
                    }
                    .padding()
                    .background(OrangeBackgroundAnimatedGradient())
                    .cornerRadius(20)
                    .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(BlueBackgroundAnimatedGradient())
                .presentationDetents([.fraction(0.15)])
            }
            .sheet(isPresented: $viewModel.showIncorrectSheet) {
                HStack(alignment: .center, spacing: 0) {
                    if let randomPhrase = incorrectPhrases.randomElement() {
                        Label(randomPhrase, systemImage: "xmark.octagon")
                            .foregroundColor(.red)
                            .font(.headline)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(BlueBackgroundAnimatedGradient())
                .presentationDetents([.fraction(0.15)])
            }
        }
    }
}

// Прев'ю
#Preview {
    GameView()
}

struct QuizModuleView: View {
    let quizModule: QuizModule
    @Binding var selectedAnswer: Any?
    
    var body: some View {
        VStack {
            Text(quizModule.question)
                .font(.title)
                .padding()
                .foregroundStyle(.accent)
            
            ForEach(quizModule.options.indices, id: \.self) { index in
                Button(action: {
                    selectedAnswer = index
                }) {
                    Text(quizModule.options[index])
                        .padding()
                        .background(selectedAnswer as? Int == index ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

// Окреме в'ю для FindPairModule
struct FindPairModuleView: View {
    let findPairModule: FindPairModule
    
    var body: some View {
        VStack {
            Text(findPairModule.question)
                .font(.title)
                .padding()
                .foregroundStyle(.accent)
            // Додати логіку для відображення пар
        }
    }
}

// Окреме в'ю для ChronologyModule
struct ChronologyModuleView: View {
    let chronologyModule: ChronologyModule
    
    var body: some View {
        VStack {
            Text(chronologyModule.question)
                .font(.title)
                .padding()
                .foregroundStyle(.accent)
            // Додати логіку для відображення подій у хронологічному порядку
        }
    }
}

#Preview {
    GameView()
}
