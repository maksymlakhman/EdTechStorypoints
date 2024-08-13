//
//  AppleWatchConnectivityView.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 09.08.2024.
//

import SwiftUI
import Charts

struct AnswerHistory: Identifiable {
    let id = UUID()
    let question: String
    let isCorrect: Bool
    let timeTaken: String
    let reward: String
    let points: Int
    let bonus: Int
    let date: Date
    let correctAnswers: Int
    let totalQuestions: Int
}

enum ChartType: String, CaseIterable, Identifiable {
    case bar = "Bar"
    case line = "Line"
    case area = "Area"
    case pie = "Pie"
    case point = "Point"
    
    var id: String { rawValue }
}

struct AppleWatchConnectivityView: View {
    @State private var selectedChartType: ChartType = .bar
    
    let answerHistory: [AnswerHistory] = [
        AnswerHistory(question: "Was Kyiv founded in 482 AD?", isCorrect: true, timeTaken: "1 min", reward: "Bronze Badge", points: 10, bonus: 5, date: Date(), correctAnswers: 1, totalQuestions: 3),
        AnswerHistory(question: "Was Kyiv-Mohyla Academy founded in 1632?", isCorrect: true, timeTaken: "2 min", reward: "Silver Badge", points: 20, bonus: 10, date: Date(), correctAnswers: 2, totalQuestions: 3),
        AnswerHistory(question: "Did the Ukrainian Revolution last from 1917 to 1921?", isCorrect: false, timeTaken: "3 min", reward: "No Badge", points: 0, bonus: 0, date: Date(), correctAnswers: 0, totalQuestions: 3)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Section {
                Picker("Select Chart Type", selection: $selectedChartType) {
                    ForEach(ChartType.allCases) { chartType in
                        Text(chartType.rawValue).tag(chartType)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                // Display the selected chart
                switch selectedChartType {
                case .bar:
                    barChart
                case .line:
                    lineChart
                case .area:
                    areaChart
                case .pie:
                    pieChart
                case .point:
                    pointChart
                }
            } header: {
                Text("Statistics Charts")
                    .foregroundStyle(.accent)
                    .font(.largeTitle)
            } footer: {
                Text("Тут будуть відображаться твої відповіді з щоденного квізу")
                    .foregroundStyle(.primary)
                    .font(.footnote)
                
            }
            .headerProminence(.increased)
            
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 10) {
                        ForEach(answerHistory) { history in
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(history.question)
                                        .font(.headline)
                                        .foregroundColor(history.isCorrect ? .green : .red)
                                    
                                    Text("Time Taken: \(history.timeTaken)")
                                        .font(.subheadline)
                                    
                                    Text("Reward: \(history.reward)")
                                        .font(.subheadline)
                                    
                                    Text("Points: \(history.points) + Bonus: \(history.bonus)")
                                        .font(.subheadline)
                                }
                                .padding()
                                .background(.blue.opacity(0.2))
                                .cornerRadius(10)
                                
                                Spacer()
                            }
                        }
                    }
                }
            } header: {
                Text("Answers")
                    .foregroundStyle(.accent)
                    .font(.largeTitle)
                    .padding(.top)
            } footer: {
                Text("Тут будуть відображаться твої відповіді з щоденного квізу")
                    .foregroundStyle(.primary)
                    .font(.footnote)
                
            }
            .headerProminence(.increased)
            
            Spacer()
            
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.blue, .black, .blue]), startPoint: .top, endPoint: .bottomLeading))
    }

    private var barChart: some View {
        Chart(answerHistory) { stat in
            BarMark(
                x: .value("Date", stat.date, unit: .day),
                y: .value("Correct Answers", stat.correctAnswers)
            )
            .foregroundStyle(Gradient(colors: [.green, .yellow]))
            .cornerRadius(5)
            .annotation(position: .top) {
                Text("\(stat.correctAnswers)/\(stat.totalQuestions)")
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
        .frame(height: 200)
        .padding()
        .background(Color(UIColor.systemBackground).opacity(0.7))
        .cornerRadius(10)
    }
    
    private var lineChart: some View {
        Chart(answerHistory) { stat in
            LineMark(
                x: .value("Date", stat.date),
                y: .value("Correct Answers", stat.correctAnswers)
            )
            .foregroundStyle(Gradient(colors: [.blue, .purple]))
            .interpolationMethod(.catmullRom)
            .symbol {
                Circle().strokeBorder(lineWidth: 2).foregroundStyle(Color.pink)
            }
            .symbolSize(20)
        }
        .frame(height: 200)
        .padding()
        .background(Color(UIColor.systemBackground).opacity(0.7))
        .cornerRadius(10)
    }
    
    private var areaChart: some View {
        Chart(answerHistory) { stat in
            AreaMark(
                x: .value("Date", stat.date),
                y: .value("Correct Answers", stat.correctAnswers)
            )
            .foregroundStyle(Gradient(colors: [.orange.opacity(0.5), .red.opacity(0.3)]))
            .interpolationMethod(.monotone)
        }
        .frame(height: 200)
        .padding()
        .background(Color(UIColor.systemBackground).opacity(0.7))
        .cornerRadius(10)
    }
    
    private var pieChart: some View {
        Chart {
            ForEach(answerHistory) { stat in
                SectorMark(
                    angle: .value("Correct Answers", Double(stat.correctAnswers)),
                    innerRadius: .ratio(0.5)
                )
                .foregroundStyle(Gradient(colors: [.purple, .pink]))
                .annotation(position: .bottomTrailing) {
                    Text("\(stat.correctAnswers)/\(stat.totalQuestions)")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
        }
        .frame(height: 200)
        .padding()
        .background(Color(UIColor.systemBackground).opacity(0.7))
        .cornerRadius(10)
    }
    
    private var pointChart: some View {
        Chart(answerHistory) { stat in
            PointMark(
                x: .value("Date", stat.date),
                y: .value("Correct Answers", stat.correctAnswers)
            )
            .foregroundStyle(getColor(for: stat))
            .symbol {
                Circle()
                    .fill(getColor(for: stat)) // Використання того ж кольору для заповнення
                    .frame(width: 16, height: 16)
            }
        }
        .frame(height: 200)
        .padding()
        .background(Color(UIColor.systemBackground).opacity(0.8))
        .cornerRadius(12)
        .shadow(radius: 5)
    }

    private func getColor(for stat: AnswerHistory) -> Color {
        switch stat.correctAnswers {
        case 0:
            return Color.red
        case 1:
            return Color.orange
        case 2:
            return Color.yellow
        case 3:
            return Color.green
        default:
            return Color.blue
        }
    }
}

#Preview {
    AppleWatchConnectivityView()
}
