//import SwiftUI
//
//enum GameModuleType {
//    case quiz(QuizModule)
//    case findPair(FindPairModule)
//    case chronology(ChronologyModule)
//}
//
//struct AnyGameModule {
//    let moduleType: GameModuleType
//    
//    init(_ quizModule: QuizModule) {
//        self.moduleType = .quiz(quizModule)
//    }
//    
//    init(_ findPairModule: FindPairModule) {
//        self.moduleType = .findPair(findPairModule)
//    }
//    
//    init(_ chronologyModule: ChronologyModule) {
//        self.moduleType = .chronology(chronologyModule)
//    }
//    
//    func checkAnswer(_ answer: Any) -> Bool {
//         switch moduleType {
//         case .quiz(let quizModule):
//             if let answer = answer as? Int {
//                 return quizModule.checkAnswer(answer)
//             }
//         case .findPair(let findPairModule):
//             if let answer = answer as? [String: String] {
//                 return findPairModule.checkAnswer(answer)
//             }
//         case .chronology(let chronologyModule):
//             if let answer = answer as? [String: String] {
//                 return chronologyModule.checkAnswer(answer)
//             }
//         }
//         return false
//     }
//}
//
//
//
//protocol GameModule {
//    associatedtype AnswerType
//    var question: String { get }
//    func checkAnswer(_ answer: AnswerType) -> Bool
//}
//
//struct QuizModule: GameModule {
//    typealias AnswerType = Int
//    
//    var question: String
//    var image: String
//    var options: [String]
//    var correctAnswer: Int
//    
//    func checkAnswer(_ answer: AnswerType) -> Bool {
//        return answer == correctAnswer
//    }
//}
//
//struct FindPairModule: GameModule {
//    typealias AnswerType = [String: String]
//    
//    var question: String
//    var correctPairs: AnswerType
//    
//    func checkAnswer(_ answer: AnswerType) -> Bool {
//        return answer == correctPairs
//    }
//}
//
//
//struct ChronologyModule: GameModule {
//    typealias AnswerType = [String: String]
//    
//    var question: String
//    var events: AnswerType
//    
//    func checkAnswer(_ answer: AnswerType) -> Bool {
//        return answer == events
//    }
//}
//
//
//#Preview {
//    GameView()
//}
