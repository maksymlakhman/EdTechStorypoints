//
//  GameView.swift
//  EdTechStorypoints
//
//  Created by Макс Лахман on 27.08.2024.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @Environment(\.dismiss) private var dismiss
    @State var rotation: CGFloat = 0.0
    var body: some View {
        VStack {
            if viewModel.isGameFinished {
                PriceScreen()
                    .environmentObject(viewModel)
            } else {
                VStack(spacing: 0) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundStyle(.white)
                                .contentTransition(.symbolEffect(.replace.upUp.byLayer))
                                .accessibilityLabel("Back Button to ARScreen")
                        }
                        .clipShape(Circle())
                        .tint(Color.blue.opacity(0.1))
                        .buttonStyle(.borderedProminent)
    
                        Spacer()
    
                        ProgressBarView(progress: $viewModel.progress)
                        
                        Spacer()
                        AIAssistantButton(
                            buttons: Array(ArcMenuButtonName.allCases),
                            ontap: { button in
                                handleAIAssistantButtonTap(button: button)
                            }
                        )
                        .environmentObject(viewModel)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .padding()
                    .zIndex(10)
                    Spacer()
                    
                    Group {
                        switch viewModel.currentModule.moduleType {
                        case .quiz:
                            QuizView()
                                .environmentObject(viewModel.quizViewModel!)
                        case .findPair:
                            FindPairView()
                                .environmentObject(viewModel.findPairViewModel!)
                        case .chronology:
                            ChronologyView()
                                .environmentObject(viewModel.chronologyViewModel!)
                        }
                    }
                    Spacer()
                    .zIndex(9)
                    
                    
                    HStack(spacing: 0) {
                        Button {
                            let isCorrect = viewModel.checkAnswer()
                            if isCorrect {
                                viewModel.showCorrectSheet = true
                            } else {
                                viewModel.showIncorrectSheet = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    viewModel.showIncorrectSheet = false
                                }
                            }
                        } label: {
                            CheckAnimationBTN()
                                
                        }
                    }
                    .padding(.horizontal)
                    .zIndex(10)
                }
                .sheet(isPresented: $viewModel.showAIAssistantSheet) {
                    VStack {
                        Text("Generation Answear here")
                            .padding()
                        Spacer()
                        if viewModel.generateAnswearAI {
                            Text("some text")
                                .padding()
                        }
                        Spacer()
                        Button {
                            if !viewModel.generateAnswearAI {
                                viewModel.generateAnswearAI = true
                            } else {
                                viewModel.isFirstAIAssistantIsUser = false
                                viewModel.showAIAssistantSheet = false
                                viewModel.generateAnswearAI = false
                            }
                        } label: {
                            Text(!viewModel.generateAnswearAI ? "Generate AI Answer" : "Close Answer" )
                                .foregroundStyle(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.blue.opacity(0.2))
                                )
                        }

                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(BlueBackgroundAnimatedGradient())
                    .presentationDetents([.medium])
                }
                .alert("To open additional AI assistants, you need Freemium", isPresented: $viewModel.isShowAlertFreemiumView){
                    
                }
                .sheet(isPresented: $viewModel.showFreemiumSheet) {
                    VStack {
                        Text("Buy 2 additional AI assistants?")
                            .padding()
                        
                        Button {
      
                                viewModel.freemiumIsActive = true
                                viewModel.activateAllButtons()
                                viewModel.showFreemiumSheet = false


                        } label: {
                            Label("Buy", systemImage: "brain.fill")
                                .foregroundStyle(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.blue.opacity(0.2))
                                )
                        }
                        .padding(.horizontal)
                        Button {
                            viewModel.showFreemiumSheet = false
                        } label: {
                            Label("Cancel", systemImage: "xmark")
                                .foregroundStyle(.red)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.red.opacity(0.2))
                                )
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(BlueBackgroundAnimatedGradient())
                    .presentationDetents([.fraction(0.25)])
                }
                .sheet(isPresented: $viewModel.showCorrectSheet) {
                    HStack {
                        if let randomPhrase = viewModel.correctPhrases.randomElement() {
                            Label(randomPhrase, systemImage: "face.smiling.inverse")
                                .foregroundColor(.white)
                                .padding()
                                .font(.headline)
                        }
                        Spacer()
                        Button("Next") {
                            viewModel.nextModule()
                            viewModel.showCorrectSheet = false
                            viewModel.showIncorrectSheet = false
                            viewModel.updateProgress()
                        }
                        .padding()
                        .background(Capsule().fill(.yellow))
                        .foregroundColor(.black)
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(BlueBackgroundAnimatedGradient())
                    .presentationDetents([.fraction(0.15)])
                }
                .sheet(isPresented: $viewModel.showIncorrectSheet) {
                    HStack(alignment: .center, spacing: 0) {
                        if let randomPhrase = viewModel.incorrectPhrases.randomElement() {
                            Label(randomPhrase, systemImage: "xmark.octagon")
                                .foregroundColor(.red)
                                .font(.title3)
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(BlueBackgroundAnimatedGradient())
                    .presentationDetents([.fraction(0.15)])
                }
            }
        }
        .background(BlueBackgroundAnimatedGradient())
    }
    
    private func handleAIAssistantButtonTap(button: ArcMenuButtonName) {
        print("handleAIAssistantButtonTap called with button: \(button.rawValue)")
        switch button {
        case .cossackLarge:
            if viewModel.freemiumIsActive {
                viewModel.showAIAssistantSheet = true
            } else if viewModel.isFirstAIAssistantIsUser {
                viewModel.showAIAssistantSheet = true
            } else {
                viewModel.showFreemiumSheet = true
            }
        case .cossackLong:
            if viewModel.freemiumIsActive {
                viewModel.showAIAssistantSheet = true
            } else {
                viewModel.isShowAlertFreemiumView = true
            }
        case .cossackSmall:
            if viewModel.freemiumIsActive {
                viewModel.showAIAssistantSheet = true
            } else {
                viewModel.isShowAlertFreemiumView = true
            }
        }
    }
}

#Preview {
    GameView()
}
