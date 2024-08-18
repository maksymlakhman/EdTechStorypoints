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

enum TaskType {
    case quiz
    case findPair
    case chronology
}

// Описуємо самі завдання
struct Task: Identifiable {
    let id = UUID()
    let type: TaskType
    let question: String
    let image: String?
    let options: [String]
    let correctAnswer: Int
}

class GameViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var currentTaskIndex: Int = 0
    @Published var isAnswerCorrect: Bool = false
    @Published var isCheckButtonActive: Bool = true
    @Published var isNextButtonActive: Bool = false
    @Published var showCorrectSheet = false
    @Published var showIncorrectSheet = false
    @Published var progress: Double = 0.0
    @Published var isGameFinished = false
    
    init() {
        loadTasks()
        shuffleTasks()
        progress = 0.0
    }
    
    func loadTasks() {
        tasks = [
            Task(
                type: .quiz,
                question: "Who is depicted in the photo?",
                image: "BohdanKhmelnytsky",
                options: [
                    "Bohdan Khmelnytsky",
                    "Ivan Mazepa",
                    "Taras Shevchenko",
                    "Petro Konashevych-Sahaidachny"
                ],
                correctAnswer: 0
            ),
            Task(
                type: .findPair,
                question: "Знайдіть пари відомих авторів та їх творів",
                image: nil,
                options: [
                    "Шевченко - Кобзар",
                    "Франко - Захар Беркут"
                ],
                correctAnswer: 0
            ),
            Task(
                type: .chronology,
                question: "Виберіть правильний порядок подій",
                image: nil,
                options: [
                    "Хрещення Русі",
                    "Заснування Києва"
                ],
                correctAnswer: 0
            )
        ]
    }
    
    func shuffleTasks() {
        tasks.shuffle()
    }
    
    func updateProgress() {
        progress = Double(currentTaskIndex) / Double(tasks.count)
    }
    
    func checkAnswer(selectedAnswer: Int, completion: @escaping () -> Void) {
        let correctAnswer = tasks[currentTaskIndex].correctAnswer
        if selectedAnswer == correctAnswer {
            isAnswerCorrect = true
            isNextButtonActive = true
            showCorrectSheet.toggle()
        } else {
            isAnswerCorrect = false
            showIncorrectSheet = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                completion()
                self.showIncorrectSheet = false
            }
        }
        isCheckButtonActive = false
    }
    
    func completeTask() {
        if currentTaskIndex < tasks.count - 1 {
            currentTaskIndex += 1
            isAnswerCorrect = false
            updateProgress() // Оновлюємо прогрес після завершення завдання
        } else {
            isGameFinished = true
        }
    }
}



struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var selectedAnswer: Int? = nil
    
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
                    ProgressBarView(progress: $viewModel.progress)
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .padding()
                
                Spacer()
                VStack {
                    if viewModel.currentTaskIndex < viewModel.tasks.count {
                        let currentTask = viewModel.tasks[viewModel.currentTaskIndex]
                        TaskView(task: currentTask, selectedAnswer: $selectedAnswer)
                            .padding()
                        Spacer()
                        Button {
                            if let answer = selectedAnswer {
                                viewModel.checkAnswer(selectedAnswer: answer) {
                                    selectedAnswer = nil
                                }
                            }
                        } label: {
                            CheckAnimationBTN()
                        }
                        .padding(.horizontal)
                    } else {
                        PriceScreen()
                    }
                }
                .padding(.top)
                
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
                        viewModel.completeTask()
                        selectedAnswer = nil
                        viewModel.showCorrectSheet = false
                        viewModel.showIncorrectSheet = false
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


struct TaskView: View {
    let task: Task
    @Binding var selectedAnswer: Int?
    
    var body: some View {
        VStack {
            switch task.type {
            case .quiz:
                QuizTaskView(task: task, selectedAnswer: $selectedAnswer)
            case .findPair:
                FindPairTaskView(task: task)
            case .chronology:
                ChronologyTaskView(task: task)
            }
        }
    }
}



struct FindPairTaskView: View {
    let task: Task
    
    var body: some View {
        // Реалізація для знаходження пар
        Text("Find Pair Task View")
    }
}

struct ChronologyTaskView: View {
    let task: Task
    
    var body: some View {
        // Реалізація для завдання на хронологію
        Text("Chronology Task View")
    }
}



struct QuizTaskView: View {
    let task: Task
    @Binding var selectedAnswer: Int?
    
    var body: some View {
        VStack {
            if task.image != nil {
                Image(task.image ?? "")
                    .resizable()
                    .scaledToFit()
            }
            Text(task.question)
                .font(.title)
                .padding()
                .foregroundStyle(.accent)
            
            ForEach(0..<task.options.count, id: \.self) { index in
                HStack(spacing: 0) {
                    if selectedAnswer != index {
                        Text(self.variantForOption(at: index))
                            .padding(10)
                            .background(self.colorForOption(at: index).opacity(0.8))
                            .foregroundColor(selectedAnswer == index ? .white : .black)
                            .cornerRadius(10)
                    }
                    Button {
                        selectedAnswer = index
                    } label: {
                        Text(task.options[index])
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedAnswer == index ? self.colorForOption(at: index) : Color.white.opacity(0.7))
                            .foregroundColor(selectedAnswer == index ? .white : .black)
                            .cornerRadius(10)
                            .scaleEffect(selectedAnswer == index ? 1.0 : 0.97, anchor: .bottomTrailing)
                            .font(.subheadline)
                    }
                }
            }
        }
    }
    
    private func colorForOption(at index: Int) -> Color {
        switch index {
        case 0:
            return .pink
        case 1:
            return .cyan
        case 2:
            return .purple
        case 3:
            return .orange
        default:
            return .gray
        }
    }
    
    private func variantForOption(at index: Int) -> String {
        switch index {
        case 0:
            return "A"
        case 1:
            return "B"
        case 2:
            return "C"
        case 3:
            return "D"
        default:
            return ""
        }
    }
}

// Прев'ю
#Preview {
    GameView()
}
