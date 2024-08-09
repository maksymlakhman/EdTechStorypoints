//
//  NavigationBarModifier.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 09.08.2024.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor.systemBlue
                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                
                appearance.shadowColor = UIColor.black.withAlphaComponent(0.25)
                appearance.shadowImage = UIImage()
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
    }
}

extension View {
    func configureNavigationBar() -> some View {
        self.modifier(NavigationBarModifier())
    }
}
