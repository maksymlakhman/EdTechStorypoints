import SwiftUI

struct FlowLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let subSizes = subviews.map { $0.sizeThatFits(proposal) }

        let proposedWidth = proposal.width ?? .infinity
        var maxRowWidth = CGFloat.zero
        var rowCount = CGFloat.zero
        var x = CGFloat.zero
        for subSize in subSizes {
            let lineBreakAllowed = x > 0

            if lineBreakAllowed, x + subSize.width > proposedWidth {
                rowCount += 1
                x = 0
            }

            x += subSize.width
            maxRowWidth = max(maxRowWidth, x)
        }

        if x > 0 {
            rowCount += 1
        }

        let rowHeight = subSizes.lazy.map { $0.height }.max() ?? 0
        return CGSize(
            width: proposal.width ?? maxRowWidth,
            height: rowCount * rowHeight
        )
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let subSizes = subviews.map { $0.sizeThatFits(proposal) }
        let rowHeight = subSizes.lazy.map { $0.height }.max() ?? 0
        let proposedWidth = proposal.width ?? .infinity

        var p = CGPoint.zero
        for (subview, subSize) in zip(subviews, subSizes) {
            let lineBreakAllowed = p.x > 0

            if lineBreakAllowed, p.x + subSize.width > proposedWidth {
                p.x = 0
                p.y += rowHeight
            }

            subview.place(
                at: CGPoint(
                    x: bounds.origin.x + p.x,
                    y: bounds.origin.y + p.y + 0.5 * (rowHeight - subSize.height)
                ),
                proposal: proposal
            )

            p.x += subSize.width
        }
    }
}

struct FindPairView: View {
    @EnvironmentObject var viewModel: FindPairViewModel
    @Environment(\.dismiss) var dismiss
    func colorForIndex(_ index: Int) -> Color {
        switch index {
        case 0: return .purple
        case 1: return .pink
        case 2: return .cyan
        case 3: return .orange
        default: return .gray
        }
    }
    
    func textForIndex(_ index: Int) -> String {
        switch index {
        case 0: return "A"
        case 1: return "B"
        case 2: return "C"
        case 3: return "D"
        default: return "Empty"
        }
    }

    var body: some View {
        VStack {
            Spacer()
 
            Text(viewModel.module.question)
                .font(.headline)
                .foregroundStyle(.white)
            
            HStack {
                VStack(alignment: .center) {
                    ForEach(Array(viewModel.authors.enumerated()), id: \.element) { index, author in
                        VStack(alignment: .center) {
                            HStack {
                                Text(textForIndex(index))  // Додаємо літеру A, B, C, D
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(colorForIndex(index))
                                    .clipShape(Circle())
                                
                                Text(author)
                                    .padding(5)
                                    .frame(maxWidth: .infinity)
                                    .background(colorForIndex(index))
                                    .foregroundStyle(.white)
                                    .cornerRadius(8)
                            }
                            
                            if let selectedWork = viewModel.selectedPairs[author] {
                                Text(selectedWork)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 16)
                                    .padding(10)
                                    .foregroundStyle(.white)
                                    .background(colorForIndex(index))
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        withAnimation(.smooth) {
                                            viewModel.removeWork(author: author, work: selectedWork)
                                        }
                                    }
                                    .onDrag {
                                        NSItemProvider(object: selectedWork as NSString)
                                    }
                                    .onDrop(of: [.text], delegate: PairDropDelegate(author: author, selectedPairs: $viewModel.selectedPairs, works: $viewModel.works))
                            } else {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 16)
                                    .padding(10)
                                    .overlay(
                                        Text("Drop Here")
                                            .foregroundColor(.gray)
                                    )
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                                    .onDrop(of: [.text], delegate: PairDropDelegate(author: author, selectedPairs: $viewModel.selectedPairs, works: $viewModel.works))
                                    
                            }
                        }
                        .padding(5)
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .frame(height: UIScreen.main.bounds.height / 2.5)
            Spacer()
            FlowLayout {
                ForEach(viewModel.works.shuffled(), id: \.self) { work in
                    Text(work)
                        .padding()
                        .background(Capsule().fill(.blue.opacity(0.5)))
                        .foregroundStyle(.white)
                        .bold()
                        .lineLimit(1)
                        .onDrag {
                            NSItemProvider(object: work as NSString)
                        }
                        .onTapGesture {
                            withAnimation(.spring) {
                                viewModel.selectWork(work)
                            }
                        }
                }
            }
            .padding()
            
            
        }

    }
}

class FindPairViewModel: ObservableObject {
    @Published var module: FindPairModuleProtocol
    @Published var authors: [String]
    @Published var works: [String]
    @Published var selectedPairs: [String: String] = [:]
    
    init(module: FindPairModuleProtocol) {
        self.module = module
        self.authors = Array(module.correctPairs.keys)
        self.works = Array(module.correctPairs.values)
    }
    
    func selectWork(_ work: String) {
        if let author = authors.first(where: { selectedPairs[$0] == nil }) {
            selectedPairs[author] = work
            works.removeAll { $0 == work }
        }
    }
    
    func removeWork(author: String, work: String) {
        selectedPairs.removeValue(forKey: author)
        works.append(work)
    }
    
    func checkAnswer() -> Bool {
        return selectedPairs == module.correctPairs
    }
}

struct PairDropDelegate: DropDelegate {
    let author: String
    @Binding var selectedPairs: [String: String]
    @Binding var works: [String]

    func performDrop(info: DropInfo) -> Bool {
        if let item = info.itemProviders(for: [.text]).first {
            item.loadItem(forTypeIdentifier: "public.text", options: nil) { (data, error) in
                if let data = data as? Data, let newWork = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        // Перевірка, чи робота вже встановлена для іншого автора
                        if let existingAuthor = selectedPairs.first(where: { $0.value == newWork })?.key {
                            // Заміна старої роботи на нову
                            let previousWork = selectedPairs[author]
                            selectedPairs[existingAuthor] = previousWork
                            selectedPairs[author] = newWork
                        } else {
                            // Перевірка, чи вже є робота для цього автора
                            if let existingWork = selectedPairs[author] {
                                // Повернення старої роботи назад до списку works
                                works.append(existingWork)
                            }
                            
                            // Додавання нової роботи для автора
                            selectedPairs[author] = newWork
                            works.removeAll { $0 == newWork }
                        }
                    }
                }
            }
            return true
        }
        return false
    }
}



#Preview {
    FindPairView()
        .environmentObject(FindPairViewModel(module: .init(
            question: "Match the authors to their works",
            correctPairs: [
                "1Panteleimon Kulish": "1Chorna Rada",
                "2Marko Vovchok": "2Marusia",
                "3Hryhorii Skovoroda": "3Garden of Divine Songs",
                "4Ivan Nechuy-Levytskyi": "4Kaidasheva Family"
            ]
        )))
        .background(BlueBackgroundAnimatedGradient())
}


#Preview {
    GameView()
}
