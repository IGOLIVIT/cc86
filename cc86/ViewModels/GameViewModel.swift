//
//  GameViewModel.swift
//  MystiQuotient: Word Wizardry
//

import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var currentPuzzle: PuzzleModel?
    @Published var selectedLetters: [String] = []
    @Published var availableLetters: [LetterTile] = []
    @Published var attempts: Int = 0
    @Published var score: Int = 0
    @Published var timeRemaining: Int?
    @Published var isCorrect: Bool = false
    @Published var isWrong: Bool = false
    @Published var showStory: Bool = false
    @Published var currentStory: StorySegment?
    @Published var showCompletion: Bool = false
    @Published var earnedPoints: Int = 0
    @Published var showGameOver: Bool = false
    
    private var timer: Timer?
    private let gameService = GameService.shared
    private let storyService = StoryService.shared
    
    struct LetterTile: Identifiable {
        let id = UUID()
        let letter: String
        var isUsed: Bool = false
    }
    
    func loadPuzzle(level: Int) {
        print("🎮 Loading puzzle for level: \(level)")
        let puzzles = gameService.generatePuzzles()
        print("🎮 Total puzzles available: \(puzzles.count)")
        
        guard let puzzle = puzzles.first(where: { $0.levelNumber == level }) else {
            print("❌ Puzzle not found for level: \(level)")
            return
        }
        
        print("✅ Puzzle found: \(puzzle.targetWord)")
        currentPuzzle = puzzle
        
        currentStory = storyService.getStorySegment(for: level)
        print("✅ Story found: \(currentStory?.title ?? "No story")")
        
        attempts = 0
        selectedLetters = []
        isCorrect = false
        isWrong = false
        showCompletion = false
        showGameOver = false
        
        // Initialize available letters
        availableLetters = puzzle.scrambledLetters.map { LetterTile(letter: $0, isUsed: false) }
        print("✅ Available letters: \(availableLetters.count)")
        
        // Show story first
        showStory = true
        print("✅ showStory set to: \(showStory)")
        
        // Setup timer if needed
        if let timeLimit = puzzle.timeLimit {
            timeRemaining = timeLimit
            startTimer()
        } else {
            timeRemaining = nil
        }
    }
    
    func startGame() {
        showStory = false
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let remaining = self.timeRemaining else { return }
            
            if remaining > 0 {
                self.timeRemaining = remaining - 1
            } else {
                self.handleTimeUp()
            }
        }
    }
    
    func selectLetter(at index: Int) {
        guard index < availableLetters.count, !availableLetters[index].isUsed else { return }
        
        availableLetters[index].isUsed = true
        selectedLetters.append(availableLetters[index].letter)
        
        // Play haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func deselectLetter(at index: Int) {
        guard index < selectedLetters.count else { return }
        
        let letter = selectedLetters[index]
        selectedLetters.remove(at: index)
        
        // Find and mark as available
        if let availableIndex = availableLetters.firstIndex(where: { $0.letter == letter && $0.isUsed }) {
            availableLetters[availableIndex].isUsed = false
        }
        
        // Play haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func clearSelection() {
        selectedLetters = []
        for i in 0..<availableLetters.count {
            availableLetters[i].isUsed = false
        }
    }
    
    func submitAnswer() {
        guard let puzzle = currentPuzzle else { return }
        
        let answer = selectedLetters.joined()
        attempts += 1
        
        if answer == puzzle.targetWord {
            // Correct answer
            isCorrect = true
            timer?.invalidate()
            
            // Calculate score
            earnedPoints = gameService.calculateScore(puzzle: puzzle, attempts: attempts, timeRemaining: timeRemaining)
            score += earnedPoints
            
            // Play success haptic
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // Show completion after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showCompletion = true
            }
        } else {
            // Wrong answer
            isWrong = true
            
            // Play error haptic
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
            // Clear selection after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isWrong = false
                self.clearSelection()
                
                // Check if out of attempts
                if self.attempts >= puzzle.maxAttempts {
                    self.handleGameOver()
                }
            }
        }
    }
    
    private func handleTimeUp() {
        timer?.invalidate()
        handleGameOver()
    }
    
    private func handleGameOver() {
        showGameOver = true
        timer?.invalidate()
    }
    
    func completeLevel(progress: inout UserProgress) {
        guard let puzzle = currentPuzzle else { return }
        
        progress.completedLevels.insert(puzzle.levelNumber)
        progress.totalScore += earnedPoints
        
        // Unlock next level
        gameService.unlockNextLevel(currentLevel: puzzle.levelNumber, progress: &progress)
        
        // Update current level to next available level
        if let nextLevel = progress.unlockedLevels.sorted().first(where: { !progress.completedLevels.contains($0) }) {
            progress.currentLevel = nextLevel
        } else {
            // All levels completed, stay on last level
            progress.currentLevel = puzzle.levelNumber
        }
        
        // Check for achievements
        let newAchievements = gameService.checkAchievements(progress: progress)
        progress.achievements.append(contentsOf: newAchievements)
        
        // Save attempt
        let attempt = PuzzleAttempt(
            puzzleId: puzzle.id,
            attempts: attempts,
            completed: true,
            timeTaken: puzzle.timeLimit != nil ? (puzzle.timeLimit! - (timeRemaining ?? 0)) : nil,
            date: Date()
        )
        progress.puzzleAttempts.append(attempt)
    }
    
    deinit {
        timer?.invalidate()
    }
}

