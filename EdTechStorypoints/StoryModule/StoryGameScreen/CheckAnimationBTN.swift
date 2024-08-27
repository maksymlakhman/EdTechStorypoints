//
//  CheckAnimationBTN.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 16.08.2024.
//

import SwiftUI

struct CheckAnimationBTN: View {
    @State var rotation: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .frame(height: 50)
                .foregroundStyle(.blue.opacity(0.5))
            
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .frame(height: 50)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors:
                                                                        [.blue.opacity(0.8), .purple, .teal, .pink.opacity(0.8)]), startPoint:
                        .top, endPoint: .bottom))
                .rotationEffect(.degrees(rotation))
                .mask {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(lineWidth: 1)
                        .frame(height: 50)
                }
            Text("Check")
                .bold()
                .font(.title3)
                .foregroundStyle(.white)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 3.5).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

#Preview {
    CheckAnimationBTN()
}
