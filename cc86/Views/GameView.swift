//
//  GameView.swift
//  MystiQuotient: Word Wizardry
//

import SwiftUI

struct GameView: View {
    let level: Int
    @StateObject private var viewModel = GameViewModel()
    @Binding var userProgress: UserProgress
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(hex: "1D1F30")
                .ignoresSafeArea()
            
            if viewModel.currentPuzzle == nil {
                // Loading state
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "FE284A")))
                        .scaleEffect(1.5)
                    
                    Text("Loading...")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 20)
                }
            } else if viewModel.showStory {
                storyView
            } else {
                gamePlayView
            }
        }
        .onAppear {
            viewModel.loadPuzzle(level: level)
        }
        .sheet(isPresented: $viewModel.showCompletion) {
            CompletionView(
                earnedPoints: viewModel.earnedPoints,
                totalScore: viewModel.score,
                level: level,
                onContinue: {
                    viewModel.completeLevel(progress: &userProgress)
                    SettingsService.shared.saveProgress(userProgress)
                    dismiss()
                }
            )
        }
        .sheet(isPresented: $viewModel.showGameOver) {
            GameOverView(
                level: level,
                onRetry: {
                    viewModel.loadPuzzle(level: level)
                },
                onExit: {
                    dismiss()
                }
            )
        }
    }
    
    private var storyView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            if let story = viewModel.currentStory {
                VStack(spacing: 20) {
                    // Chapter indicator
                    Text("Chapter \(story.levelNumber)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "FE284A"))
                        .tracking(2)
                    
                    // Title
                    Text(story.title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    // Character name
                    if let character = story.characterName {
                        Text(character)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .italic()
                    }
                    
                    // Narrative
                    Text(story.narrative)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "1D1F30"))
                                .shadow(color: Color.black.opacity(0.3), radius: 10, x: -5, y: -5)
                                .shadow(color: Color.white.opacity(0.02), radius: 10, x: 5, y: 5)
                        )
                        .padding(.horizontal, 20)
                    
                    // Mystery clue
                    HStack(spacing: 10) {
                        Image(systemName: "sparkles")
                            .foregroundColor(Color(hex: "FE284A"))
                        Text(story.mysteryClue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .italic()
                    }
                    .padding(.top, 10)
                }
            }
            
            Spacer()
            
            // Begin puzzle button
            NeumorphicButton(title: "Begin Puzzle", action: {
                withAnimation {
                    viewModel.startGame()
                }
            })
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
    
    private var gamePlayView: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(Color(hex: "1D1F30"))
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: -3, y: -3)
                                .shadow(color: Color.white.opacity(0.02), radius: 5, x: 3, y: 3)
                        )
                }
                
                Spacer()
                
                // Level indicator
                Text("Level \(level)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Timer or attempts
                if let timeRemaining = viewModel.timeRemaining {
                    HStack(spacing: 5) {
                        Image(systemName: "timer")
                            .foregroundColor(timeRemaining < 30 ? Color(hex: "FE284A") : .white)
                        Text("\(timeRemaining)s")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(timeRemaining < 30 ? Color(hex: "FE284A") : .white)
                    }
                    .frame(width: 70, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "1D1F30"))
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: -3, y: -3)
                            .shadow(color: Color.white.opacity(0.02), radius: 5, x: 3, y: 3)
                    )
                } else {
                    HStack(spacing: 5) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color(hex: "FE284A"))
                        Text("\(viewModel.currentPuzzle?.maxAttempts ?? 0 - viewModel.attempts)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(width: 60, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "1D1F30"))
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: -3, y: -3)
                            .shadow(color: Color.white.opacity(0.02), radius: 5, x: 3, y: 3)
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 50)
            
            Spacer()
            
            // Hint
            if let puzzle = viewModel.currentPuzzle {
                VStack(spacing: 15) {
                    // Instruction
                    Text("Tap letters below to spell the word")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                        .tracking(0.5)
                    
                    Text("Hint")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "FE284A"))
                        .tracking(1)
                    
                    Text(puzzle.hint)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                .padding(.vertical, 20)
            }
            
            // Answer area
            HStack(spacing: 12) {
                ForEach(Array(viewModel.selectedLetters.enumerated()), id: \.offset) { index, letter in
                    Button(action: {
                        viewModel.deselectLetter(at: index)
                    }) {
                        Text(letter)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(viewModel.isWrong ? Color.red.opacity(0.3) : Color(hex: "FE284A"))
                                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: -3, y: -3)
                                    .shadow(color: Color(hex: "FE284A").opacity(0.3), radius: 5, x: 3, y: 3)
                            )
                    }
                    .animation(.easeInOut(duration: 0.2), value: viewModel.isWrong)
                }
                
                // Empty slots
                if let puzzle = viewModel.currentPuzzle {
                    ForEach(viewModel.selectedLetters.count..<puzzle.targetWord.count, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 2, antialiased: true)
                            .frame(width: 50, height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "1D1F30"))
                                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 5, y: 5)
                                    .shadow(color: Color.white.opacity(0.01), radius: 5, x: -5, y: -5)
                            )
                    }
                }
            }
            .padding(.vertical, 30)
            
            Spacer()
            
            // Available letters
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                ForEach(Array(viewModel.availableLetters.enumerated()), id: \.element.id) { index, tile in
                    Button(action: {
                        viewModel.selectLetter(at: index)
                    }) {
                        Text(tile.letter)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(tile.isUsed ? .white.opacity(0.3) : .white)
                            .frame(width: 70, height: 70)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(hex: "1D1F30"))
                                    .shadow(color: tile.isUsed ? Color.clear : Color.black.opacity(0.3), radius: 8, x: -4, y: -4)
                                    .shadow(color: tile.isUsed ? Color.clear : Color.white.opacity(0.02), radius: 8, x: 4, y: 4)
                            )
                            .opacity(tile.isUsed ? 0.5 : 1.0)
                    }
                    .disabled(tile.isUsed)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            // Action buttons
            HStack(spacing: 15) {
                Button(action: {
                    viewModel.clearSelection()
                }) {
                    Text("Clear")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(hex: "1D1F30"))
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: -3, y: -3)
                                .shadow(color: Color.white.opacity(0.02), radius: 5, x: 3, y: 3)
                        )
                }
                
                Button(action: {
                    viewModel.submitAnswer()
                }) {
                    Text("Submit")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(viewModel.selectedLetters.count == viewModel.currentPuzzle?.targetWord.count ? Color(hex: "FE284A") : Color.gray)
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: -3, y: -3)
                                .shadow(color: viewModel.selectedLetters.count == viewModel.currentPuzzle?.targetWord.count ? Color(hex: "FE284A").opacity(0.3) : Color.clear, radius: 5, x: 3, y: 3)
                        )
                }
                .disabled(viewModel.selectedLetters.count != viewModel.currentPuzzle?.targetWord.count)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
}

