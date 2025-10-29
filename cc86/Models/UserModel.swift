//
//  UserModel.swift
//  MystiQuotient: Word Wizardry
//

import Foundation

struct UserProgress: Codable {
    var currentLevel: Int
    var totalScore: Int
    var completedLevels: Set<Int>
    var unlockedLevels: Set<Int>
    var achievements: [Achievement]
    var puzzleAttempts: [PuzzleAttempt]
    
    init() {
        self.currentLevel = 1
        self.totalScore = 0
        self.completedLevels = []
        self.unlockedLevels = [1]
        self.achievements = []
        self.puzzleAttempts = []
    }
}

struct Achievement: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let icon: String
    let unlockedDate: Date
    
    init(id: UUID = UUID(), title: String, description: String, icon: String, unlockedDate: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.unlockedDate = unlockedDate
    }
}

struct UserSettings: Codable, Equatable {
    var soundEnabled: Bool
    var musicEnabled: Bool
    var hapticEnabled: Bool
    var difficulty: String
    var notificationsEnabled: Bool
    
    init() {
        self.soundEnabled = true
        self.musicEnabled = true
        self.hapticEnabled = true
        self.difficulty = "medium"
        self.notificationsEnabled = false
    }
}

