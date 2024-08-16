//
//  QuizView.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 15.08.2024.
//

import SwiftUI

struct QuizView: View {
    let question: String
    let image: String
    let options: [String]
    let correctAnswerIndex: Int
    let onNext: () -> Void
    let correctPhrases: [String]
    let incorrectPhrases: [String]
    @State private var selectedAnswerIndex: Int? = nil
    @State private var isAnswerCorrect = false
    @State private var showCorrectSheet = false
    @State private var showIncorrectSheet = false

    var body: some View {
        LazyVStack(spacing : 10) {
            Image(image)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .frame(maxHeight: 350)
            
            Text(question)
                .font(.headline)
                .padding()
            
            ForEach(options.indices, id: \.self) { index in
                HStack(spacing: 0) {
                    if selectedAnswerIndex != index {
                        Text(self.variantForOption(at: index))
                            .padding(10)
                            .background(self.colorForOption(at: index).opacity(0.8))
                            .foregroundColor(selectedAnswerIndex == index ? .white : .black)
                            .cornerRadius(10)
                    }
                    
                    
                    Button(action: {
                        withAnimation(.spring){
                            selectedAnswerIndex = index
                        }
                    }) {
                        Text(options[index])
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedAnswerIndex == index ? self.colorForOption(at: index) : Color.white.opacity(0.7))
                            .foregroundColor(selectedAnswerIndex == index ? .white : .black)
                            .cornerRadius(10)
                            .scaleEffect(selectedAnswerIndex == index ? 1.0 : 0.97, anchor: .bottomTrailing)
                            .font(.subheadline)
                    }
                }
            }
            Button {
                checkAnswer()
            } label: {
                CheckAnimationBTN()
            }
            .disabled(selectedAnswerIndex == nil)
            .scaleEffect(selectedAnswerIndex == nil ? 0.97 : 1.0, anchor: .center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background {
            BlueBackgroundAnimatedGradient()
        }
        .sheet(isPresented: $showCorrectSheet) {
            HStack {
                if let randomPhrase = correctPhrases.randomElement() {
                    Label(randomPhrase, systemImage: "face.smiling.inverse")
                        .foregroundColor(.green)
                        .padding()
                        .font(.headline)
                }
                Spacer()
                Button("Next") {
                    showCorrectSheet = false
                    
                    withAnimation(.snappy) {
                        onNext()
                        self.selectedAnswerIndex = nil
                    }
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
        .sheet(isPresented: $showIncorrectSheet) {
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
    
    private func checkAnswer() {
        guard let selectedAnswerIndex = selectedAnswerIndex else { return }
        
        isAnswerCorrect = selectedAnswerIndex == correctAnswerIndex
        
        if isAnswerCorrect {
            showCorrectSheet = true
        } else {
            showIncorrectSheet = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showIncorrectSheet = false
                withAnimation(.snappy) {
                    self.selectedAnswerIndex = nil
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


#Preview {
    QuizView(
        question: "Who is depicted in the photo?",
        image: "BohdanKhmelnytsky",
        options: [
        "Bohdan Khmelnytsky",
        "Ivan Mazepa",
        "Taras Shevchenko",
        "Petro Konashevych-Sahaidachny"
        ],
        correctAnswerIndex: 0,
        onNext: { }, correctPhrases: [
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
        ], incorrectPhrases: [
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
    )
}
