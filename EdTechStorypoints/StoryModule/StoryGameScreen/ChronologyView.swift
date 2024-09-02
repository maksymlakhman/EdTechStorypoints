//
//  ChronologyView.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 30.08.2024.
//

import SwiftUI

struct ChronologyView: View {
    @EnvironmentObject var viewModel: ChronologyViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
//            Text(viewModel.module.question)
//            // Ваша логіка для ChronologyView
            Button {
                dismiss()
            } label: {
                Image(systemName: "house")
            }
        }
    }
}

class ChronologyViewModel: ObservableObject {
    var module: ChronologyModuleProtocol
    var checkAnswerAction: (() -> Bool)?

    init(module: ChronologyModuleProtocol) {
        self.module = module
    }

    func checkAnswer() -> Bool {
        return checkAnswerAction?() ?? false
    }
}

#Preview {
    GameView()
}
