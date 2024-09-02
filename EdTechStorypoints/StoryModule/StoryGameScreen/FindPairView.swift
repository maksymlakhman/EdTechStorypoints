import SwiftUI







@Published var userAnswer: Int?
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







// View для FindPair
struct FindPairView: View {
    @EnvironmentObject var viewModel: FindPairViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
//            Text(viewModel.module.question)
            // Ваша логіка для FindPairView
            Button {
                dismiss()
            } label: {
                Image(systemName: "house")
            }
        }
    }
}

class FindPairViewModel: ObservableObject {
    var module: FindPairModuleProtocol
    var checkAnswerAction: (() -> Bool)?

    init(module: FindPairModuleProtocol) {
        self.module = module
    }
    
    func checkAnswer() -> Bool {
        return checkAnswerAction?() ?? false
    }
}

// View для Chronology