struct CompletionView: View {
    let earnedPoints: Int
    let totalScore: Int
    let level: Int
    let onContinue: () -> Void
    
    var body: some View {
        ZStack {
            Color(hex: "1D1F30")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "star.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: "FE284A"))
                
                Text("Puzzle Solved!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    HStack {
                        Text("Level \(level) Complete")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    HStack {
                        Text("Points Earned:")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text("+\(earnedPoints)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "FE284A"))
                    }
                    .padding(.horizontal, 40)
                    
                    HStack {
                        Text("Total Score:")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text("\(totalScore)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.vertical, 20)
                
                Spacer()
                
                NeumorphicButton(title: "Continue", action: onContinue)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
            }
        }
        .interactiveDismissDisabled()
    }
}

struct GameOverView: View {
    let level: Int
    let onRetry: () -> Void
    let onExit: () -> Void
    
    var body: some View {
        ZStack {
            Color(hex: "1D1F30")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: "FE284A"))
                
                Text("Puzzle Failed")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Don't give up! Try again or choose a different level.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                VStack(spacing: 15) {
                    NeumorphicButton(title: "Try Again", action: onRetry)
                        .padding(.horizontal, 40)
                    
                    Button(action: onExit) {
                        Text("Exit")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .interactiveDismissDisabled()
    }
}

