//
//  OnboardingScreenTwo.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 07.08.2024.
//

import SwiftUI

struct TimeOption: Identifiable {
    let id: UUID = UUID()
    let imageName: String
    let selectedImageName: String
    let text: String
}

struct OnboardingScreenTwo: View {
    private let options: [TimeOption] = [
        TimeOption(imageName: "clock", selectedImageName: "deskclock.fill", text: "5 min"),
        TimeOption(imageName: "clock", selectedImageName: "deskclock.fill", text: "10 min"),
        TimeOption(imageName: "clock", selectedImageName: "deskclock.fill", text: "25 min"),
        TimeOption(imageName: "clock", selectedImageName: "deskclock.fill", text: "40 min")
    ]

    @State private var selectedOption: UUID? = nil
    
    private func toggleSelection(for option: TimeOption) {
        withAnimation(.smooth) {
            if selectedOption == option.id {
                selectedOption = nil
            } else {
                selectedOption = option.id
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                VStack(alignment: .center) {
                    LazyVStack(alignment: .leading, spacing: Constants.Spacing.small) {
                        ForEach(options) { option in
                            HStack(alignment: .center) {
                                Label {
                                    Text(option.text)
                                        .padding(.leading, Constants.Spacing.small)
                                        .font(.headline)
                                        .bold()
                                } icon: {
                                    Image(systemName: selectedOption == option.id ? option.selectedImageName : option.imageName)
                                        .padding(.leading, Constants.Spacing.small)
                                        .contentTransition(.symbolEffect(.replace))
                                        .foregroundColor(selectedOption == option.id ? .white : .yellow)
                                }
                                .multilineTextAlignment(.center)
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundStyle(selectedOption == option.id ? .blue : .black)
                                    .padding(.horizontal, Constants.Spacing.small)
                            }
                            .shadow(
                                color: selectedOption == option.id ? Color.black.opacity(0.3) : Color.clear,
                                radius: selectedOption == option.id ? 5 : 0,
                                x: 10,
                                y: 5
                            )
                            .onTapGesture {
                                toggleSelection(for: option)
                            }
                        }
                    }
                    .foregroundStyle(.white)
                    Spacer()
                    NavigationLink {
                        OnboardingScreenThree()
                    } label: {
                        Text("Next")
                            .padding()
                            .foregroundStyle(selectedOption == nil ? .yellow : .white)
                            .font(.headline)
                            .frame(minWidth: selectedOption == nil ? UIScreen.main.bounds.width / 4 : UIScreen.main.bounds.width / 1.25)
                            .background(
                                UnevenRoundedRectangle(topLeadingRadius: 50, bottomLeadingRadius: 20, bottomTrailingRadius: 50, topTrailingRadius: 20)
                                    .fill(selectedOption == nil ? .white : .blue)
                                    
                            )
                            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 50, bottomLeadingRadius: 20, bottomTrailingRadius: 50, topTrailingRadius: 20))
                    }
                    .disabled(selectedOption == nil)
                }
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

extension OnboardingScreenTwo {

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
            Text("How much time are you willing to devote?")
                .font(.headline)
                .bold()
                .lineLimit(2)
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


#Preview {
    OnboardingScreenTwo()
}
