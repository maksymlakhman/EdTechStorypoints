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
                        
                        HStack() {
                            Button {
                                if viewModel.isFirstAIAssistantIsUser {
                                    
                                } else {
                                    viewModel.showFreemiumSheet = true
                                }
                            } label: {
                                Image("CossackLarge")
                                    .resizable()
                                    .frame(width: 40)
                            }

                            Button {
                                print("AI 2")
                            } label: {
                                Image("CossackLong")
                                    .resizable()
                                    .frame(width: 40)
                            }
                            .disabled(!viewModel.freemiumIsActive)
                            .opacity(viewModel.freemiumIsActive ? 1.0 : 0.5)

                            Button {
                                print("AI 3")
                            } label: {
                                Image("CossackSmall")
                                    .resizable()
                                    .frame(width: 40)
                            }
                            .disabled(!viewModel.freemiumIsActive)
                            .opacity(viewModel.freemiumIsActive ? 1.0 : 0.5)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .padding()
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
                            .padding(.horizontal)
                    }
                }
                .sheet(isPresented: $viewModel.showFreemiumSheet) {
                    VStack {
                        Text("Купити додаткові 2 AI асистенти?")
                            .padding()
                        
                        Button {
                            viewModel.freemiumIsActive = true
                            viewModel.showFreemiumSheet = false
                        } label: {
                            Label("Buy", systemImage: "brain.fill")
                                .foregroundStyle(.black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.yellow)
                                )
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue)
                    .presentationDetents([.fraction(0.15)])
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
}

#Preview {
    GameView()
}
