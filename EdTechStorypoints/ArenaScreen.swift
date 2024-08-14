//
//  ArenaScreen.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 13.08.2024.
//

import SwiftUI

struct ArenaScreen: View {
    let options = [
        OptionArena(title: "Duel", description: "Compete one-on-one with another player.", imageName: "Duel"),
        OptionArena(title: "Tournament", description: "Participate in a tournament and battle multiple opponents.", imageName: "Duel"),
        OptionArena(title: "Challenge", description: "Overcome a series of challenging tasks and questions.", imageName: "Duel"),
        OptionArena(title: "Cup", description: "Compete for the cup by progressing through all stages.", imageName: "Duel")
    ]
    
    @State private var selectedOption: OptionArena? = nil
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(options) { article in
                LazyVStack(spacing : 0) {
                    Button {
                        selectedOption = article
                    } label: {
                        ZStack {
                            Image(article.imageName)
                                .resizable()
                                .scaledToFit()
                            VStack(spacing: 0) {
                                Spacer()
                                Text(article.title)
                                    .foregroundStyle(.white)
                                    .font(.largeTitle)
                                    .bold()
                                Spacer()
                                ZStack {
                                    UnevenRoundedRectangle(bottomLeadingRadius: 20, bottomTrailingRadius: 20)
                                    Text(article.description)
                                        .foregroundStyle(.white)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                }
                                .foregroundStyle(.white.opacity(0.2))
                                .frame(maxHeight: 100)
                            }
                        }
                        .visualEffect { content, proxy in
                            let frame = proxy.frame(in: .scrollView(axis: .vertical))
                            let distance = min(0, frame.minY)
                            return content
    //                            .hueRotation(.degrees(frame.origin.y / 2))
                                .scaleEffect(1 + distance / 700)
                                .offset(y: -distance / 1.25)
                                .brightness(-distance / 400)
                                .blur(radius: -distance / 50)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                    .padding(.bottom, 8)
                    .fullScreenCover(item: $selectedOption) { selectedArticle in
                        OptionArenaScreen(news: selectedArticle)
                    }
                }
            }
        }
    }
}


struct OptionArenaScreen: View {
    let news: OptionArena?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack{
            Text(news?.title ?? "")
                .navigationTitle(news?.title ?? "")
                .navigationBarItems(leading:
                                        Button("Cancel") {
                    dismiss()
                    }
                )
        }
    }
}

#Preview {
    ArenaScreen()
}

struct OptionArena: Identifiable, Hashable {
    let id: UUID = UUID()
    let title: String
    let description: String
    let imageName: String
}

#Preview {
    OptionArenaScreen(news: OptionArena(title: "Duel", description: "Compete one-on-one with another player.", imageName: "Duel"))
}
