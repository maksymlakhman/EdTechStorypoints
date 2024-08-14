import SwiftUI

struct AnimationOnButton: View {
    @State var rotation: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(height: 50)
                .foregroundColor(.blue.opacity(0.2))
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(height: 50)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors:
                                                                        [.blue.opacity(0.8), .purple, .teal, .pink.opacity(0.8)]), startPoint:
                        .top, endPoint: .bottom))
                .rotationEffect(.degrees(rotation))
                .mask {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(lineWidth: 1)
                        .frame(height: 50)
                }
            Text("Check")
                .bold()
                .font(.title3)
                .foregroundColor(.blue)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 3.5).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

struct GameMenuView: View {
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    
    @State private var selectedOptionIndex: Int? = nil
    @State private var showResult: Bool = false
    @State private var showNextButton: Bool = false
    @Binding var progress: Double
    @Binding var currentQuestionIndex: Int
    var onNext: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                Image("BohdanKhmelnytsky") // замініть на назву вашого зображення
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height / 2)
                
                Text(question)
                    .font(.headline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Сітка з 4 відповідями (2 на 2)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(options.indices, id: \.self) { index in
                    Button(action: {
                        if !showResult {
                            selectedOptionIndex = index
                        }
                    }) {
                        Text(options[index])
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .background(self.colorForOption(at: index).opacity(self.opacityForOption(at: index)))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                            .animation(.default, value: selectedOptionIndex)
                    }
                    .disabled(showResult)
                }
            }
            
            if showResult {
                Button(action: {
                    // Перехід до наступного питання
                    showResult = false
                    showNextButton = false
                    onNext()
                }) {
                    Text("Next")
                        .bold()
                        .font(.title3)
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
                .disabled(!showNextButton)
            } else {
                Button(action: {
                    if let selectedIndex = selectedOptionIndex {
                        // Показ результату
                        showResult = true
                        showNextButton = true
                        
                        // Додати затримку перед переходом
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            // Змінити progress для показу завершення питання
                            progress = 1.0
                        }
                    }
                }) {
                    AnimationOnButton()
                }
                .padding(.top)
                .disabled(selectedOptionIndex == nil)
            }
        }
    }
    
    func colorForOption(at index: Int) -> Color {
        switch index {
        case 0:
            return .red
        case 1:
            return .green
        case 2:
            return .purple
        case 3:
            return .orange
        default:
            return .gray
        }
    }
    
    func opacityForOption(at index: Int) -> Double {
        if showResult {
            // Показати правильний варіант з максимальною прозорістю
            return index == correctAnswerIndex ? 1.0 : 0.5
        } else {
            // Показати вибраний варіант з максимальною прозорістю, інші зменшити
            return selectedOptionIndex == index ? 1.0 : 0.5
        }
    }
}


struct StartGameScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var progress = 0.0
    private let gradient = LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing)
    @State private var currentQuestionIndex = 0
    
    let questions: [(String, [String], Int)] = [
        ("What is the capital of France?", ["Berlin", "Madrid", "Paris", "Rome"], 2),
        ("What is the capital of Germany?", ["Berlin", "Madrid", "Paris", "Rome"], 0)
        // Додай більше питань тут
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                HStack(alignment: .top, spacing: 0) {
                    Button {
                        withAnimation(.smooth) {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.white)
                            .contentTransition(.symbolEffect(.replace.upUp.byLayer))
                            .accessibilityLabel("Profile View Button")
                    }
                    .clipShape(Circle())
                    .tint(Color.blue.opacity(0.1))
                    .buttonStyle(.borderedProminent)

                    ProgressView(value: progress) {
                        Text("\(String(format: "%.0f%%", progress * 100))")
                            .padding(.horizontal)
                            .offset(x: progress * 250)
                            .font(.headline)
                    }
                    .progressViewStyle(.linear)
                    .tint(Color.blue.opacity(0.01))
                    .background(
                        LinearGradient(gradient: Gradient(colors: [
                            Color.black.opacity(1 - progress),
                            Color.blue.opacity(progress)
                        ]), startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(Capsule())
                }
                .padding(.vertical)
                
                // Game
                GameMenuView(
                    question: questions[currentQuestionIndex].0,
                    options: questions[currentQuestionIndex].1,
                    correctAnswerIndex: questions[currentQuestionIndex].2,
                    progress: $progress,
                    currentQuestionIndex: $currentQuestionIndex,
                    onNext: {
                        // Перехід до наступного питання
                        if currentQuestionIndex < questions.count - 1 {
                            currentQuestionIndex += 1
                            progress = 0.0
                        } else {
                            // Закінчення гри
                            dismiss()
                        }
                    }
                )
                Spacer()
            }
            .padding()
            .background(ComplexAnimatedGradient())
        }
    }
}




extension StartGameScreen {
    
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            leadingNavView()
        }
    }
    
    @ViewBuilder
    private func leadingNavView() -> some View {
        Button {
            withAnimation(.smooth) {
                dismiss()
            }
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundStyle(.white)
                .contentTransition(.symbolEffect(.replace.upUp.byLayer))
                .accessibilityLabel("Profile View Button")
        }
        .clipShape(Circle())
        .tint(Color.blue.opacity(0.1))
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    StartGameScreen()
}
