//
//  LastHistoryNewsScreen.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 09.08.2024.
//

import SwiftUI

struct Story: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let imageName: String
    let index: Int
}

struct LastHistoryNewsScreen: View {
    @State private var searchText = ""
    
    let stories: [Story] = [
        Story(title: "Victory in the Battle of Konotop", date: "June 29, 1659", imageName: "BohdanKhmelnytsky", index: 1),
        Story(title: "Struggle for Independence", date: "1917–1921", imageName: "BohdanKhmelnytsky", index: 2),
        Story(title: "Culture of Kyivan Rus'", date: "882–1240", imageName: "BohdanKhmelnytsky", index: 1),
        Story(title: "Events of 1932–1933", date: "1932–1933", imageName: "BohdanKhmelnytsky", index: 2),
        Story(title: "The Hetmanate", date: "1648–1782", imageName: "BohdanKhmelnytsky", index: 1),
        Story(title: "Revolution of Dignity", date: "2013–2014", imageName: "BohdanKhmelnytsky", index: 2),
    ]
    
    var filteredStories: [Story] {
        if searchText.isEmpty {
            return stories
        } else {
            return stories.filter { $0.title.contains(searchText) || $0.date.contains(searchText) }
        }
    }

    private var homeGridItems = [GridItem(.fixed(150), alignment: .center)]

    private var positiveStories: some View {
        LazyVGrid(columns: homeGridItems) {
            ForEach(filteredStories.filter { $0.index == 1 }, id: \.id) { story in
                ZStack() {
                    Image(story.imageName)
                        .resizable()
                    VStack(alignment: .center, spacing: 0) {
                        HStack {
                            Spacer()
                            Image(systemName: "heart")
                                .padding(12)
                        }
                        Spacer()
                        VStack {
                            Text(story.title)
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                            Text(story.date)
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: 180, height: CGFloat.random(in: 250...300), alignment: .center)
            }
        }
    }

    private var negativeStories: some View {
        LazyVGrid(columns: homeGridItems) {
            ForEach(filteredStories.filter { $0.index == 2 }, id: \.id) { story in
                ZStack() {
                    Image(story.imageName)
                        .resizable()
                    VStack(alignment: .center, spacing: 0) {
                        HStack {
                            Spacer()
                            Image(systemName: "heart")
                                .padding(12)
                        }
                        Spacer()
                        VStack {
                            Text(story.title)
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                            Text(story.date)
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: 180, height: CGFloat.random(in: 250...300), alignment: .center)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    VStack(spacing: 0) {
                        positiveStories
                    }
                    VStack(spacing: 0) {
                        negativeStories
                    }
                }
                .padding(.top, 8)
            }
            .configureNavigationBar()
            .searchable(text: $searchText, prompt: "Search stories")
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("History")
        }
    }
}

struct StoryDetailView: View {
    let story: Story

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(story.title)
                .font(.largeTitle)
                .bold()
            Image(story.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
        }
        .padding()
        .navigationTitle(story.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    LastHistoryNewsScreen()
}

