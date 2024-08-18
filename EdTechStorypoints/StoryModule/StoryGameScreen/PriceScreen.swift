//
//  PriceScreen.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 17.08.2024.
//

import SwiftUI

struct PriceScreen: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            Text("PriceScreen!")
            Button {
                dismiss()
            } label: {
                Text("Back")
            }

        }
    }
}

#Preview {
    PriceScreen()
}
