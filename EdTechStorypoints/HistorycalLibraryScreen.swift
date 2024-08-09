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
    let quote: String
    let image1: String
    let tag: LiteraryTag // Use the enum instead of a string
}

struct HistorycalLibraryScreen: View {
    
    @State private var searchText = ""
    @State private var activeTag: LiteraryTag? = nil
    
    let tags: [LiteraryTag] = LiteraryTag.allCases
    
    let items: [LiteraryItem] = [
        LiteraryItem(author: "Taras Shevchenko", quote: "«fight and you shall overcome!»", image1: "book", tag: .historicalFiction),
        LiteraryItem(author: "Lesya Ukrainka", quote: "«contra spem spero!»", image1: "book", tag: .classic),
        LiteraryItem(author: "Ivan Franko", quote: "«knowledge is power!»", image1: "book", tag: .biography),
        LiteraryItem(author: "Hryhorii Skovoroda", quote: "«the world tried to catch me but couldn't.»", image1: "book", tag: .philosophy),
        LiteraryItem(author: "Mykhailo Kotsyubynsky", quote: "«shadows of forgotten ancestors.»", image1: "book", tag: .poetry),
        LiteraryItem(author: "Oleksandr Dovzhenko", quote: "«land is the greatest wealth of the people.»", image1: "book", tag: .novel)
    ]

    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Group {
                    HStack(alignment: .bottom) {
                        Text("the best books for /")
                            
                        Text("you")
                            .foregroundStyle(.yellow)
                    }
                    .font(.system(size: 50))

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
                .padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .trailing, spacing: 8) {
                        Divider()
                            .background(.primary)
                        ForEach(items.filter { activeTag == nil || $0.tag == activeTag }, id: \.id) { item in
                            HStack(spacing: 16) {
                                
                                VStack(alignment: .leading) {
                                    Text(item.quote)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.blue)
                                        .multilineTextAlignment(.leading)
                                    Text(item.author)
                                        .font(.subheadline)
                                        .foregroundColor(.yellow)
                                }
                                .foregroundStyle(.primary)
                                Spacer()
                                Image(item.image1)
                                    .resizable()
                                    .frame(width: 160, height: 160)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            Divider()
                                .background(.primary)
                        }
                       
                    }
                    .padding(10)
                }
            }
        }
        .background(.blue)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search books")
    }
}



#Preview {
    HistorycalLibraryScreen()
}
