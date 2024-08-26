//import SwiftUI
//
//struct ChronologyModuleView: View {
//    let chronologyModule: ChronologyModule
//
//    @State private var eventList: [String]
//    @State private var years: [String]
//
//    init(chronologyModule: ChronologyModule) {
//        self.chronologyModule = chronologyModule
//        _years = State(initialValue: chronologyModule.events.keys.sorted())
//        _eventList = State(initialValue: chronologyModule.events.values.shuffled())
//    }
//
//    var body: some View {
//        VStack {
//            Text(chronologyModule.question)
//                .font(.title)
//                .padding()
//                .foregroundStyle(.accent)
//
//            HStack {
//                VStack(alignment: .leading) {
//                    ForEach(years, id: \.self) { year in
//                        Text(year)
//                            .padding()
//                            .background(Color.gray.opacity(0.2))
//                            .cornerRadius(8)
//                    }
//                    .padding(.bottom, 5)
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding()
//
//                VStack {
//                    ForEach(eventList.indices, id: \.self) { index in
//                        Text(eventList[index])
//                            .padding()
//                            .background(Color.blue.opacity(0.2))
//                            .cornerRadius(8)
//                            .onDrag {
//                                NSItemProvider(object: eventList[index] as NSString)
//                            }
//                            .onDrop(of: [.text], delegate: ChronologyEventDropDelegate(
//                                eventIndex: index,
//                                eventList: $eventList
//                            ))
//                    }
//                }
//                .padding()
//            }
//        }
//        .padding()
//    }
//}
//
//struct ChronologyEventDropDelegate: DropDelegate {
//    let eventIndex: Int
//    @Binding var eventList: [String]
//
//    func performDrop(info: DropInfo) -> Bool {
//        guard let item = info.itemProviders(for: [.text]).first else { return false }
//        
//        item.loadItem(forTypeIdentifier: "public.text", options: nil) { (data, error) in
//            if let data = data as? Data, let draggedEvent = String(data: data, encoding: .utf8) {
//                DispatchQueue.main.async {
//                    if let draggedEventIndex = eventList.firstIndex(of: draggedEvent) {
//                        eventList.swapAt(draggedEventIndex, eventIndex)
//                    }
//                }
//            }
//        }
//        return true
//    }
//}
//
//
//#Preview {
//    ChronologyModuleView(
//        chronologyModule: ChronologyModule(question: "Arrange the events in chronological order:", events: [
//            "1798": "Taras Shevchenko publishes 'Kobzar'",
//            "1867": "Ivan Franco publishes 'Zakhar Berkut'",
//            "1934": "First Congress of Ukrainian Writers",
//            "1991": "Proclamation of Ukrainian Independence"
//        ]))
//    
//
//}
