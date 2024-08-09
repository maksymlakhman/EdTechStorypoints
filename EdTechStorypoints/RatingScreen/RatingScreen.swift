//
//  RatingScreen.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 09.08.2024.
//

import SwiftUI

struct User: Identifiable {
    let id = UUID()
    let name: String
    let points: Int
    let position: Int
    let color: Color
}

struct FirstView: View {
    let users: [User]

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 16) {
                // 3rd place
                if let thirdPlaceUser = users.first(where: { $0.position == 3 }) {
                    VStack {
                        Image("CossackLarge")
                            .resizable()
                            .scaledToFit()
                        Text(thirdPlaceUser.name)
                            .font(.headline)
                        Text("\(thirdPlaceUser.points) pts")
                            .font(.subheadline)
                        UnevenRoundedRectangle(topLeadingRadius: 15, topTrailingRadius: 15)
                            .fill(thirdPlaceUser.color.opacity(0.2))
                            .frame(width: UIScreen.main.bounds.width / 4, height: 100)
                            .overlay(Text("\(thirdPlaceUser.position)")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                            )
                    }
                }
                
                // 1st place
                if let firstPlaceUser = users.first(where: { $0.position == 1 }) {
                    VStack {
                        Image("CossackSmall")
                            .resizable()
                            .scaledToFit()
                        Text(firstPlaceUser.name)
                            .font(.headline)
                        Text("\(firstPlaceUser.points) pts")
                            .font(.subheadline)
                        UnevenRoundedRectangle(topLeadingRadius: 15, topTrailingRadius: 15)
                            .fill(firstPlaceUser.color.opacity(0.2))
                            .frame(width: UIScreen.main.bounds.width / 4, height: 150)
                            .overlay(Text("\(firstPlaceUser.position)")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                            )
                    }
                }
                
                // 2nd place
                if let secondPlaceUser = users.first(where: { $0.position == 2 }) {
                    VStack {
                        Image("CossackLong")
                            .resizable()
                            .scaledToFit()
                        Text(secondPlaceUser.name)
                            .font(.headline)
                        Text("\(secondPlaceUser.points) pts")
                            .font(.subheadline)
                        UnevenRoundedRectangle(topLeadingRadius: 15, topTrailingRadius: 15)
                            .fill(secondPlaceUser.color.opacity(0.2))
                            .frame(width: UIScreen.main.bounds.width / 4, height: 125)
                            .overlay(Text("\(secondPlaceUser.position)")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                            )
                    }
                }
            }
            
            // ScrollView for next places
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(users.dropFirst(3)) { user in
                        HStack {
                            Text("\(user.position)")
                                .font(.headline)
                                .frame(width: 30, alignment: .leading)
                            Text("👤 \(user.name)")
                                .font(.subheadline)
                            Spacer()
                            Text("\(user.points) pts")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding()
                    }
                }
                .padding(.top, 16)
                .background {
                    UnevenRoundedRectangle(topLeadingRadius: 25, topTrailingRadius: 25)
                        .fill(.yellow)
                }
            }
        }
    }
}

struct RatingScreen: View {
    @State private var selectedCategory = 0

    let categories = ["Weekly", "All Time"]

    let users = [
        User(name: "User 1", points: 500, position: 1, color: .white),
        User(name: "User 2", points: 300, position: 2, color: .white),
        User(name: "User 3", points: 200, position: 3, color: .white),
        User(name: "User 4", points: 180, position: 4, color: .white),
        User(name: "User 5", points: 170, position: 5, color: .white),
        User(name: "User 6", points: 160, position: 6, color: .white),
        User(name: "User 7", points: 150, position: 7, color: .white),
        User(name: "User 8", points: 140, position: 8, color: .white),
        User(name: "User 9", points: 130, position: 9, color: .white),
        User(name: "User 10", points: 120, position: 10, color: .white)
    ]
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemBlue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(0..<categories.count, id: \.self) { index in
                        Text(categories[index]).tag(index)
                    }
                }
                .padding()
                .background(.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 35))
                .pickerStyle(.segmented)
                .padding()
                

                if selectedCategory == 0 {
                    FirstView(users: users)
                } else {
                    SecondView(users: users)
                }
            }
            .background(.blue)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Leaderboard")
        }
    }
}

struct SecondView: View {
    let users: [User]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(users) { user in
                    HStack {
                        Text("\(user.position)")
                            .font(.headline)
                            .frame(width: 30, alignment: .leading)
                        Text("👤 \(user.name)")
                            .font(.subheadline)
                        Spacer()
                        Text("\(user.points) pts")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
            }
            .padding(.top, 16)
        }
    }
}


#Preview {
    RatingScreen()
}


#Preview {
    RatingScreen()
}
