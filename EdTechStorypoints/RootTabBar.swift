//
//  RootTabBar.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 06.08.2024.
//
import SwiftUI

struct AnimatedTabItem: View {
    let tabIcon: String
    let tabText: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: tabIcon)
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.5), value: isSelected)
            Text(tabText)
        }
    }
}

struct RootTabBar: View {
    @State private var programmaticSelectedIndex = 4
    @State private var gradientView = ComplexAnimatedGradient()
    var body: some View {
        TabView(selection: $programmaticSelectedIndex) {
            NavigationStack {
                GameScreen()
                    .background(gradientView)
            }
            .tabItem {
                AnimatedTabItem(tabIcon: "building.columns", tabText: "Home", isSelected: programmaticSelectedIndex == 0)
            }
            .tag(0)

            NavigationStack {
                LastHistoryNewsScreen()
                    .background(gradientView)
            }
            .tabItem {
                AnimatedTabItem(tabIcon: "graduationcap.fill", tabText: "Home", isSelected: programmaticSelectedIndex == 1)
            }
            .tag(1)
            
            NavigationStack {
                RatingScreen()
                    .background(gradientView)
            }
            .tabItem {
                AnimatedTabItem(tabIcon: "trophy.fill", tabText: "Home", isSelected: programmaticSelectedIndex == 2)
            }
            .tag(2)
            
            NavigationStack {
                HistorycalLibraryScreen()
                    .background(gradientView)
            }
            .tabItem {
                AnimatedTabItem(tabIcon: "books.vertical.fill", tabText: "Home", isSelected: programmaticSelectedIndex == 3)
            }
            .tag(3)
            
            NavigationStack {
                ARScreen()
                    .background(gradientView)
            }
            .tabItem {
                AnimatedTabItem(tabIcon: "arkit", tabText: "AR", isSelected: programmaticSelectedIndex == 4)
            }
            .tag(4)
        }
        .tint(.blue)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor(Color.blue.opacity(0.2))
            
            UITabBarItem.appearance().badgeColor = .systemBlue
//            // Use this appearance when scrolling behind the TabView:
            UITabBar.appearance().standardAppearance = appearance
//            // Use this appearance when scrolled all the way up:
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            UITabBar.appearance().unselectedItemTintColor = .systemGray
//            UITabBar.appearance().backgroundColor = .systemGray4.withAlphaComponent(0.4)
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        }
        
    }
}

#Preview {
    RootTabBar()
}

//@available(iOS 15.0, *)
//struct RootTabBar: View {
//    
//    @State var index : Int = 0
//    
//    init() {
//        UITabBar.appearance().isHidden = true
//    }
//    var body: some View {
//        
//        VStack {
//            
//            ZStack {
//                GameScreen()
//                    .opacity(self.index == 0 ? 1 : 0)
//                
//                LastHistoryNewsScreen()
//                    .opacity(self.index == 1 ? 1 : 0)
//                
//                RatingScreen()
//                    .opacity(self.index == 2 ? 1 : 0)
//                
//                HistorycalLibraryScreen()
//                    .opacity(self.index == 3 ? 1 : 0)
//                
//                ARScreen()
//                    .opacity(self.index == 4 ? 1 : 0)
//            }
//            .padding(.bottom, -35)
//            
//            CustomTabBar3View(index: self.$index)
//        }
////        .background(Color.white)
//        .ignoresSafeArea(edges: .top)
//    }
//}
//
//
//struct CustomTabBar3View : View {
//    
//    @Binding var index : Int
//    @State private var scaleHome: CGFloat = 1.0
//    @State private var scaleTrophy: CGFloat = 1.0
//    @State private var scaleBooks: CGFloat = 1.0
//    @State private var rotation: Double = 0
//    @State private var rotationTwo: Double = 0
//    
//    var body: some View {
//        
//        HStack {
//            
//            Button {
//                withAnimation(.easeInOut(duration: 0.3)) {
//                   self.index = 0
//                    scaleHome = 1.2
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    scaleHome = 1.0
//                }
//            } label: {
//                Image(systemName: index == 0 ? "building.columns.fill" : "building.columns")
//                    .scaleEffect(scaleHome)
//                    .animation(.spring(duration: 0.3), value: scaleHome)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
//                            .foregroundColor(.yellow)
//                            .padding(-3)
//                            .opacity(index == 0 ? 1 : 0)
//                    )
//            }
//            .font(.title3)
//            .foregroundColor(index == 0 ? .yellow : .white)
//            
//            Spacer()
//            
//            Button {
//                withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
//                    self.index = 1
//                    rotationTwo += 360
//                }
//            } label: {
//                Image(systemName: index == 1 ? "graduationcap.fill" : "graduationcap")
//                    .rotationEffect(.degrees(rotationTwo))
//                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: rotationTwo)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
//                            .foregroundColor(.yellow)
//                            .padding(-3)
//                            .opacity(index == 1 ? 1 : 0)
//                    )
//            }
//            .font(.title3)
//            .foregroundColor(index == 1 ? .yellow : .white)
//           
//            
//            Spacer()
//
//            
//            Button {
//                withAnimation(.easeInOut(duration: 0.3)) {
//                   self.index = 2
//                    scaleTrophy = 1.2
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    scaleTrophy = 1.0
//                }
//            } label: {
//                Image(systemName: index == 2 ? "trophy.fill" : "trophy")
//                    .accessibilityLabel("Tab Item Trophy or Leaderboard Screen")
//                    .scaleEffect(scaleTrophy)
//                    .animation(.spring(duration: 0.3), value: scaleTrophy)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
//                            .foregroundColor(.yellow)
//                            .padding(-3)
//                            .opacity(index == 2 ? 1 : 0)
//                    )
//            }
//            .font(.title3)
//            .foregroundColor(index == 2 ? .yellow : .white)
//            
//            Spacer()
//            
//            Button {
//                withAnimation(.easeInOut(duration: 0.3)) {
//                   self.index = 3
//                    scaleBooks = 1.2
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    scaleBooks = 1.0
//                }
//            } label: {
//                Image(systemName: index == 3 ? "books.vertical.fill" : "books.vertical")
//                    .scaleEffect(scaleBooks)
//                    .animation(.spring(duration: 0.3), value: scaleBooks)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
//                            .foregroundColor(.yellow)
//                            .padding(-3)
//                            .opacity(index == 3 ? 1 : 0)
//                    )
//            }
//            .font(.title3)
//            .foregroundColor(index == 3 ? .yellow : .white)
//            
//            
//            Spacer()
//            
//            Button { 
//                withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
//                    self.index = 4
//                    rotation += 360
//                }
//            } label: {
//                Image(systemName: "arkit")
//                    .rotationEffect(.degrees(rotation))
//                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: rotation)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
//                            .foregroundColor(.yellow)
//                            .padding(-3)
//                            .opacity(index == 4 ? 1 : 0)
//                    )
//            }
//            .font(.title3)
//            .foregroundColor(index == 4 ? .yellow : .white)
//
//            
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.horizontal, 35)
////        .padding(.top, 15)
//        .background(Color.white.opacity(0.2))
//    }
//}


#Preview {
    RootTabBar()
}

