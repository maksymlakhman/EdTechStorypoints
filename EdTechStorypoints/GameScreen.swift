import SwiftUI

struct GameScreen: View {
    private let images: [String] = ["CossackLong", "CossackLarge", "CossackSmall", "Cossacks"]
    @State private var isAffermationViewButtonPressed: Bool = false
    @State private var isAppleWatchConnectivityViewButtonPressed: Bool = false
    @State private var isProfileViewButtonPressed: Bool = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 5) {
                ForEach(1..<15) { index in
                    HStack {
                        // Картинка зліва, якщо offset позитивний
                        if (index >= 4 && (index - 4) % 3 == 0) && LevelView(level: index).offset > 0 {
                            Image(images[(index - 4) % images.count])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        }

                        LevelView(level: index)
                            .transition(.slide)

                        // Картинка справа, якщо offset негативний
                        if (index >= 4 && (index - 4) % 3 == 0) && LevelView(level: index).offset < 0 {
                            Image(images[(index - 4) % images.count])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        }
                    }
                    .padding(.horizontal)
                }
            }

        }
        .configureNavigationBar()
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            leadingNavItems()
            trailingNavItems()
            centerNavItems()
        }
 
    }
}

struct LevelView: View {
    let level: Int
    
    var offset: CGFloat {
        switch (level - 1) % 14 {
        case 0:
            return UIScreen.main.bounds.width / -5
        case 1:
            return UIScreen.main.bounds.width / -8
        case 2:
            return UIScreen.main.bounds.width / 16
        case 3:
            return UIScreen.main.bounds.width / 8
        case 4:
            return UIScreen.main.bounds.width / 8
        case 5:
            return UIScreen.main.bounds.width / 24
        case 6:
            return UIScreen.main.bounds.width / -24
        case 7:
            return UIScreen.main.bounds.width / -4
        case 8:
            return UIScreen.main.bounds.width / 16
        case 9:
            return UIScreen.main.bounds.width / 8
        case 10:
            return UIScreen.main.bounds.width / 4
        case 11:
            return UIScreen.main.bounds.width / 16
        case 12:
            return UIScreen.main.bounds.width / -8
        case 13:
            return UIScreen.main.bounds.width / -6
        default:
            return UIScreen.main.bounds.width / -5
        }
    }
    
    var body: some View {
        HStack {
            VStack {
                Image(systemName: "graduationcap")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 25)
                    .padding()
                    .background(Color.yellow.opacity(0.8))
                    .clipShape(
                        Circle()
                    )
                    .shadow(radius: 5) // Додає тінь для глибини
                
                Text("Level \(level)")
                    .font(.headline)
                    .foregroundColor(.primary) // Залишає стандартний колір тексту
                    .padding(.top, 8)
                    .background(Color.white.opacity(0.6)) // Фон для тексту
                    .cornerRadius(8) // Краї з округленням
                    .shadow(radius: 2) // Легка тінь
            }
            .offset(x: offset)
            .animation(.easeInOut(duration: 0.3), value: offset) // Анімація при зміні offset
        }
        .frame(maxWidth: .infinity)
        .padding()
        .cornerRadius(10) // Округлення куточків
        .shadow(radius: 5) // Тінь для загального вигляду
    }
}

extension GameScreen {

    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            leadingNavView()
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            trailingNavView()
        }
    }
    
    @ToolbarContentBuilder
    private func centerNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            centerNavView()
        }
    }

    @ViewBuilder
    private func leadingNavView() -> some View {
        Button {
            withAnimation(.smooth) {
                isProfileViewButtonPressed.toggle()
            }
        } label: {
            Image(systemName: isProfileViewButtonPressed ? "person.circle.fill" : "person.crop.circle.dashed")
                .foregroundStyle(isProfileViewButtonPressed ? .blue : .white)
                .contentTransition(.symbolEffect(.replace.upUp.byLayer))
                .accessibilityLabel("Profile View Button")
                
        }
        .clipShape(Circle())
        .tint(Color.blue.opacity(0.1))
        .buttonStyle(.borderedProminent)
        .fullScreenCover(isPresented: $isProfileViewButtonPressed) {
            UserProfileScreen()
        }
    }
    
    @ViewBuilder
    private func centerNavView() -> some View {
        Button {
            withAnimation(.smooth) {
                isAffermationViewButtonPressed.toggle()
            }
        } label: {
            Image(systemName: isAffermationViewButtonPressed ? "doc.richtext" : "doc.richtext.fill")
                .foregroundStyle(isAffermationViewButtonPressed ? .blue : .white)
                .contentTransition(.symbolEffect(.replace.upUp.byLayer))
                .accessibilityLabel("Affermation For User")
        }        
        .clipShape(Circle())
        .tint(Color.blue.opacity(0.1))
        .buttonStyle(.borderedProminent)
        .sheet(isPresented: $isAffermationViewButtonPressed) {
            AffermationView()
                .presentationDetents([.medium])
        }
    }

    @ViewBuilder
    private func trailingNavView() -> some View {
        Button {
            withAnimation(.smooth) {
                isAppleWatchConnectivityViewButtonPressed.toggle()
            }
        } label: {
            Image(systemName: isAppleWatchConnectivityViewButtonPressed ? "applewatch.side.right" : "applewatch")
                .foregroundStyle(isAppleWatchConnectivityViewButtonPressed ? .blue : .white)
                .contentTransition(.symbolEffect(.replace.upUp.byLayer))
                .accessibilityLabel("Apple Watch")
        }
        .clipShape(Circle())
        .tint(Color.blue.opacity(0.1))
        .buttonStyle(.borderedProminent)
        .sheet(isPresented: $isAppleWatchConnectivityViewButtonPressed) {
            AppleWatchConnectivityView()
        }
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

extension View{
    func hAlign(_ alignment: Alignment) -> some View{
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}

#Preview {
    GameScreen()
}
