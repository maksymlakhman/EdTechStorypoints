import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var selectedAnswer: Any? = nil
    @State private var selectedPairs: [String: String] = [:]
    @State private var events: [String: String] = [
        "1798": "Тарас Шевченко публікує 'Кобзар'",
        "1867": "Іван Франко публікує 'Захар Беркут'",
        "1934": "Перший конгрес письменників України",
        "1991": "Проголошення незалежності України"
    ]

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
                    FindPairModuleView(findPairModule: findPairModule, selectedPairs: $selectedPairs)
                case .chronology(let chronologyModule):
                    ChronologyModuleView(
                        chronologyModule: chronologyModule,
                        eventList: $viewModel.eventList // Pass the eventList binding here
                    )
                    .environmentObject(viewModel)
                }
                
                Spacer()
                
                Button {
                    var answer: Any? = nil
                    
                    switch currentModule.moduleType {
                    case .quiz:
                        answer = selectedAnswer as? Int
                    case .findPair:
                        answer = selectedPairs
                    case .chronology:
                        answer = events.sorted(by: { $0.key < $1.key }).map { $0.value }
                    }
                    
                    print("Current Module: \(currentModule.moduleType)")
                    print("Answer: \(String(describing: answer))")
                    
                    if let answer = answer {
                        if case .chronology = currentModule.moduleType {
                            viewModel.checkOrder(eventList: viewModel.eventList)
                        } else {
                            let isCorrect = viewModel.checkAnswer(answer)

                            print("Is Correct: \(isCorrect)")
                            
                            if isCorrect {
                                viewModel.showCorrectSheet = true
                            } else {
                                viewModel.showIncorrectSheet = true
                            }
                        }
                    }
                } label: {
                    CheckAnimationBTN()
                }
                .padding(.horizontal)
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
                        viewModel.showCorrectSheet = false
                        viewModel.showIncorrectSheet = false
                        viewModel.updateProgress()
                        selectedAnswer = nil
                        selectedPairs = [:]
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
