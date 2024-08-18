//import SwiftUI
//
//struct QuizTask: GameTask {
//  var taskType: TaskType = .quiz
//  var quiz: QuizModel
//  @Binding var isAnswerCorrect: Bool
//  @Binding var showCorrectSheet: Bool
//  @Binding var showIncorrectSheet: Bool
//  @Binding var selectedVariant: QuizVariants?
//  @State private var isSelected: Bool = false
//  func view(progress: Binding<Double>) -> some View {
//    VStack(spacing: 16) {
//      Text(quiz.question)
//        .font(.headline)
//        .padding()
//
//      if !quiz.image.isEmpty {
//        Image(quiz.image)
//          .resizable()
//          .aspectRatio(contentMode: .fit)
//          .frame(maxWidth: 200, maxHeight: 200)
//          .padding()
//      }
//
//        ForEach(quiz.variants, id: \.id) { variant in
//            Button(action: {
//              print("Button Pressed: \(variant.answer)")
//              selectedVariant = variant
//              isSelected.toggle()
//              print("Selected Variant: \(selectedVariant?.answer ?? "None")")
//            }) {
//              Text(variant.answer)
//                .frame(maxWidth: .infinity)
//                .padding()
//            }
//            .background(isSelected ? Color.blue : Color.green)
//            .cornerRadius(10)
//            .foregroundColor(.black)
//      }
//    }
//    .padding()
//  }
//}
//
//struct QuizModel: Identifiable {
//    let id: UUID = .init()
//    let question: String
//    let image: String
//    var variants: [QuizVariants]
//}
//
//struct QuizVariants: Identifiable, Equatable {
//    let id: UUID = .init()
//    let answer: String
//    var isCorrectAnswer: Bool
//}
//
//
//
//#Preview {
//    GameView()
//}
//
//
//struct ProgressBarView: View {
//    @Binding var progress: Double
//    
//    var body: some View {
//        VStack(alignment: .center, spacing: 0) {
//            ZStack(alignment: .center) {
//                ProgressView(value: progress, total: 1.0)
//                    .progressViewStyle(LinearProgressViewStyle())
//                    .frame(height: 10)
//                LinearGradient(gradient: Gradient(colors: [.white, .cyan, .blue]), startPoint: .leading, endPoint: .trailing)
//                    .mask(
//                        ProgressView(value: progress, total: 1.0)
//                            .progressViewStyle(LinearProgressViewStyle())
//                            .frame(height: 10)
//                    )
//            }
//            .animation(.linear(duration: 1.5), value: progress)
//        }
//    }
//}
//
//protocol GameFactory {
//    associatedtype ProgressTypeView: View
//    associatedtype ButtonTypeView: View
//    func makeProgressBarView(progress: Binding<Double>) -> ProgressTypeView
//    func makeButtonView(action: @escaping () -> Void) -> ButtonTypeView
//}
//
//extension GameFactory where ProgressTypeView == ProgressBarView {
//    func makeProgressBarView(progress: Binding<Double>) -> ProgressBarView {
//        ProgressBarView(progress: progress)
//    }
//}
//
//enum TaskType {
//    case quiz
//    case findPair
//    case wordPuzzle
//    case chronologicalOrder
//}
//
//protocol GameTask {
//    var taskType: TaskType { get }
//    associatedtype GameModuleView: View
//    func view(progress: Binding<Double>) -> GameModuleView
//}
//
//let correctPhrases = [
//    "Spot on! You're a genius!",
//    "Bullseye! Nailed it!",
//    "Boom! You're on fire!",
//    "Absolutely correct! Keep it up!",
//    "Crushed it! You're unstoppable!",
//    "You're on point! Great job!",
//    "Bingo! You've got it!",
//    "Right on the money! Well done!",
//    "Perfect! You hit the mark!",
//    "Bang! You're a rockstar!"
//]
//
//
//let incorrectPhrases = [
//    "Oops! Not quite right.",
//    "Close, but not correct.",
//    "Try again, you got this!",
//    "Don't worry, keep going!",
//    "Missed it, but you're learning!",
//    "No worries, everyone slips up!",
//    "Almost there, give it another shot!",
//    "Not your best, but keep at it!",
//    "Don't sweat it, try once more!",
//    "You'll get it next time!"
//]
//
//struct StartGameView<Factory: GameFactory>: View {
//    let factory: Factory
//    @Binding var progress: Double
//    @Binding var isAnswerCorrect: Bool
//    @Binding var showCorrectSheet: Bool
//    @Binding var showIncorrectSheet: Bool
//    @State private var tasks: [AnyView]
//    @State private var currentTaskIndex: Int = 0
//    @Binding var selectedVariant: QuizVariants?
//    @Environment(\.dismiss) private var dismiss
// 
//
//    init(factory: Factory, progress: Binding<Double>, isAnswerCorrect: Binding<Bool>, showCorrectSheet: Binding<Bool>, showIncorrectSheet: Binding<Bool>, selectedVariant: Binding<QuizVariants?>, tasks: [any GameTask]) {
//        self.factory = factory
//        self._progress = progress
//        self._isAnswerCorrect = isAnswerCorrect
//        self._showCorrectSheet = showCorrectSheet
//        self._showIncorrectSheet = showIncorrectSheet
//        self._selectedVariant = selectedVariant
//        _tasks = State(initialValue: tasks.shuffled().map { AnyView($0.view(progress: progress)) })
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//            if currentTaskIndex < tasks.count {
//                HStack(alignment: .center, spacing: 0) {
//                    Button {
//                        withAnimation(.smooth) {
//                            dismiss()
//                        }
//                    } label: {
//                        Image(systemName: "chevron.backward")
//                            .foregroundStyle(.white)
//                            .accessibilityLabel("Back Button to ARScreen")
//                    }
//                    .clipShape(Circle())
//                    .tint(Color.blue.opacity(0.1))
//                    .buttonStyle(.borderedProminent)
//                    
//                    factory.makeProgressBarView(progress: $progress)
//                        
//                }
//                .padding(.horizontal)
//                .frame(height: 50)
//                
//                tasks[currentTaskIndex]
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                
//                Spacer()
//                
//                factory.makeButtonView {
//                    checkAnswer()
//                }
//            } else {
//                PriceScreen()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
//        }
//        .configureNavigationBar()
//        .background(BlueBackgroundAnimatedGradient())
//        .sheet(isPresented: $showCorrectSheet) {
//            HStack {
//                if let randomPhrase = correctPhrases.randomElement() {
//                    Label(randomPhrase, systemImage: "face.smiling.inverse")
//                        .foregroundColor(.green)
//                        .padding()
//                        .font(.headline)
//                }
//                Spacer()
//                Button("Next") {
//                    showCorrectSheet = false
//
//                    withAnimation(.snappy) {
//                        currentTaskIndex += 1
//                    }
//                }
//                .padding()
//                .background(OrangeBackgroundAnimatedGradient())
//                .cornerRadius(20)
//                .foregroundColor(.white)
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(BlueBackgroundAnimatedGradient())
//            .presentationDetents([.fraction(0.15)])
//        }
//        .sheet(isPresented: $showIncorrectSheet) {
//            HStack(alignment: .center, spacing: 0) {
//                if let randomPhrase = incorrectPhrases.randomElement() {
//                    Label(randomPhrase, systemImage: "xmark.octagon")
//                        .foregroundColor(.red)
//                        .font(.headline)
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(BlueBackgroundAnimatedGradient())
//            .presentationDetents([.fraction(0.15)])
//        }
//    }
//    
//    private func checkAnswer() {
//        if let selectedVariant = selectedVariant {
//            if selectedVariant.isCorrectAnswer {
//                isAnswerCorrect = true
//                showCorrectSheet = true
//            } else {
//                isAnswerCorrect = false
//                showIncorrectSheet = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                    showIncorrectSheet = false
//                }
//            }
//        }
//    }
//}
//
//struct GameView: View {
//    @State private var progress: Double = 0.0
//    @State private var isAnswerCorrect: Bool = false
//    @State private var showCorrectSheet: Bool = false
//    @State private var showIncorrectSheet: Bool = false
//    @State private var selectedVariant: QuizVariants?
//    var body: some View {
//        StartGameView(
//            factory: MyGameFactory(progress: $progress),
//            progress: $progress,
//            isAnswerCorrect: $isAnswerCorrect,
//            showCorrectSheet: $showCorrectSheet,
//            showIncorrectSheet: $showIncorrectSheet, selectedVariant: $selectedVariant,
//            tasks: [
//                QuizTask(
//                    quiz: QuizModel(
//                        question: "Кто зображений на фото?",
//                        image: "BohdanKhmelnytsky",
//                        variants: [
//                            QuizVariants(answer: "Bohdan Khmelnytsky", isCorrectAnswer: true),
//                            QuizVariants(answer: "Ivan Mazepa", isCorrectAnswer: false),
//                            QuizVariants(answer: "Taras Shevchenko", isCorrectAnswer: false),
//                            QuizVariants(answer: "Yaroslav the Wise", isCorrectAnswer: false)
//                        ]
//                    ),
//                    isAnswerCorrect: $isAnswerCorrect,
//                    showCorrectSheet: $showCorrectSheet,
//                    showIncorrectSheet: $showIncorrectSheet, selectedVariant: $selectedVariant
//                ),
//                FindPairTask(
//                    isAnswerCorrect: $isAnswerCorrect,
//                    showCorrectSheet: $showCorrectSheet,
//                    showIncorrectSheet: $showIncorrectSheet
//                )
//            ]
//        )
//    }
//}
//
//struct MyGameFactory: GameFactory {
//    @Binding var progress: Double
//
//    func makeProgressBarView(progress: Binding<Double>) -> some View {
//        ProgressBarView(progress: progress)
//    }
//
//    func makeButtonView(action: @escaping () -> Void) -> some View {
//        Button {
//            action()
//        } label: {
//            CheckAnimationBTN()
//        }
//    }
//}
//
//struct FindPairTask: GameTask {
//    var taskType: TaskType = .findPair
//    @Binding var isAnswerCorrect: Bool
//    @Binding var showCorrectSheet: Bool
//    @Binding var showIncorrectSheet: Bool
//    func view(progress: Binding<Double>) -> some View {
//        Button {
//            isAnswerCorrect = true
//        } label: {
//            Text("Find Pair Task")
//        }
//
//        
//    }
//}
//
//struct ChronologicalOrderTask: GameTask {
//    var taskType: TaskType = .chronologicalOrder
//    func view(progress: Binding<Double>) -> some View {
//        Text("Chronological Order Task")
//    }
//}
//
//
//#Preview {
//    GameView()
//}
