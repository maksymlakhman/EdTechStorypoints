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
            Text("Drag the option on the right to match the choice on the left.")
                .font(.system(size: 24))
                .fontWeight(.medium)
                .frame(maxWidth: .infinity,alignment:.leading)
                .padding(20)
            HStack {
                leftStack
                /// Right Draggable Stack
                rightStack
            }.padding(.horizontal,20)
        }
    }
    
    var leftStack: some View {
        VStack{
            ForEach(viewModel.leftTitles, id: \.self) { item in
                VStack {
                    Text(item)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity,alignment:.leading)
                        .padding(.horizontal,16)
                        .minimumScaleFactor(0.01)
                        .foregroundStyle(.red)
                }
                .frame(height:50)
                .background(Color.gray)
                .cornerRadius(12, corners: [.topLeft, .bottomLeft])
            }
        }
    }
    
    var rightStack: some View {
        LazyVStack() {
            ForEach(viewModel.items, id:\.self) { item in
                VStack {
                    Text(item)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity,alignment:.leading)
                        .padding(.horizontal,16)
                        .minimumScaleFactor(0.01)
                        .foregroundStyle(.blue)
                }
                .frame(height:50)
                .background(Color.white)
                .overlay(
                    CornerShape(radius: 12, corners: [.topRight, .bottomRight])
                        .stroke(Color.gray, lineWidth: 4)
                )
                .cornerRadius(12, corners: [.topRight, .bottomRight])
                .contentShape([.dragPreview],CornerShape(radius: 12, corners: [.topRight, .bottomRight]))
                .overlay(viewModel.currentItem == item && viewModel.isDragging ? .white: .clear)
                .onDrag {
                    viewModel.currentItem = item
                    return NSItemProvider(contentsOf: URL(string: "\(item)"))!
                }
                .onDrop(of: [.text], delegate: ItemDropDelegate(item: item, model: viewModel))
            }
        }
    }
}

class ChronologyViewModel: ObservableObject {
    @Published var leftTitles: [String]
    @Published var items: [String]
    @Published var currentItem: String?
    @Published var isDragging = false
    var correctPairs: [String: String]
    var module: ChronologyModuleProtocol
    
    init(module: ChronologyModuleProtocol) {
        self.module = module
        self.leftTitles = module.correctPairsCronology.keys.sorted()
        self.items = module.correctPairsCronology.values.shuffled()
        self.correctPairs = module.correctPairsCronology
    }

    func checkAnswer() -> Bool {
        let pairedItems = Dictionary(uniqueKeysWithValues: zip(leftTitles, items))
        return pairedItems == correctPairs
    }
}

#Preview {
    GameView()
}



//MARK: Drop Delegate
struct ItemDropDelegate: DropDelegate {
    let item: String
    var model: ChronologyViewModel
    
    /// Drop finished work
    func performDrop(info: DropInfo) -> Bool {
        model.currentItem = nil
        model.isDragging = false
        return true
    }
    
    /// Moving style without "+" icon
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    /// Object is dragged off of the onDrop view.
    func dropExited(info: DropInfo) {
        model.isDragging = false
    }
    
    /// Object is dragged over the onDrop view.
    func dropEntered(info: DropInfo) {
        model.isDragging = true
        guard let dragItem = model.currentItem, dragItem != item,
              let from = model.items.firstIndex(of: dragItem),
              let to = model.items.firstIndex(of: item) else {return}
        model.items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
    }
}

//MARK: Specific corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(CornerShape(radius: radius, corners: corners))
    }
}

struct CornerShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
