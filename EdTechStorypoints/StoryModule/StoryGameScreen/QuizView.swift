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
                    quizVM.userAnswer = index
                    print("User answer updated to: \(quizVM.userAnswer ?? -1)")
                } label: {
                    Text(quizVM.module.options[index])
                        .padding()
                        .foregroundColor(quizVM.userAnswer == index ? .white : .yellow)
                }
                .frame(maxWidth: .infinity)
                .background(quizVM.userAnswer == index ? colorForIndex(index) : Color.clear)
                .cornerRadius(8)
                .padding(.horizontal)
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func colorForIndex(_ index: Int) -> Color {
        switch index {
        case 0: return .green
        case 1: return .pink
        case 2: return .cyan
        case 3: return .orange
        default: return .gray
        }
    }
}

class QuizViewModel: ObservableObject {
    @Published var userAnswer: Int?
    let module: QuizModuleProtocol
    var checkAnswerAction: ((Int) -> Bool)?
    
    init(module: QuizModuleProtocol) {
        self.module = module
        print("QuizViewModel initialized with module: \(module)")
        
        self.checkAnswerAction = { [weak self] answer in
            let isCorrect = self?.module.correctAnswer == answer
            print("CheckAnswerAction called with answer: \(answer), correct answer: \(self?.module.correctAnswer ?? -1), is correct: \(isCorrect ?? false)")
            return isCorrect ?? false
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
            question: "Хто зображений на картинці?",
            image: "BohdanKhmelnytsky",
            options: ["Іван Мазепа", "Тарас Шевченко", "Богдан Хмельницький", "Михайло Грушевський"],
            correctAnswer: 2
        )))
        .environmentObject(GameViewModel())
}
