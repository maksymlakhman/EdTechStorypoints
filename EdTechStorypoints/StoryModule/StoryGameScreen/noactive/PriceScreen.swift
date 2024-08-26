//
//  PriceScreen.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 17.08.2024.
//

import SwiftUI

struct PriceScreen: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: GameViewModel
    var body: some View {
        VStack {
            Text("PriceScreen!")
            Button {
                dismiss()
                viewModel.restartGame()
            } label: {
                Text("Play Again")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

        }
    }
}

#Preview {
    PriceScreen()
}
