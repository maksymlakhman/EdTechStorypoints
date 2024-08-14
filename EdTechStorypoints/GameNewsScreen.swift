//
//  GameNewsScreen.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 14.08.2024.
//

import SwiftUI
import Charts

struct GameUpdate: Identifiable {
    let id = UUID()
    let imageName: String
    let version: String
    let description: String
    let chartData: [ChartDataEntry] // Поле для даних діаграми
}

class GameNewsViewModel: ObservableObject {
    @Published var updates: [GameUpdate] = [
        GameUpdate(
            imageName: "Duel",
            version: "1.0",
            description: "Initial release with basic gameplay mechanics",
            chartData: [
                ChartDataEntry(category: "Gameplay", value: 60),
                ChartDataEntry(category: "UI", value: 30),
                ChartDataEntry(category: "Other", value: 10),
                ChartDataEntry(category: "Audio", value: 20),
                ChartDataEntry(category: "Graphics", value: 50),
                ChartDataEntry(category: "Multiplayer", value: 40),
                ChartDataEntry(category: "AI", value: 25),
                ChartDataEntry(category: "Storyline", value: 35)
            ]

        ),
        GameUpdate(
            imageName: "Duel",
            version: "1.1",
            description: "Added new characters and improved game performance",
            chartData: [
                ChartDataEntry(category: "Gameplay", value: 60),
                ChartDataEntry(category: "UI", value: 30),
                ChartDataEntry(category: "Other", value: 10),
                ChartDataEntry(category: "Audio", value: 20),
                ChartDataEntry(category: "Graphics", value: 25),
                ChartDataEntry(category: "Multiplayer", value: 40),
                ChartDataEntry(category: "AI", value: 25),
                ChartDataEntry(category: "AD", value: 25),
                ChartDataEntry(category: "Storyline", value: 35)
            ]

        ),
        GameUpdate(
            imageName: "Duel",
            version: "1.0",
            description: "Initial release with basic gameplay mechanics",
            chartData: [
                ChartDataEntry(category: "Gameplay", value: 60),
                ChartDataEntry(category: "UI", value: 30),
                ChartDataEntry(category: "Other", value: 10),
                ChartDataEntry(category: "Audio", value: 20),
                ChartDataEntry(category: "Graphics", value: 50),
                ChartDataEntry(category: "Multiplayer", value: 40),
                ChartDataEntry(category: "AI", value: 25),
                ChartDataEntry(category: "Storyline", value: 35)
            ]

        ),
        GameUpdate(
            imageName: "Duel",
            version: "1.1",
            description: "Added new characters and improved game performance",
            chartData: [
                ChartDataEntry(category: "Gameplay", value: 60),
                ChartDataEntry(category: "UI", value: 30),
                ChartDataEntry(category: "Other", value: 10),
                ChartDataEntry(category: "Audio", value: 20),
                ChartDataEntry(category: "Graphics", value: 25),
                ChartDataEntry(category: "Multiplayer", value: 40),
                ChartDataEntry(category: "AI", value: 25),
                ChartDataEntry(category: "AD", value: 25),
                ChartDataEntry(category: "Storyline", value: 35)
            ]

        ),
    ]
}

struct PieChartView: View {
    var data: [ChartDataEntry]

    var body: some View {
        Chart {
            ForEach(data) { entry in
                SectorMark(
                    angle: .value("Value", entry.value),
                    innerRadius: .ratio(0.5),
                    outerRadius: .ratio(1.0)
                )
                .foregroundStyle(by: .value("Category", entry.category))
            }
        }
        .padding()
    }
}

struct WaveChartView: View {
    var data: [ChartDataEntry]

    var body: some View {
        Chart {
            ForEach(data) { entry in
                LineMark(
                    x: .value("Time", entry.category),
                    y: .value("Value", entry.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(.pink)
            }
        }
    }
}

struct ChartDataEntry: Identifiable {
    let id = UUID()
    var category: String
    var value: Double
}


struct GameNewsScreen: View {
    @StateObject private var viewModel = GameNewsViewModel()

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewModel.updates.reversed()) { article in
                    LazyVStack(spacing: 0) {
                        NavigationLink {
                            Text("Selected Version: \(article.version)")
                        } label: {
                            VStack(spacing : 0) {
                                HStack(spacing : 0) {
                                    ZStack {
                                        Image(article.imageName)
                                            .resizable()
                                            .scaledToFit()
                                        VStack(spacing: 0) {
                                            Text("Version \(article.version)")
                                                .foregroundStyle(.white)
                                                .font(.title3)
                                                .bold()
                                        }
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                    
                                    PieChartView(data: article.chartData)
                                }
                                .background {
                                    Color.white.opacity(0.2)
                                }
                                HStack(spacing : 0){
                                    WaveChartView(data: article.chartData)
                                            .padding()
                                    VStack {
                                        Image("CossackLong")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxHeight : 200)
                                            .padding()
                                        Button {
                                            
                                        } label: {
                                            Label("Preview", systemImage: "arkit")
                                                .foregroundStyle(.white)
                                                .padding()
                                                .background {
                                                    Capsule()
                                                        .fill(.blue)
                                                }
                                        }

                                    }
                                }
                                .background {
                                    Color.white.opacity(0.2)
                                }
                                ZStack {
                                    UnevenRoundedRectangle(bottomLeadingRadius: 20, bottomTrailingRadius: 20)
                                    Text(article.description)
                                        .foregroundStyle(.white)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                        .padding(.horizontal)
                                }
                                .frame(height: 100)

                            }
                            .foregroundStyle(.white.opacity(0.2))
                            .visualEffect { content, proxy in
                                let frame = proxy.frame(in: .scrollView(axis: .vertical))
                                let distance = min(0, frame.minY)
                                return content
                                    .scaleEffect(1 + distance / 700)
                                    .offset(y: -distance / 1.25)
                                    .brightness(-distance / 400)
                                    .blur(radius: -distance / 50)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            
                        }
                    }
                }
            }
            .configureNavigationBar()
            .background(ComplexAnimatedGradient())
            .navigationTitle("Game News")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                leadingNavItems()
            }
        }
    }
}

extension GameNewsScreen {
    
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
                .accessibilityLabel("Back Button to ARScreen")
        }
        .clipShape(Circle())
        .tint(Color.blue.opacity(0.1))
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    GameNewsScreen()
}

