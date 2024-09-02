import SwiftUI

struct CountryHistory: Identifiable {
    let id: UUID = .init()
    let image: String
    let name: String
}

struct OnboardingScreenThree: View {
    private let countries: [CountryHistory] = [
        CountryHistory(image: "ukraine", name: "Ukraine"),
        CountryHistory(image: "finland", name: "Finland"),
        CountryHistory(image: "usa", name: "USA")
    ]

    @State private var currentIndex: Int = 0
    
    private func goToNext() {
        withAnimation(.easeInOut) {
            if currentIndex < countries.count - 1 {
                currentIndex += 1
            }
        }
    }
    
    private func goToPrevious() {
        withAnimation(.easeInOut) {
            if currentIndex > 0 {
                currentIndex -= 1
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                ZStack {
                    TabView(selection: $currentIndex) {
                        ForEach(countries.indices, id: \.self) { index in
                            let country = countries[index]
                            VStack {
                                Image(country.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 300)
                                    .cornerRadius(15)
                                    .shadow(radius: 5)
                                Text(country.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.top, 10)
                            }
                            .padding()
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .padding()
                }
                // Previous Button
                HStack {
                    Button(action: goToPrevious) {
                        Image(systemName: "chevron.left")
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .disabled(currentIndex == 0)
                    Spacer()
                    
                    // Next Button
                    Button(action: goToNext) {
                        Image(systemName: "chevron.right")
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .disabled(currentIndex == countries.count - 1)
                }
                .padding(.horizontal, 30)
                Spacer()
                NavigationLink {
                    RootTabBar()
                } label: {
                    Text("Next")
                        .padding()
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(minWidth: UIScreen.main.bounds.width / 1.25)
                        .background(
                            UnevenRoundedRectangle(topLeadingRadius: 50, bottomLeadingRadius: 20, bottomTrailingRadius: 50, topTrailingRadius: 20)
                                .fill(Color.blue)
                        )
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 50, bottomLeadingRadius: 20, bottomTrailingRadius: 50, topTrailingRadius: 20))
                }
                .disabled(currentIndex == countries.count - 1)
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

extension OnboardingScreenThree {

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
            Text("Which history would you like to explore?")
                .font(.headline)
                .bold()
                .lineLimit(2)
                .multilineTextAlignment(.leading)
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
    OnboardingScreenThree()
}
