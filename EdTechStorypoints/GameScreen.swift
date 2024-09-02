import SwiftUI

struct GameScreen: View {
    private let images: [String] = ["CossackLong", "CossackLarge", "CossackSmall", "Bride"]
    @State private var activeLevel: Int = 11
    @State private var isAffermationViewButtonPressed: Bool = false
    @State private var isAppleWatchConnectivityViewButtonPressed: Bool = false
    @State private var isProfileViewButtonPressed: Bool = false
 
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { index in
                    VStack {
                        Text("Module Title \(index + 1)")
                            .padding()
                            .font(.headline)
                        ForEach(1..<15) { levelIndex in
                            HStack {
                                // Картинка зліва, якщо offset позитивний
                                if (levelIndex >= 4 && (levelIndex - 4) % 3 == 0) && LevelView(level: levelIndex, activeLevel: $activeLevel).offset > 0 {
                                    Image(images[(levelIndex - 4) % images.count])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                }

                                LevelView(level: levelIndex, activeLevel: $activeLevel)
                                    .transition(.slide)

                                // Картинка справа, якщо offset негативний
                                if (levelIndex >= 4 && (levelIndex - 4) % 3 == 0) && LevelView(level: levelIndex, activeLevel: $activeLevel).offset < 0 {
                                    Image(images[(levelIndex - 4) % images.count])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
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


enum LevelStatus {
    case active, completed, locked
}

struct LevelView: View {
    let level: Int
    @Binding var activeLevel: Int
    @State private var isStartGameLevelViewButtonPressed: Bool = false
    @State private var showContextButtons: Bool = false

    @EnvironmentObject var gameViewModel: GameViewModel
    var status: LevelStatus {
        if activeLevel == level {
            return .active
        } else if level < activeLevel {
            return .completed
        } else {
            return .locked
        }
    }

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
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    ZStack {
                        Button {
                            withAnimation(.spring) {
                                showContextButtons.toggle()
                            }
                           
                        } label: {
                            Image(systemName: "graduationcap")
                                .resizable()
                                .scaledToFit()
                                .offset(x: -1, y: -1)
                                .foregroundStyle(status == .active ? .white : .blue.opacity(0.6))
                                .frame(width: 75, height: 25)
                                .padding()
                                .background {
                                    Circle()
                                        .fill(status == .active ? .blue.opacity(0.8) : (status == .completed ? .white.opacity(0.6) : .blue.opacity(0.6)))
                                        .offset(x: -2.5, y: -5)
                                }
                                .background(status == .active ? Color.white.opacity(0.2) : (status == .completed ? Color.blue : Color.black))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        if showContextButtons {
                            withAnimation(.easeInOut(duration: 1.5)) {
                                VStack(spacing: 4) {
                                    Button {
                                        
                                    } label: {
                                        Text("Jump to Module")
                                            .padding(4)
                                            .background(Capsule().fill(.black))
                                    }
  
                                    Button {
                                        isStartGameLevelViewButtonPressed.toggle()
                                    } label: {
                                        Text("Play")
                                            .padding(4)
                                            .background(
                                                Capsule()
                                                    .fill(.black)
                                            )
                                    }

                                    
                                }
                                .padding(4)
                                .foregroundStyle(status == .active ? .white : .blue)
                                .background(status == .active ? .blue.opacity(0.8) : (status == .completed ? .white.opacity(0.6) : .blue.opacity(0.6)))
                                .background(status == .active ? Color.white.opacity(0.2) : (status == .completed ? Color.blue : Color.black))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .offset(x: offset < 0 ? UIScreen.main.bounds.width / 4 : -UIScreen.main.bounds.width / 4)
                            }
 
                        }

                    }
                }
                .offset(x: offset)
                .animation(.easeInOut(duration: 0.3), value: offset)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .cornerRadius(10)
            .shadow(radius: 5)
            .opacity(status == .locked ? 0.5 : 1.0)
            .disabled(status == .locked)
            .fullScreenCover(isPresented: $isStartGameLevelViewButtonPressed) {
                GameView()
            }
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
        .sheet(isPresented: $isProfileViewButtonPressed) {
            UserProfileScreen()
                .presentationDetents([.custom(MyDetent.self)])
                .presentationDragIndicator(.visible)
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
        .fullScreenCover(isPresented: $isAffermationViewButtonPressed) {
            GameNewsScreen()
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

struct MyDetent: CustomPresentationDetent {
    // 1
    static func height(in context: Context) -> CGFloat? {
        // 2
        return max(50, context.maxDetentValue * 0.6)
    }
}

extension View{
    func hAlign(_ alignment: Alignment) -> some View{
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment) -> some View{
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
}

#Preview {
    GameScreen()
        .background(BlueBackgroundAnimatedGradient())
}
