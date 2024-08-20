import SwiftUI

struct ChronologyModuleView: View {
    let chronologyModule: ChronologyModule

    @EnvironmentObject private var vm: GameViewModel

    @Binding var eventList: [String]

    @State private var years: [String]

    init(chronologyModule: ChronologyModule, eventList: Binding<[String]>) {
        self.chronologyModule = chronologyModule
        self._eventList = eventList
        _years = State(initialValue: chronologyModule.events.keys.sorted())
    }

    var body: some View {
        VStack {
            Text(chronologyModule.question)
                .font(.title)
                .padding()
                .foregroundStyle(.accent)

            HStack {
                // Колонка з роками
                VStack(alignment: .leading) {
                    ForEach(years, id: \.self) { year in
                        Text(year)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .padding(.bottom, 5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

                // Колонка з подіями
                VStack {
                    ForEach(eventList.indices, id: \.self) { index in
                        Text(eventList[index])
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                            .onDrag {
                                NSItemProvider(object: eventList[index] as NSString)
                            }
                            .onDrop(of: [.text], delegate: ChronologyEventDropDelegate(
                                eventIndex: index,
                                eventList: $eventList
                            ))
                    }
                }
                .padding()
            }
        }
        .padding()
    }
}


struct ChronologyDropDelegate: DropDelegate {
    let year: String
    @Binding var events: [String: String]
    @Binding var eventList: [String]

    func performDrop(info: DropInfo) -> Bool {
        guard let item = info.itemProviders(for: [.text]).first else { return false }
        
        item.loadItem(forTypeIdentifier: "public.text", options: nil) { (data, error) in
            if let data = data as? Data, let event = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    events[year] = event
                    if let oldYear = events.first(where: { $0.value == event })?.key, oldYear != year {
                        events.removeValue(forKey: oldYear)
                        eventList.append(event)
                        eventList.sort()
                    }
                }
            }
        }
        return true
    }
}

struct ChronologyEventDropDelegate: DropDelegate {
    let eventIndex: Int
    @Binding var eventList: [String]

    func performDrop(info: DropInfo) -> Bool {
        guard let item = info.itemProviders(for: [.text]).first else { return false }
        
        item.loadItem(forTypeIdentifier: "public.text", options: nil) { (data, error) in
            if let data = data as? Data, let draggedEvent = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    if let draggedEventIndex = eventList.firstIndex(of: draggedEvent) {
                        eventList.swapAt(draggedEventIndex, eventIndex)
                    }
                }
            }
        }
        return true
    }
}

#Preview {
    ChronologyModuleView(
        chronologyModule: ChronologyModule(question: "Arrange the events in chronological order:", events: [
            "1798": "Taras Shevchenko publishes 'Kobzar'",
            "1867": "Ivan Franco publishes 'Zakhar Berkut'",
            "1934": "First Congress of Ukrainian Writers",
            "1991": "Proclamation of Ukrainian Independence"
        ]), eventList: .constant([])
    )

}
