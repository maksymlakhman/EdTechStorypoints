import SwiftUI

struct ChronologyModuleView: View {
    @State private var shuffledEvents: [String]
    @State private var eventsForYears: [Int: String]
    
    let module: ChronologyModule
    
    init(module: ChronologyModule) {
        self.module = module
        self._shuffledEvents = State(initialValue: module.getShuffledEvents())
        self._eventsForYears = State(initialValue: Dictionary(uniqueKeysWithValues: module.eventsWithYears.keys.sorted().map { ($0, "") }))
    }
    
    var body: some View {
        VStack {
            Text(module.question)
                .font(.headline)
                .padding()
            
            HStack {
                // Column for years
                VStack {
                    ForEach(module.eventsWithYears.keys.sorted(), id: \.self) { year in
                        Text("\(year)")
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onDrop(of: [.text], delegate: DropViewDelegate(year: year, eventsForYears: $eventsForYears, shuffledEvents: $shuffledEvents))
                    }
                }
                
                // Column for events
                VStack {
                    ForEach(shuffledEvents, id: \.self) { event in
                        Text(event)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                            .onDrag {
                                NSItemProvider(object: event as NSString)
                            }
                            .onDrop(of: [.text], delegate: EventDropViewDelegate(event: event, shuffledEvents: $shuffledEvents))
                    }
                }
            }
            
            Spacer()
            
            HStack {
                Button("Check") {
                    // Create expected order from the module
                    let expectedOrder = module.eventsWithYears.sorted(by: { $0.key < $1.key }).map { $0.value }
                    
                    
                    // Check if userOrder matches the expectedOrder
                    let isCorrect = shuffledEvents == expectedOrder
                    if isCorrect {
                        print("Correct Order!")
                    } else {
                        print("Incorrect Order.")
                        print("Expected: \(expectedOrder)")
                    }
                }
                
                Button("Shuffle") {
                    shuffledEvents = module.getShuffledEvents()
                }
            }
            .padding()
        }
    }
}


struct EventDropViewDelegate: DropDelegate {
    let event: String
    @Binding var shuffledEvents: [String]
    
    func performDrop(info: DropInfo) -> Bool {
        if let itemProvider = info.itemProviders(for: [.text]).first {
            itemProvider.loadDataRepresentation(forTypeIdentifier: "public.text") { data, _ in
                if let data = data, let draggedEvent = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        withAnimation {
                            if let draggedIndex = shuffledEvents.firstIndex(of: draggedEvent),
                               let targetIndex = shuffledEvents.firstIndex(of: self.event) {
                                shuffledEvents.swapAt(draggedIndex, targetIndex)
                            }
                            print("Shuffled events after drop: \(shuffledEvents)")
                        }
                    }
                }
            }
            return true
        }
        return false
    }
}

struct DropViewDelegate: DropDelegate {
    let year: Int
    @Binding var eventsForYears: [Int: String]
    @Binding var shuffledEvents: [String]
    
    func performDrop(info: DropInfo) -> Bool {
        if let itemProvider = info.itemProviders(for: [.text]).first {
            itemProvider.loadDataRepresentation(forTypeIdentifier: "public.text") { data, _ in
                if let data = data, let draggedEvent = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        withAnimation {
                            // Update eventsForYears with the dragged event
                            eventsForYears[year] = draggedEvent
                            
                            // Update shuffledEvents to reflect the change
                            if let index = shuffledEvents.firstIndex(of: draggedEvent) {
                                shuffledEvents.remove(at: index)
                            }
                            print("Events for years after drop: \(eventsForYears)")
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
    GameView()
}
