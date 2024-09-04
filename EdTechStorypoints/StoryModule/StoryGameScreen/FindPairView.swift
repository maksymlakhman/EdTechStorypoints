import SwiftUI

struct CircularTextView: View {
    @State var letterWidths: [Int:Double] = [:]
    
    @State var title: String
    
    var lettersOffset: [(offset: Int, element: Character)] {
        return Array(title.enumerated())
    }
    var radius: Double
    
    var body: some View {
        ZStack {
            ForEach(lettersOffset, id: \.offset) { index, letter in // Mark 1
                VStack {
                    Text(String(letter))
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundColor(.white)
                        .bold()
                        .kerning(5)
                        .background(LetterWidthSize()) // Mark 2
                        .onPreferenceChange(WidthLetterPreferenceKey.self, perform: { width in  // Mark 2
                            letterWidths[index] = width
                        })
                    Spacer() // Mark 1
                }
                .rotationEffect(fetchAngle(at: index)) // Mark 3
            }
        }
        .frame(width: 100, height: 100)
        .rotationEffect(.degrees(214))
    }
    
    func fetchAngle(at letterPosition: Int) -> Angle {
        let times2pi: (Double) -> Double = { $0 * 2 * .pi }
        
        let circumference = times2pi(radius)
                        
        let finalAngle = times2pi(letterWidths.filter{$0.key <= letterPosition}.map(\.value).reduce(0, +) / circumference)
        
        return .radians(finalAngle)
    }
}

struct WidthLetterPreferenceKey: PreferenceKey {
    static var defaultValue: Double = 0
    static func reduce(value: inout Double, nextValue: () -> Double) {
        value = nextValue()
    }
}

struct LetterWidthSize: View {
    var body: some View {
        GeometryReader { geometry in // using this to get the width of EACH letter
            Color
                .clear
                .preference(key: WidthLetterPreferenceKey.self,
                            value: geometry.size.width)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CircularTextView(title: "Kobzar".uppercased(), radius: 25)
    }
}

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
                                ZStack {
                                    CircularTextView(title: selectedWork.uppercased(), radius: 30)
                                        .padding(10)
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .background(OrangeBackgroundAnimatedGradient())
                                        .foregroundStyle(.white)
                                        .onTapGesture {
                                            withAnimation(.smooth) {
                                                viewModel.removeWork(author: author, work: selectedWork)
                                            }
                                        }
                                        .onDrag {
                                            NSItemProvider(object: selectedWork as NSString)
                                        }
                                        .onDrop(of: [.text], delegate: PairDropDelegate(author: author, selectedPairs: $viewModel.selectedPairs, works: $viewModel.works))
                                        .clipShape(Circle())
                                    if let correctWork = viewModel.module.correctPairs[author]?.keys.first,
                                       let year = viewModel.module.correctPairs[author]?[correctWork] {
                                        Text(year)
                                            .frame(width: 100, height: 100)
                                            .padding(10)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                    }
                                }
                            } else {
                                if let correctWork = viewModel.module.correctPairs[author]?.keys.first,
                                let year = viewModel.module.correctPairs[author]?[correctWork] {
                                Text(year)
                                    .frame(width: 100, height: 100)
                                    .padding(10)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .background(OrangeBackgroundAnimatedGradient())
                                    .font(.headline)
                                    .onDrop(of: [.text], delegate: PairDropDelegate(author: author, selectedPairs: $viewModel.selectedPairs, works: $viewModel.works))
                                    .clipShape(Circle())
                                }
                                
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
            .frame(height: UIScreen.main.bounds.height / 6.5)
            
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity)
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
        self.works = module.correctPairs.values.flatMap { $0.keys }
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
        // Flatten the correctPairs into a single-level array of tuples
        let flattenedCorrectPairs = module.correctPairs.flatMap { author, worksDict in
            worksDict.map { work, _ in (author, work) }
        }

        // Flatten the selectedPairs into a single-level array of tuples
        let flattenedSelectedPairs = selectedPairs.map { author, work in (author, work) }

        // Sort the arrays to ensure order does not affect the comparison
        let sortedCorrectPairs = flattenedCorrectPairs.sorted { $0.0 < $1.0 }
        let sortedSelectedPairs = flattenedSelectedPairs.sorted { $0.0 < $1.0 }

        // Compare the sorted arrays manually
        if sortedCorrectPairs.count != sortedSelectedPairs.count {
            return false
        }

        for (index, pair) in sortedCorrectPairs.enumerated() {
            if pair != sortedSelectedPairs[index] {
                return false
            }
        }

        return true
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
                "Panteleimon Kulish": ["Chorna Rada" : "2064"],
                "Marko Vovchok": ["Marusia" : "1996"]
            ]
        )))
        .background(BlueBackgroundAnimatedGradient())
}


#Preview {
    GameView()
}
