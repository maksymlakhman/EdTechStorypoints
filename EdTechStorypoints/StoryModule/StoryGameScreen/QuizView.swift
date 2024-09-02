import SwiftUI

struct QuizView: View {
    @EnvironmentObject var quizVM: QuizViewModel
    
    var body: some View {
        VStack {
            Image(quizVM.module.image)
                .resizable()
                .scaledToFit()
                .frame(height: UIScreen.main.bounds.height / 3)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(quizVM.module.question)
                .font(.headline)
                .padding()
                .foregroundStyle(.accent)
            
            ForEach(0..<quizVM.module.options.count, id: \.self) { index in
                Button {
                    print("Button tapped for option \(index): \(quizVM.module.options[index])")
                    withAnimation(.smooth) {
                        quizVM.userAnswer = index
                    }
                    
                    print("User answer updated to: \(quizVM.userAnswer ?? -1)")
                } label: {
                    HStack {
                        Text(textForIndex(index))
                            .font(.headline)
                            .foregroundColor(quizVM.userAnswer == index ? colorForIndex(index) : Color.white)
                            .padding(10)
                            .background {
                                Circle()
                                    .fill(quizVM.userAnswer == index ? .white : .blue)
                            }
                        Text(quizVM.module.options[index])
                            .padding()
                            .foregroundColor(quizVM.userAnswer == index ? .white : colorForIndex(index))
                            .bold()
                        Spacer()
                        Button {
                            withAnimation(.spring) {
                                quizVM.showSmallPlayer = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation(.smooth) {
                                        quizVM.showSmallPlayer = false
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: quizVM.userAnswer == index ? "music.note" : "")
                                .foregroundColor(quizVM.userAnswer == index ? colorForIndex(index) : Color.white)
                                .contentTransition(.symbolEffect(.replace))
                                .padding(quizVM.userAnswer == index ? 10 : 0)
                                .background {
                                    Circle()
                                        .fill(quizVM.userAnswer == index ? .white : .blue)
                                }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .background {
                    Capsule()
                        .fill(quizVM.userAnswer == index ? colorForIndex(index) : Color.white.opacity(0.1))
                }
                .padding(.horizontal)
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $quizVM.showSmallPlayer){
            VStack {
                Text("Player")
            }
            .presentationDetents([.fraction(0.2)])
        }
    }
    
    func colorForIndex(_ index: Int) -> Color {
        switch index {
        case 0: return .purple
        case 1: return .pink
        case 2: return .cyan
        case 3: return .orange
        default: return .gray
        }
    }
    
    func textForIndex(_ index: Int) -> String {
        switch index {
        case 0: return "A"
        case 1: return "B"
        case 2: return "C"
        case 3: return "D"
        default: return "Empty"
        }
    }
}

class QuizViewModel: ObservableObject {
    @Published var userAnswer: Int?
    @Published var showSmallPlayer = false
    let module: QuizModuleProtocol
    var checkAnswerAction: ((Int) -> Bool)?
    
    
    init(module: QuizModuleProtocol) {
        self.module = module
        print("QuizViewModel initialized with module: \(module)")
        
        self.checkAnswerAction = { [weak self] answer in
            let isCorrect = self?.module.correctAnswer == answer
            print("CheckAnswerAction called with answer: \(answer), correct answer: \(self?.module.correctAnswer ?? -1), is correct: \(isCorrect)")
            return isCorrect
        }
    }
    
    func checkAnswer() -> Bool {
        guard let answer = userAnswer else {
            print("No user answer selected")
            return false
        }
        let isCorrect = checkAnswerAction?(answer) ?? false
        print("Checking answer: \(answer), Correct: \(isCorrect)")
        return isCorrect
    }
    
}


#Preview {
    QuizView()
        .background(BlueBackgroundAnimatedGradient())
        .environmentObject(QuizViewModel(module: .init(
            question: "Who is depicted in the picture?",
            image: "BohdanKhmelnytsky",
            options: ["Ivan Mazepa", "Taras Shevchenko", "Bohdan Khmelnytsky", "Mykhailo Hrushevskyi"],
            correctAnswer: 2
        )))
        .environmentObject(GameViewModel())
}
