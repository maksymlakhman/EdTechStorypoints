//
//  ProgressBarView.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 27.08.2024.
//

import SwiftUI

struct ProgressBarView: View {
    @Binding var progress: Double
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack(alignment: .center) {
                ProgressView(value: progress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(height: 10)
                
                LinearGradient(gradient: Gradient(colors: [.white, .cyan, .blue]), startPoint: .leading, endPoint: .trailing)
                    .mask(
                        ProgressView(value: progress, total: 1.0)
                            .progressViewStyle(LinearProgressViewStyle())
                            .frame(height: 10)
                    )
            }
            .animation(.linear(duration: 1.5), value: progress)
        }
    }
}

#Preview {
    ProgressBarView(progress: .constant(0.9))
}
