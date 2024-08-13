//
//  UserProfileScreen.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 12.08.2024.
//

import SwiftUI

struct UserProfileScreen: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack() {
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack {
                    Text("Helloo USer!")
                }
            }
            .toolbar {
                leadingNavItems()
            }
            .background(.blue)
        }
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
                .padding(5)
                .hAlign(.leading)
                .background {
                    Circle()
                        .fill(.white)
                }
                .foregroundStyle(.blue)
                .contentTransition(.symbolEffect(.replace.upUp.byLayer))
                .accessibilityLabel("Profile View Button")
        }
        .tint(.blue)
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    UserProfileScreen()
}
