//
//  AppleWatchConnectivityView.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 09.08.2024.
//

import SwiftUI
import Charts

struct QuestionHistory: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    let isCorrect: Bool
}

struct AnswerStatistics: Identifiable {
    let id = UUID()
    let date: Date
    let correctAnswers: Int
    let totalQuestions: Int
}

struct AppleWatchConnectivityView: View {
    let questionHistory: [QuestionHistory] = [
        QuestionHistory(question: "Was Kyiv founded in 482 AD?", answer: "Yes", isCorrect: true),
        QuestionHistory(question: "Was Kyiv-Mohyla Academy founded in 1632?", answer: "Yes", isCorrect: true),
        QuestionHistory(question: "Did the Ukrainian Revolution last from 1917 to 1921?", answer: "Yes", isCorrect: false)
    ]
    
    let statistics: [AnswerStatistics] = [
        AnswerStatistics(date: Date().addingTimeInterval(-86400 * 2), correctAnswers: 2, totalQuestions: 3),
        AnswerStatistics(date: Date().addingTimeInterval(-86400), correctAnswers: 3, totalQuestions: 3),
        AnswerStatistics(date: Date(), correctAnswers: 1, totalQuestions: 2)
    ]
    
    var body: some View {
        VStack {
            Text("Question History")
                .font(.headline)
                .padding()
            
            List(questionHistory) { history in
                HStack {
                    VStack(alignment: .leading) {
                        Text(history.question)
                            .font(.subheadline)
                        Text("Answer: \(history.answer)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    if history.isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            
            Text("Statistics")
                .font(.headline)
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    // Bar Chart
                    Chart(statistics) { stat in
                        BarMark(
                            x: .value("Date", stat.date, unit: .day),
                            y: .value("Correct Answers", stat.correctAnswers)
                        )
                        .annotation(position: .top) {
                            Text("\(stat.correctAnswers)/\(stat.totalQuestions)")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    .frame(width: 300, height: 200)
                    .padding()
                    
                    // Line Chart
                    Chart(statistics) { stat in
                        LineMark(
                            x: .value("Date", stat.date),
                            y: .value("Correct Answers", stat.correctAnswers)
                        )
                        .foregroundStyle(Color.green)
                        .symbol(Circle())
                    }
                    .frame(width: 300, height: 200)
                    .padding()
                    
                    // Area Chart
                    Chart(statistics) { stat in
                        AreaMark(
                            x: .value("Date", stat.date),
                            y: .value("Correct Answers", stat.correctAnswers)
                        )
                        .foregroundStyle(Color.blue.opacity(0.3))
                    }
                    .frame(width: 300, height: 200)
                    .padding()
                    
                    // Pie Chart
                    Chart {
                        ForEach(statistics) { stat in
                            SectorMark(
                                angle: .value("Correct Answers", stat.correctAnswers)
                            )
                            .foregroundStyle(Color.purple)
                        }
                    }
                    .frame(width: 300, height: 200)
                    .padding()
                    
                    // Point Chart
                    Chart(statistics) { stat in
                        PointMark(
                            x: .value("Date", stat.date),
                            y: .value("Correct Answers", stat.correctAnswers)
                        )
                        .foregroundStyle(Color.orange)
                        .symbolSize(10)
                    }
                    .frame(width: 300, height: 200)
                    .padding()
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AppleWatchConnectivityView()
}

