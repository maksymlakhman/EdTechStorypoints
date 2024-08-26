//
//  OnboardingView.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 06.08.2024.
//

import SwiftUI

struct Language: Identifiable {
    let id: UUID = UUID()
    let emojiFlag: String
    let text: String
}

struct OnboardingScreen: View {
    private let languages: [Language] = [
        Language(emojiFlag: "🇺🇦", text: "Українська"),
        Language(emojiFlag: "🇺🇸", text: "English"),
        Language(emojiFlag: "🇵🇱", text: "Polski"),
        Language(emojiFlag: "🇩🇪", text: "Deutsch"),
        Language(emojiFlag: "🇫🇷", text: "Français"),
        Language(emojiFlag: "🇮🇹", text: "Italiano"),
        Language(emojiFlag: "🇪🇸", text: "Español")
    ]

    @State private var selectedLanguage: UUID?

    private func toggleSelection(for language: Language) {
        withAnimation(.smooth) {
            if selectedLanguage == language.id {
                selectedLanguage = nil
            } else {
                selectedLanguage = language.id
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                LazyVStack(alignment: .leading, spacing: Constants.Spacing.small) {
                    ForEach(languages) { language in
                        HStack(alignment: .center) {
                            Label {
                                Text(language.text)
                                    .padding(.leading, Constants.Spacing.small)
                                    .font(.headline)
                                    .bold()
                            } icon: {
                                Text(language.emojiFlag)
                                    .padding(.leading, Constants.Spacing.small)
                                    .font(.largeTitle)
                            }
                            .multilineTextAlignment(.center)
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 25.0)
                                .foregroundStyle(selectedLanguage == language.id ? .blue : .black)
                                .padding(.horizontal, Constants.Spacing.small)
                        }
                        .shadow(
                            color: selectedLanguage == language.id ? Color.black.opacity(0.3) : Color.clear,
                            radius: selectedLanguage == language.id ? 5 : 0,
                            x: 10,
                            y: 5
                        )
                        .animation(.easeInOut(duration: 0.3), value: selectedLanguage == language.id)
                        .onTapGesture {
                            toggleSelection(for: language)
                        }
                    }
                }
                .foregroundStyle(.white)
                Spacer()
                NavigationLink {
                    OnboardingScreenTwo()
                } label: {
                    Text("Next")
                        .padding()
                        .foregroundStyle(selectedLanguage == nil ? .yellow : .white)
                        .font(.headline)
                        .frame(minWidth: selectedLanguage == nil ? UIScreen.main.bounds.width / 4 : UIScreen.main.bounds.width / 1.25)
                        .background {
                            UnevenRoundedRectangle(topLeadingRadius: 50, bottomLeadingRadius: 20, bottomTrailingRadius: 50, topTrailingRadius: 20)
                                .fill(selectedLanguage == nil ? .white : .blue)
                        }
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 50, bottomLeadingRadius: 20, bottomTrailingRadius: 50, topTrailingRadius: 20))
                }
                .disabled(selectedLanguage == nil)
            }
            .background(BlueBackgroundAnimatedGradient())
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                leadingNavItems()
            }
        }
    }

    private struct Constants {
        struct Spacing {
            static let zero: CGFloat = 0
            static let small: CGFloat = 12
            static let buttonPadding: CGFloat = 52
            static let horizontalPadding: CGFloat = 16
        }

        struct Dimensions {
            static let buttonCornerRadius: CGFloat = 8
            static let buttonHeight: CGFloat = 52
        }

        struct FontSizes {
            static let large: CGFloat = 32
            static let medium: CGFloat = 16
        }
    }
}

extension OnboardingScreen {

    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            leadingNavView()
        }
    }

    @ViewBuilder
    private func leadingNavView() -> some View {
        let navConstants = NavigationBarConstants()
        HStack(spacing: navConstants.leadingSpacing) {
            Text("Select the language of the app")
                .font(.headline)
                .bold()
        }
        .navigationBarPaddingBottomPercentage()
    }

    private struct NavigationBarConstants {
        let leadingSpacing: CGFloat = 6
        let leadingDefaultSpacing: CGFloat = 0
        let leadingSmallestFont: CGFloat = 12
        let leadingLargestFont: CGFloat = 14

        let trailingCornerRadius: CGFloat = 8
        let trailingImageWidth: CGFloat = 24
        let trailingImageHeight: CGFloat = 24
        let trailingStackWidth: CGFloat = 40
        let trailingStackHeight: CGFloat = 40
    }
}

extension View {
    func navigationBarPaddingBottomPercentage() -> some View {
        self.padding(.bottom, UIScreen.main.bounds.height * 0.01)
    }
}

#Preview {
    OnboardingScreen()
}
