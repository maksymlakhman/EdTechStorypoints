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



#Preview {
    GameView()
}
