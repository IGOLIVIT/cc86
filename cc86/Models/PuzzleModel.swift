//
//  PuzzleModel.swift
//  MystiQuotient: Word Wizardry
//

import Foundation

struct PuzzleModel: Identifiable, Codable {
    let id: UUID
    let levelNumber: Int
    let targetWord: String
    let scrambledLetters: [String]
    let hint: String
    let difficulty: Difficulty
    let maxAttempts: Int
    let timeLimit: Int? // in seconds, nil for untimed
    
    enum Difficulty: String, Codable {
        case easy
        case medium
        case hard
        case expert
    }
    
    init(id: UUID = UUID(), levelNumber: Int, targetWord: String, hint: String, difficulty: Difficulty, maxAttempts: Int = 3, timeLimit: Int? = nil) {
        self.id = id
        self.levelNumber = levelNumber
        self.targetWord = targetWord.uppercased()
        self.scrambledLetters = targetWord.uppercased().map { String($0) }.shuffled()
        self.hint = hint
        self.difficulty = difficulty
        self.maxAttempts = maxAttempts
        self.timeLimit = timeLimit
    }
}

struct PuzzleAttempt: Codable {
    let puzzleId: UUID
    let attempts: Int
    let completed: Bool
    let timeTaken: Int?
    let date: Date
}


