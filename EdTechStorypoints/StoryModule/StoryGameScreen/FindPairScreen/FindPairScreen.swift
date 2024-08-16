//
//  FindPairScreen.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 16.08.2024.
//

import SwiftUI

struct Pair: Hashable {
    let first: String
    let second: String
}

struct FindPairScreen: GameTask {
    let id = UUID()
    let pairs: [Pair]
    let correctPhrases: [String]
    let incorrectPhrases: [String]
    
    var taskType: TaskType {
        return .findPair
    }
    
    init(pairs: [(String, String)], correctPhrases: [String] , incorrectPhrases: [String]) {
        self.pairs = pairs.map { Pair(first: $0.0, second: $0.1) }
        self.correctPhrases = correctPhrases
        self.incorrectPhrases = incorrectPhrases
    }
    
    func view(progress: Binding<Double>, onNext: @escaping () -> Void) -> AnyView {
        AnyView(
            FindPairView(
                pairs: pairs,
                correctPhrases: correctPhrases,
                incorrectPhrases: incorrectPhrases,
                onNext: onNext
            )
        )
    }
    
    func checkAnswer(_ answer: Any) -> Bool {
        // Логіка для перевірки правильної відповіді
        return true
    }
}


struct FindPairView: View {
    let pairs: [Pair]
    let correctPhrases: [String]
    let incorrectPhrases: [String]
    let onNext: () -> Void
    
    @State private var selectedPairs: [Pair] = []
    
    var body: some View {
        VStack {
            Text("Знайдіть пари")
                .font(.headline)
                .padding()
            
            // Display pairs
            ForEach(pairs, id: \.self) { pair in
                HStack {
                    Text(pair.first)
                    Spacer()
                    Text(pair.second)
                }
                .padding()
            }
            
            Button("Перевірити") {
                if checkAnswer() {
                    onNext()
                } else {
                    // Show incorrect answer feedback
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    private func checkAnswer() -> Bool {
        // Your logic to check if pairs are correctly matched
        return true
    }
}
