//
//  HistorycalLibraryScreen.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 09.08.2024.
//

import SwiftUI

enum LiteraryTag: String, CaseIterable, Identifiable {
    case historicalFiction = "historical fiction"
    case novel = "novel"
    case classic = "classic"
    case biography = "biography"
    case fantasy = "fantasy"
    case mystery = "mystery"
    case scienceFiction = "science fiction"
    case romance = "romance"
    case thriller = "thriller"
    case philosophy = "philosophy"
    case poetry = "poetry"
    case nonFiction = "non-fiction"
    case drama = "drama"
    case adventure = "adventure"
    case dystopian = "dystopian"
    case crime = "crime"
    case horror = "horror"
    case autobiography = "autobiography"
    case mythology = "mythology"
    case youngAdult = "young adult"
    case literaryFiction = "literary fiction"

    var id: String { rawValue }
}

struct LiteraryItem: Identifiable {
    let id = UUID()
    let author: String
    let title: String
    let image1: String
    let tag: LiteraryTag
}

struct HistorycalLibraryScreen: View {
    
    @State private var searchText = ""
    @State private var activeTag: LiteraryTag? = nil
    
    let tags: [LiteraryTag] = LiteraryTag.allCases
    
    let items: [LiteraryItem] = [
        LiteraryItem(author: "Taras Shevchenko", title: "fight and you shall overcome!", image1: "book", tag: .historicalFiction),
        LiteraryItem(author: "Lesya Ukrainka", title: "contra spem spero!", image1: "book", tag: .classic),
        LiteraryItem(author: "Ivan Franko", title: "knowledge is power!", image1: "book", tag: .biography),
        LiteraryItem(author: "Hryhorii Skovoroda", title: "the world tried to catch me but couldn't.", image1: "book", tag: .philosophy),
        LiteraryItem(author: "Mykhailo Kotsyubynsky", title: "shadows of forgotten ancestors.", image1: "book", tag: .poetry),
        LiteraryItem(author: "Oleksandr Dovzhenko", title: "land is the greatest wealth of the people.", image1: "book", tag: .novel),
        LiteraryItem(author: "Lesya Ukrainka", title: "the forest song", image1: "book", tag: .classic),
        LiteraryItem(author: "Ivan Franko", title: "difficulties of a knight", image1: "book", tag: .biography),
        LiteraryItem(author: "Taras Shevchenko", title: "katerina", image1: "book", tag: .historicalFiction),
        LiteraryItem(author: "Mykhailo Kotsyubynsky", title: "intermezzo", image1: "book", tag: .poetry),
        LiteraryItem(author: "Hryhorii Skovoroda", title: "a conversation with a fool", image1: "book", tag: .philosophy),
        LiteraryItem(author: "Vasyl Stus", title: "the last letters", image1: "book", tag: .poetry),
        LiteraryItem(author: "Bohdan Ihor Antonych", title: "the rose of the world", image1: "book", tag: .poetry),
        LiteraryItem(author: "Oleksandr Dovzhenko", title: "earth", image1: "book", tag: .novel),
        LiteraryItem(author: "Lina Kostenko", title: "the evening bells", image1: "book", tag: .classic),
        LiteraryItem(author: "Mykhailo Kotsyubynsky", title: "a novel about love", image1: "book", tag: .novel)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 8) {
                    Group {
                        HStack(alignment: .bottom) {
                            Text("the best books for /")
                                
                            Text("you")
                                .foregroundStyle(.yellow)
                        }
                        .font(.system(size: 50))
                        .multilineTextAlignment(.leading)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(tags) { tag in
                                    Button {
                                        activeTag = tag
                                    } label: {
                                        Text("#\(tag.rawValue)")
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 15)
                                            .background(activeTag == tag ? Color.yellow : Color.white.opacity(0.2))
                                            .cornerRadius(20)
                                    }
                                    .foregroundStyle(activeTag == tag ? Color.black : Color.white)
                                }
                            }
                        }
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color.primary)
                    ForEach(items.filter { activeTag == nil || $0.tag == activeTag }) { item in
                        HStack(spacing: 16) {
                            
                            VStack(alignment: .leading, spacing : 15) {
                                Text("#" + item.tag.rawValue)
                                Spacer()
                                Text(item.title)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .padding(.top, 20)
                                Text(item.author)
                                    .font(.title3)
                                    .foregroundColor(.yellow)
                            }
                            .foregroundStyle(.primary)
                            .padding(.vertical)
                            Spacer()
                            Image(item.image1)
                                .resizable()
                                .frame(maxWidth: UIScreen.main.bounds.width / 3, maxHeight: 160)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        Divider()
                            .frame(height: 1)
                            .background(Color.primary)
                    }
                }
                .padding(.leading, 16)
            }
            .background(Color.blue)
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Books")
            .searchable(text: $searchText, prompt: "Search books")
        }
    }
}

#Preview {
    HistorycalLibraryScreen()
}
