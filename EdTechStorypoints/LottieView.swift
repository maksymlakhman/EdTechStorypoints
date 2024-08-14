//
//  LottieView.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 06.08.2024.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let loopMode: LottieLoopMode

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        
    }

    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: "Preloader")
        animationView.play()
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        return animationView
    }
}
