//
//  EdTechStorypointsApp.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 06.08.2024.
//

import SwiftUI

@main
struct EdTechStorypointsApp: App {
    @State private var showPreloader = true
    @State private var isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    var body: some Scene {
        WindowGroup {
            if showPreloader {
                PreloaderScreen()
                    .preferredColorScheme(.dark)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                showPreloader = false
                                if isFirstLaunch {
                                    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                                }
                            }
                        }
                    }
            } else {
                Group {
                    if isFirstLaunch {
                        OnboardingScreen()

                    } else {
                        RootTabBar()
                    }
                }
                .preferredColorScheme(.dark)
            }
        }
    }
}
