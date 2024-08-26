//import SwiftUI
//
//struct FindPairModuleView: View {
//    let findPairModule: FindPairModule
//    
//    @Binding var selectedPairs: [String: String]
//    @State private var authors: [String]
//    @State private var works: [String]
//    
//    init(findPairModule: FindPairModule, selectedPairs: Binding<[String: String]>) {
//        self.findPairModule = findPairModule
//        self._selectedPairs = selectedPairs
//        _authors = State(initialValue: findPairModule.correctPairs.keys.shuffled())
//        _works = State(initialValue: findPairModule.correctPairs.values.shuffled())
//    }
//    
//    var body: some View {
//        VStack {
//            Text(findPairModule.question)
//                .font(.title)
//                .padding()
//                .foregroundStyle(.accent)
//            
//            HStack {
//                VStack(alignment: .leading) {
//                    ForEach(authors, id: \.self) { author in
//                        HStack {
//                            Text(author)
//                                .padding()
//                                .background(Color.gray.opacity(0.2))
//                                .cornerRadius(8)
//                            
//                            Spacer()
//                            
//                            if let selectedWork = selectedPairs[author] {
//                                Text(selectedWork)
//                                    .padding()
//                                    .background(Color.green.opacity(0.2))
//                                    .cornerRadius(8)
//                                    .onTapGesture {
//                                        removeWork(author: author, work: selectedWork)
//                                    }
//                            } else {
//                                Rectangle()
//                                    .fill(Color.clear)
//                                    .frame(height: 40)
//                                    .frame(maxWidth: .infinity)
//                                    .overlay(
//                                        Text("Drop Here")
//                                            .foregroundColor(.gray)
//                                    )
//                                    .background(Color.blue.opacity(0.1))
//                                    .cornerRadius(8)
//                                    .onDrop(of: [.text], delegate: PairDropDelegate(author: author, selectedPairs: $selectedPairs, works: $works))
//                            }
//                        }
//                    }
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding()
//            }
//            
//            Spacer()
//            
//
//            HStack {
//                ForEach(works, id: \.self) { work in
//                    Text(work)
//                        .padding()
//                        .background(Color.blue.opacity(0.2))
//                        .cornerRadius(8)
//                        .onDrag {
//                            NSItemProvider(object: work as NSString)
//                        }
//                        .onTapGesture {
//                            selectWork(work)
//                        }
//                }
//            }
//            .padding()
//        }
//        .padding()
//    }
//    
//    private func selectWork(_ work: String) {
//        if let author = authors.first(where: { selectedPairs[$0] == nil }) {
//            selectedPairs[author] = work
//            works.removeAll { $0 == work }
//        }
//    }
//    
//    private func removeWork(author: String, work: String) {
//        selectedPairs.removeValue(forKey: author)
//        works.append(work)
//        works.sort()
//    }
//}
//
//struct PairDropDelegate: DropDelegate {
//    let author: String
//    @Binding var selectedPairs: [String: String]
//    @Binding var works: [String]
//    
//    func performDrop(info: DropInfo) -> Bool {
//        guard let item = info.itemProviders(for: [.text]).first else { return false }
//        
//        item.loadItem(forTypeIdentifier: "public.text", options: nil) { (data, error) in
//            if let data = data as? Data, let work = String(data: data, encoding: .utf8) {
//                DispatchQueue.main.async {
//                    selectedPairs[author] = work
//                    works.removeAll { $0 == work }  // Удаляем выбранное произведение из массива works
//                }
//            }
//        }
//        return true
//    }
//}
//
//#Preview {
//    GameView()
//}
//
