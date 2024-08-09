//
//  AffermationView.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 09.08.2024.
//

import SwiftUI

struct AffermationView: View {
    let image : String = "BohdanKhmelnytsky"
    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            Text("You remind me of Bohdan Khmelnytsky — you embody the same determination and courage that inspire the fight for justice and freedom.")
                                .font(.system(size: 16))
                                .multilineTextAlignment(.leading)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                                .padding([.leading, .trailing], 20)
        }
    }
}

#Preview {
    AffermationView()
}
