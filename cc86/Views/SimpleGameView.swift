//
//  SimpleGameView.swift  
//  MystiQuotient: Word Wizardry
//

import SwiftUI

struct SimpleGameView: View {
    let level: Int
    @Binding var userProgress: UserProgress
    @Environment(\.dismiss) var dismiss
    
    @State private var showStory = true
    @State private var puzzle: PuzzleModel?
    @State private var story: StorySegment?
    
    var body: some View {
        ZStack {
            Color(hex: "1D1F30")
                .ignoresSafeArea()
            
            if puzzle == nil {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "FE284A")))
                        .scaleEffect(1.5)
                    Text("Loading...")
                        .foregroundColor(.white)
                        .padding()
                }
            } else if showStory, let story = story {
                // Story View
                VStack(spacing: 30) {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text("Chapter \(story.levelNumber)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "FE284A"))
                            .tracking(2)
                        
                        Text(story.title)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        if let character = story.characterName {
                            Text(character)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                                .italic()
                        }
                        
                        Text(story.narrative)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: "1D1F30"))
                                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: -5, y: -5)
                                    .shadow(color: Color.white.opacity(0.02), radius: 10, x: 5, y: 5)
                            )
                            .padding(.horizontal, 20)
                        
                        HStack(spacing: 10) {
                            Image(systemName: "sparkles")
                                .foregroundColor(Color(hex: "FE284A"))
                            Text(story.mysteryClue)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .italic()
                        }
                    }
                    
                    Spacer()
                    
                    Button("Begin Puzzle") {
                        withAnimation {
                            showStory = false
                        }
                    }
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: "FE284A"))
                    )
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                }
            } else if let puzzle = puzzle {
                // Game View
                VStack(spacing: 20) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                        }
                        Spacer()
                        Text("Level \(level)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(puzzle.maxAttempts)")
                            .foregroundColor(Color(hex: "FE284A"))
                            .frame(width: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                    
                    Spacer()
                    
                    Text("Hint")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "FE284A"))
                    
                    Text(puzzle.hint)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    Text(puzzle.targetWord)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "FE284A"))
                        .padding()
                    
                    Spacer()
                    
                    Button("Close") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                }
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        let puzzles = GameService.shared.generatePuzzles()
        puzzle = puzzles.first(where: { $0.levelNumber == level })
        story = StoryService.shared.getStorySegment(for: level)
        print("✅ SimpleGameView loaded - Puzzle: \(puzzle?.targetWord ?? "none"), Story: \(story?.title ?? "none")")
    }
}



