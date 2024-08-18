//import SwiftUI
//
//struct Pair: Hashable {
//    let first: String
//    let second: String
//}
//
//struct FindPairTask: GameTask {
//    let id = UUID()
//    let pairs: [Pair]
//    let correctPhrases: [String]
//    let incorrectPhrases: [String]
//    var taskType: TaskType {
//        return .findPair
//    }
//    
//    func view(progress: Binding<Double>, onNext: @escaping () -> Void) -> AnyView {
//        AnyView(
//            FindPairView(
//                pairs: pairs,
//                correctPhrases: correctPhrases,
//                incorrectPhrases: incorrectPhrases,
//                onNext: onNext
//            )
//        )
//    }
//    
//    func checkAnswer(_ answer: Any) -> Bool {
//        return true
//    }
//}
