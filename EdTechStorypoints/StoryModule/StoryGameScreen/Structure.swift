import SwiftUI














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
struct ChronologyView: View {
    @EnvironmentObject var viewModel: ChronologyViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
//            Text(viewModel.module.question)
//            // Ваша логіка для ChronologyView
            Button {
                dismiss()
            } label: {
                Image(systemName: "house")
            }
        }
    }
}

class ChronologyViewModel: ObservableObject {
    var module: ChronologyModuleProtocol
    var checkAnswerAction: (() -> Bool)?

    init(module: ChronologyModuleProtocol) {
        self.module = module
    }

    func checkAnswer() -> Bool {
        return checkAnswerAction?() ?? false
    }
}

#Preview {
    GameView()
}
