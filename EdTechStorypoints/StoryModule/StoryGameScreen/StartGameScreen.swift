import SwiftUI

protocol GameTask {
    var id: UUID { get }
    var taskType: TaskType { get }
    func view(progress: Binding<Double>, onNext: @escaping () -> Void) -> AnyView
    func checkAnswer(_ answer: Any) -> Bool
}

enum TaskType {
    case quiz
    case findPair
    case wordPuzzle
    case chronologicalOrder
}

struct GameModule {
    var tasks: [GameTask]
    
    init(tasks: [GameTask]) {
        self.tasks = tasks.shuffled()
    }
}

struct GameView: View {
    @State private var currentTaskIndex = 0
    @State private var progress: Double = 0.0
    
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
    
    @State private var gameModule: GameModule
    
    init() {
        let tasks: [GameTask] = [
            QuizScreen(question: "Who is depicted in the photo?", image: "book", options: ["Bohdan Khmelnytsky", "Ivan Mazepa", "Taras Shevchenko", "Petro Konashevych-Sahaidachny"], correctAnswerIndex: 0, correctPhrases: correctPhrases, incorrectPhrases: incorrectPhrases),
            FindPairScreen(pairs: [("Кіт", "Кішка"), ("Собака", "Пес")], correctPhrases: correctPhrases, incorrectPhrases: incorrectPhrases),
            ChronologicalOrderTask(items: ["Перший", "Другий", "Третій"], correctPhrases: correctPhrases, incorrectPhrases: incorrectPhrases),
            WordPuzzleTask(word: "КОД", correctPhrases: correctPhrases, incorrectPhrases: incorrectPhrases)
        ]
        
        _gameModule = State(initialValue: GameModule(tasks: tasks))
    }
    

    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            LazyVStack {
                HStack(alignment: .top) {
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
                    ZStack {
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
                    .animation(.smooth(duration: 1.5), value: progress)
                }
                .padding(.horizontal)

                if currentTaskIndex < gameModule.tasks.count {
                    let task = gameModule.tasks[currentTaskIndex]
                    task.view(progress: $progress) {
                        moveToNextTask()
                    }
                }
            }
            .navigationBarHidden(true)
            .configureNavigationBar()
            .navigationTitle("Module Name")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
        }
    }
    
    private func moveToNextTask() {
        let taskCount = Double(gameModule.tasks.count)
        
        if currentTaskIndex < gameModule.tasks.count - 1 {
            currentTaskIndex += 1
            progress = Double(currentTaskIndex) / taskCount
        } else {
            progress = 1.0
            dismiss()
        }
    }
}



struct ChronologicalOrderTask: GameTask {
    let id = UUID()
    let items: [String]
    let correctPhrases: [String]
    let incorrectPhrases: [String]
    var taskType: TaskType {
        return .chronologicalOrder
    }
    
    func view(progress: Binding<Double>, onNext: @escaping () -> Void) -> AnyView {
        AnyView(
            ChronologicalOrderTaskView(
                items: items,
                correctPhrases: correctPhrases,
                incorrectPhrases: incorrectPhrases,
                onNext: onNext
            )
        )
    }
    
    func checkAnswer(_ answer: Any) -> Bool {
        // Логіка для перевірки правильної відповіді
        return true
    }
}

struct ChronologicalOrderTaskView: View {
    let items: [String]
    let correctPhrases: [String]
    let incorrectPhrases: [String]
    let onNext: () -> Void
    @State private var orderedItems: [String]
    
    init(items: [String], correctPhrases: [String] , incorrectPhrases: [String], onNext: @escaping () -> Void) {
        self.items = items
        self.correctPhrases = correctPhrases
        self.incorrectPhrases = incorrectPhrases
        self.onNext = onNext
        _orderedItems = State(initialValue: items)
    }
    
    var body: some View {
        VStack {
            Text("Складіть елементи в правильному порядку")
                .font(.headline)
                .padding()
            
            List {
                ForEach(orderedItems.indices, id: \.self) { index in
                    TextField("Елемент", text: $orderedItems[index])
                }
            }
            .padding()
            
            Button("Перевірити") {
                if checkAnswer() {
                    onNext()
                } else {
                    // Show incorrect answer feedback
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    private func checkAnswer() -> Bool {
        // Your logic to check if the items are in the correct order
        return orderedItems == items
    }
}

struct WordPuzzleTask: GameTask {
    let id = UUID()
    let word: String
    let correctPhrases: [String]
    let incorrectPhrases: [String]
    var taskType: TaskType {
        return .wordPuzzle
    }
    
    func view(progress: Binding<Double>, onNext: @escaping () -> Void) -> AnyView {
        AnyView(
            WordPuzzleTaskView(
                word: word,
                correctPhrases: correctPhrases,
                incorrectPhrases: incorrectPhrases,
                onNext: onNext
            )
        )
    }
    
    func checkAnswer(_ answer: Any) -> Bool {
        // Логіка для перевірки правильної відповіді
        return true
    }
}

struct WordPuzzleTaskView: View {
    let word: String
    let correctPhrases: [String]
    let incorrectPhrases: [String]
    let onNext: () -> Void
    
    @State private var userGuess = ""
    
    var body: some View {
        VStack {
            Text("Розгадати слово")
                .font(.headline)
                .padding()
            
            TextField("Введіть слово", text: $userGuess)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Перевірити") {
                if checkAnswer() {
                    onNext()
                } else {
                    // Show incorrect answer feedback
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    private func checkAnswer() -> Bool {
        return userGuess.lowercased() == word.lowercased()
    }
}



#Preview {
    GameView()
}

