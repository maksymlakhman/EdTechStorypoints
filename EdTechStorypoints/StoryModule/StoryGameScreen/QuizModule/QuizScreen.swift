//
//  QuizScreen.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 16.08.2024.
//

import SwiftUI

struct QuizScreen: GameTask {
    let id = UUID()
    let question: String
    let image: String
    let options: [String]
    let correctAnswerIndex: Int
    let correctPhrases: [String]
    let incorrectPhrases: [String]
    var taskType: TaskType {
        return .quiz
    }
    
    func view(progress: Binding<Double>, onNext: @escaping () -> Void) -> AnyView {
        AnyView(
            QuizView(
                question: question,
                image: image,
                options: options,
                correctAnswerIndex: correctAnswerIndex,
                onNext: onNext,
                correctPhrases: correctPhrases,
                incorrectPhrases: incorrectPhrases
            )
        )
    }
    
    func checkAnswer(_ answer: Any) -> Bool {
        guard let index = answer as? Int else { return false }
        return index == correctAnswerIndex
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
