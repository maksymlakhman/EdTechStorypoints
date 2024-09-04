//
//  ComplexAnimatedGradient.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 13.08.2024.
//

import SwiftUI
import Combine
import MulticolorGradient

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct BlueBackgroundAnimatedGradient: View {
    @State private var animationAmount: CGFloat = 0.0
    @State private var timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            MulticolorGradient {
                ColorStop(position: .top, color: Color.black)
                ColorStop(position: UnitPoint(x: 0.5 + sin(animationAmount * 0.8) * 0.5,
                                              y: 0.5 + cos(animationAmount * 0.8) * 0.5), color: Color.black)
                ColorStop(position: UnitPoint(x: 0.5 - sin(animationAmount) * 0.25,
                                              y: 0.5 + cos(animationAmount) * 0.5), color: Color.black)
                ColorStop(position: UnitPoint(x: 0.5, y: 0.5), color: Color.blue)
            }
            .noise(12.0)
            .edgesIgnoringSafeArea(.all)
            .onReceive(timer) { time in
                animationAmount += 1.0 / 60.0
            }
        }.onAppear {
            timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()
        }.onDisappear {
            timer.upstream.connect().cancel()
        }
    }
    
}

#Preview {
    BlueBackgroundAnimatedGradient()
}

struct OrangeBackgroundAnimatedGradient: View {
    @State private var animationAmount: CGFloat = 0.0
    @State private var timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            MulticolorGradient {
                ColorStop(position: .top, color: Color.black)
                ColorStop(position: UnitPoint(x: 0.5 + sin(animationAmount * 0.8) * 0.5,
                                              y: 0.5 + cos(animationAmount * 0.8) * 0.5), color: Color.orange)
                ColorStop(position: UnitPoint(x: 0.5 - sin(animationAmount) * 0.25,
                                              y: 0.5 + cos(animationAmount) * 0.5), color: Color.yellow)
                ColorStop(position: UnitPoint(x: 0.5, y: 0.5), color: Color.yellow)
            }
            .noise(12.0)
            .edgesIgnoringSafeArea(.all)
            .onReceive(timer) { time in
                animationAmount += 1.0 / 60.0
            }
        }.onAppear {
            timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()
        }.onDisappear {
            timer.upstream.connect().cancel()
        }
    }
    
}

#Preview {
    OrangeBackgroundAnimatedGradient()
}
