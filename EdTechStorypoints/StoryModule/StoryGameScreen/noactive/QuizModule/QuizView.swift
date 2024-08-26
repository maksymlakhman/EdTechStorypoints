import SwiftUI
//
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
//
//
//
//
//struct QuizModuleView: View {
//    let quizModule: QuizModule
//    @EnvironmentObject var viewModel: GameViewModel
//    
//    var body: some View {
//        VStack {
//            Image(quizModule.image)
//                .resizable()
//                .scaledToFit()
//                .frame(height: UIScreen.main.bounds.height / 3)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//            Text(quizModule.question)
//                .font(.headline)
//                .padding()
//                .foregroundStyle(.accent)
//            ForEach(quizModule.options.indices, id: \.self) { index in
//                Button(action: {
//                    viewModel.selectedAnswer = index
//                }) {
//                    Text(quizModule.options[index])
//                        .padding(15)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .background(viewModel.selectedAnswer == index ? Color.blue : Color.gray)
//                        .cornerRadius(10)
//                }
//            }
//        }
//    }
//}
//
//
//#Preview {
//    QuizModuleView(quizModule: QuizModule(
//        question: "Who is depicted in the photo?", 
//        image: "BohdanKhmelnytsky",
//        options: [
//            "Bohdan Khmelnytsky",
//            "Ivan Mazepa",
//            "Taras Shevchenko",
//            "Petro Konashevych-Sahaidachny"
//        ],
//        correctAnswer: 2
//    ))
//    .environmentObject(GameViewModel())
//    .previewLayout(.sizeThatFits)
//    .padding()
//    .background(BlueBackgroundAnimatedGradient())
//}
//
//
//
//#Preview {
//    GameView()
//}
