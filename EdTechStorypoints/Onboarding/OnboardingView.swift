//
//  OnboardingView.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 06.08.2024.
//

import SwiftUI

struct Option: Identifiable {
    let id: UUID = UUID()
    let imageName: String
    let selectedImageName: String
    let text: String
}



struct OnboardingScreen: View {
    private let options: [Option] = [
        Option(imageName: "star.fill", selectedImageName: "star.circle.fill", text: "Success & Achievements"),
        Option(imageName: "heart.fill", selectedImageName: "heart.circle.fill", text: "Love & Care"),
        Option(imageName: "leaf.fill", selectedImageName: "leaf.circle.fill", text: "Nature & Growth"),
        Option(imageName: "bolt.fill", selectedImageName: "bolt.horizontal.fill", text: "Energy & Power"),
        Option(imageName: "moon.fill", selectedImageName: "moon.circle.fill", text: "Mystery & Dreams"),
        Option(imageName: "sun.max.fill", selectedImageName: "sun.max.circle.fill", text: "Light & Warmth"),
        Option(imageName: "globe.europe.africa.fill", selectedImageName: "globe.asia.australia.fill", text: "World & Exploration")
    ]


    @State private var selectedOptions: Set<UUID> = []
    
    private func toggleSelection(for option: Option) {
        withAnimation(.smooth) {
            if selectedOptions.contains(option.id) {
                selectedOptions.remove(option.id)
            } else {
                selectedOptions.insert(option.id)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 0)
                    .fill(.yellow)
                    .ignoresSafeArea()
                    
                
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
                                    Image(systemName: selectedOptions.contains(option.id) ? option.selectedImageName : option.imageName)
                                        .padding(.leading, Constants.Spacing.small)
                                        .contentTransition(.symbolEffect(.replace))
                                        .foregroundColor(selectedOptions.contains(option.id) ? .white : .yellow)
                                        
                                }
                                .multilineTextAlignment(.center)
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundStyle(selectedOptions.contains(option.id) ? .blue : .black)
                                    .padding(.horizontal, Constants.Spacing.small)
                            }
                            .shadow(
                                color: selectedOptions.contains(option.id) ? Color.black.opacity(0.3) : Color.clear,
                                radius: selectedOptions.contains(option.id) ? 5 : 0,
                                x: 10,
                                y: 5
                            )
                            .animation(.easeInOut(duration: 0.3), value: selectedOptions.contains(option.id))
                            .onTapGesture {
                                toggleSelection(for: option)
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
                            .foregroundStyle(selectedOptions.isEmpty ? .yellow : .white)
                            .font(.headline)
                            .frame(minWidth: selectedOptions.isEmpty ? UIScreen.main.bounds.width / 4 : UIScreen.main.bounds.width / 1.25)
                            .background {
                                UnevenRoundedRectangle(topLeadingRadius: 50, bottomLeadingRadius: 20, bottomTrailingRadius: 50, topTrailingRadius: 20)
                                    .fill(selectedOptions.isEmpty ? .white : .blue)
                            }
                            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 50, bottomLeadingRadius: 20, bottomTrailingRadius: 50, topTrailingRadius: 20))
                    }
                    .disabled(selectedOptions.isEmpty)
                }
            }
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
            Text("Why do you study History?")
                .font(.title)
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
