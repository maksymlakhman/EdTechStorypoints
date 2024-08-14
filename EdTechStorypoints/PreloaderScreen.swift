//
//  PreloaderScreen.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 06.08.2024.
//

import Lottie
import SwiftUI

struct PreloaderScreen: View {

    var body: some View {
        ZStack(alignment: .center){
            icon()
            LottieView(loopMode: .loop)
                .scaleEffect(Constants.Dimensions.scaleEffect)
        }
        .ignoresSafeArea()
        .background(Color.blue)
    }
    
    func icon() -> some View {
        VStack(spacing: Constants.Icon.spacing) {
            RoundedRectangle(cornerRadius: Constants.Icon.cornerRadius)
                .fill(Color.pink)
                .frame(width: Constants.Icon.width, height: Constants.Icon.height)
        }
    }
    
    private struct Constants {
        struct Dimensions {
            static let scaleEffect : CGFloat = 0.4
        }
        struct Icon {
            static let spacing : CGFloat = 0
            static let cornerRadius : CGFloat = 30
            static let width : CGFloat = 123
            static let height : CGFloat = 123
        }
    }
}

#Preview {
    PreloaderScreen()
}

