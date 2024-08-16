//
//  UserProfileScreen.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 12.08.2024.
//

import SwiftUI

struct UserProfileScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var userName: String = "John Doe"
    @State private var userEmail: String = "johndoe@example.com"
    @State private var userPassword: String = "********"
    @State private var isEditingName: Bool = false
    var body: some View {
        NavigationStack() {
           VStack(spacing: 30) {
               // Аватар користувача
               VStack {
                   Image(systemName: "person.circle.fill")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 100, height: 100)
                       .foregroundColor(.blue)
                   
                   Button(action: {
                       // Дія для зміни аватара
                   }) {
                       Text("Change Avatar")
                           .font(.caption)
                           .foregroundColor(.blue)
                   }
               }
               .padding(.top, 50)
               
               // Ім'я користувача
               VStack(alignment: .leading, spacing: 8) {
                   HStack {
                       if isEditingName {
                           TextField("Enter your name", text: $userName)
                               .textFieldStyle(RoundedBorderTextFieldStyle())
                               .padding(.trailing, 10)
                           
                           Button("Save") {
                               withAnimation {
                                   isEditingName.toggle()
                               }
                           }
                           .font(.headline)
                           .foregroundColor(.blue)
                       } else {
                           Text(userName)
                               .font(.largeTitle)
                               .fontWeight(.bold)
                           
                           Spacer()
                           
                           Button(action: {
                               withAnimation(.smooth) {
                                   isEditingName.toggle()
                               }
                           }) {
                               Image(systemName: "pencil")
                                   .foregroundColor(.blue)
                           }
                       }
                   }
               }
               .padding(.horizontal)
               
               // Інформація про користувача
               VStack(alignment: .leading, spacing: 16) {
                   UserInfoRow(title: "Email", value: userEmail)
                   UserInfoRow(title: "Password", value: userPassword)
               }
               .padding(.horizontal)

               // Кнопка виходу
               Button(action: {
                   // Дія для виходу з профілю
               }) {
                   Text("Log Out")
                       .font(.headline)
                       .foregroundColor(.red)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.red.opacity(0.2))
                       .cornerRadius(10)
               }
               .padding(.horizontal)
               Spacer()
           }
           .background(BlueBackgroundAnimatedGradient())
        }
    }
}

struct UserInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}

// Опції налаштувань
struct SettingsOption: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30, height: 30)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}


extension UserProfileScreen {
    
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
                .accessibilityLabel("Profile View Button")
        }
        .clipShape(Circle())
        .tint(Color.blue.opacity(0.1))
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    UserProfileScreen()
}
