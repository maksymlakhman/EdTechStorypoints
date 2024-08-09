//
//  NavLinkButtonStyle.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 07.08.2024.
//

import SwiftUI

struct NavLinkButtonStyle: ButtonStyle {
    let background: Color
    let pressedBackground: Color
    let imageName: String
    let text: String

    func makeBody(configuration: Configuration) -> some View {
        VStack {
            ZStack {
                UnevenRoundedRectangle(topLeadingRadius: 50, bottomLeadingRadius: 20, bottomTrailingRadius: 50, topTrailingRadius: 20)
                    .fill(configuration.isPressed ? .white : .blue)

                Text(text)
                    .padding()
                    .foregroundStyle(configuration.isPressed ? .yellow : .white)
                    .font(.headline)
            }
            .frame(minWidth: configuration.isPressed ? UIScreen.main.bounds.width / 4 : UIScreen.main.bounds.width / 1.25)
            .animation(.smooth(duration: 0.3), value: configuration.isPressed)
        }
        .animation(.none, value: configuration.isPressed)
    }
}
