//
//  GameService.swift
//  MystiQuotient: Word Wizardry
//

import Foundation

class GameService {
    static let shared = GameService()
    
    private init() {}
    
    func generatePuzzles() -> [PuzzleModel] {
        return [
            // Level 1-10: Easy - Beginner Magic
            PuzzleModel(levelNumber: 1, targetWord: "MAGIC", hint: "The art of producing illusions", difficulty: .easy),
            PuzzleModel(levelNumber: 2, targetWord: "WIZARD", hint: "A master of mystical arts", difficulty: .easy),
            PuzzleModel(levelNumber: 3, targetWord: "SPELL", hint: "Words with magical power", difficulty: .easy),
            PuzzleModel(levelNumber: 4, targetWord: "CHARM", hint: "An object with magical properties", difficulty: .easy),
            PuzzleModel(levelNumber: 5, targetWord: "WAND", hint: "A magical tool for casting", difficulty: .easy),
            PuzzleModel(levelNumber: 6, targetWord: "WITCH", hint: "A woman who practices magic", difficulty: .easy),
            PuzzleModel(levelNumber: 7, targetWord: "FAIRY", hint: "A small magical creature with wings", difficulty: .easy),
            PuzzleModel(levelNumber: 8, targetWord: "GHOST", hint: "A spirit of the dead", difficulty: .easy),
            PuzzleModel(levelNumber: 9, targetWord: "CURSE", hint: "A harmful magical word", difficulty: .easy),
            PuzzleModel(levelNumber: 10, targetWord: "QUEST", hint: "A long adventurous journey", difficulty: .easy),
            
            // Level 11-20: Medium - Intermediate Mysteries
            PuzzleModel(levelNumber: 11, targetWord: "CRYSTAL", hint: "A transparent mystical stone", difficulty: .medium, maxAttempts: 3),
            PuzzleModel(levelNumber: 12, targetWord: "POTION", hint: "A magical liquid mixture", difficulty: .medium, maxAttempts: 3),
            PuzzleModel(levelNumber: 13, targetWord: "ENCHANT", hint: "To cast a spell upon", difficulty: .medium, maxAttempts: 3),
            PuzzleModel(levelNumber: 14, targetWord: "MYSTERY", hint: "Something difficult to understand", difficulty: .medium, maxAttempts: 3),
            PuzzleModel(levelNumber: 15, targetWord: "ANCIENT", hint: "Belonging to the distant past", difficulty: .medium, maxAttempts: 3),
            PuzzleModel(levelNumber: 16, targetWord: "PHANTOM", hint: "A ghost or apparition", difficulty: .medium, maxAttempts: 3),
            PuzzleModel(levelNumber: 17, targetWord: "DRAGON", hint: "A legendary fire-breathing creature", difficulty: .medium, maxAttempts: 3),
            PuzzleModel(levelNumber: 18, targetWord: "RITUAL", hint: "A ceremonial magical act", difficulty: .medium, maxAttempts: 3),
            PuzzleModel(levelNumber: 19, targetWord: "AMULET", hint: "A protective magical pendant", difficulty: .medium, maxAttempts: 3),
            PuzzleModel(levelNumber: 20, targetWord: "ORACLE", hint: "A prophet or source of wisdom", difficulty: .medium, maxAttempts: 3),
            
            // Level 21-30: Hard - Advanced Sorcery
            PuzzleModel(levelNumber: 21, targetWord: "SORCERY", hint: "The use of supernatural power", difficulty: .hard, maxAttempts: 2, timeLimit: 120),
            PuzzleModel(levelNumber: 22, targetWord: "PROPHECY", hint: "A prediction of future events", difficulty: .hard, maxAttempts: 2, timeLimit: 120),
            PuzzleModel(levelNumber: 23, targetWord: "MYSTICAL", hint: "Having a spiritual significance", difficulty: .hard, maxAttempts: 2, timeLimit: 120),
            PuzzleModel(levelNumber: 24, targetWord: "CONJURE", hint: "To summon by magic", difficulty: .hard, maxAttempts: 2, timeLimit: 90),
            PuzzleModel(levelNumber: 25, targetWord: "GRIMOIRE", hint: "A book of magical knowledge", difficulty: .hard, maxAttempts: 2, timeLimit: 100),
            PuzzleModel(levelNumber: 26, targetWord: "WARLOCK", hint: "A male practitioner of dark magic", difficulty: .hard, maxAttempts: 2, timeLimit: 90),
            PuzzleModel(levelNumber: 27, targetWord: "ALCHEMY", hint: "Medieval chemistry and magic", difficulty: .hard, maxAttempts: 2, timeLimit: 90),
            PuzzleModel(levelNumber: 28, targetWord: "TALISMAN", hint: "A magical object for protection", difficulty: .hard, maxAttempts: 2, timeLimit: 100),
            PuzzleModel(levelNumber: 29, targetWord: "SCEPTER", hint: "A royal magical staff", difficulty: .hard, maxAttempts: 2, timeLimit: 90),
            PuzzleModel(levelNumber: 30, targetWord: "ELIXIR", hint: "A magical healing potion", difficulty: .hard, maxAttempts: 2, timeLimit: 90),
            
            // Level 31-40: Hard+ - Dark Arts
            PuzzleModel(levelNumber: 31, targetWord: "DIVINATION", hint: "The practice of seeking knowledge of the future", difficulty: .hard, maxAttempts: 2, timeLimit: 150),
            PuzzleModel(levelNumber: 32, targetWord: "NECROMANCY", hint: "Communication with spirits of the dead", difficulty: .hard, maxAttempts: 2, timeLimit: 150),
            PuzzleModel(levelNumber: 33, targetWord: "SUMMONING", hint: "Calling forth spirits or entities", difficulty: .hard, maxAttempts: 2, timeLimit: 120),
            PuzzleModel(levelNumber: 34, targetWord: "HEXAGRAM", hint: "A six-pointed magical symbol", difficulty: .hard, maxAttempts: 2, timeLimit: 100),
            PuzzleModel(levelNumber: 35, targetWord: "FAMILIAR", hint: "A magical animal companion", difficulty: .hard, maxAttempts: 2, timeLimit: 100),
            PuzzleModel(levelNumber: 36, targetWord: "CAULDRON", hint: "A large magical cooking pot", difficulty: .hard, maxAttempts: 2, timeLimit: 100),
            PuzzleModel(levelNumber: 37, targetWord: "SANCTUARY", hint: "A sacred protective place", difficulty: .hard, maxAttempts: 2, timeLimit: 120),
            PuzzleModel(levelNumber: 38, targetWord: "LABYRINTH", hint: "A complex magical maze", difficulty: .hard, maxAttempts: 2, timeLimit: 120),
            PuzzleModel(levelNumber: 39, targetWord: "SORCERER", hint: "A powerful magic user", difficulty: .hard, maxAttempts: 2, timeLimit: 100),
            PuzzleModel(levelNumber: 40, targetWord: "ETHEREAL", hint: "Extremely delicate and light", difficulty: .hard, maxAttempts: 2, timeLimit: 100),
            
            // Level 41-50: Expert - Master Level
            PuzzleModel(levelNumber: 41, targetWord: "INCANTATION", hint: "A series of words said as a magic spell", difficulty: .expert, maxAttempts: 1, timeLimit: 90),
            PuzzleModel(levelNumber: 42, targetWord: "METAMORPHOSIS", hint: "A transformation into something different", difficulty: .expert, maxAttempts: 1, timeLimit: 120),
            PuzzleModel(levelNumber: 43, targetWord: "CLAIRVOYANCE", hint: "The supernatural ability to perceive events", difficulty: .expert, maxAttempts: 1, timeLimit: 120),
            PuzzleModel(levelNumber: 44, targetWord: "APPARITION", hint: "A ghost or ghostlike image", difficulty: .expert, maxAttempts: 1, timeLimit: 90),
            PuzzleModel(levelNumber: 45, targetWord: "TRANSMUTATION", hint: "The action of changing form or nature", difficulty: .expert, maxAttempts: 1, timeLimit: 150),
            PuzzleModel(levelNumber: 46, targetWord: "SUPERNATURAL", hint: "Beyond the natural world", difficulty: .expert, maxAttempts: 1, timeLimit: 120),
            PuzzleModel(levelNumber: 47, targetWord: "HALLUCINATION", hint: "A perception of something not present", difficulty: .expert, maxAttempts: 1, timeLimit: 150),
            PuzzleModel(levelNumber: 48, targetWord: "REINCARNATION", hint: "Rebirth of a soul in a new body", difficulty: .expert, maxAttempts: 1, timeLimit: 150),
            PuzzleModel(levelNumber: 49, targetWord: "TELEPORTATION", hint: "Instant transportation to another place", difficulty: .expert, maxAttempts: 1, timeLimit: 150),
            PuzzleModel(levelNumber: 50, targetWord: "OMNIPOTENCE", hint: "Unlimited power and authority", difficulty: .expert, maxAttempts: 1, timeLimit: 120),
            
            // Level 51-60: Expert+ - Legendary Mastery
            PuzzleModel(levelNumber: 51, targetWord: "ILLUMINATION", hint: "Spiritual enlightenment or lighting", difficulty: .expert, maxAttempts: 1, timeLimit: 120),
            PuzzleModel(levelNumber: 52, targetWord: "THAUMATURGY", hint: "The working of miracles", difficulty: .expert, maxAttempts: 1, timeLimit: 100),
            PuzzleModel(levelNumber: 53, targetWord: "TELEKINESIS", hint: "Moving objects with the mind", difficulty: .expert, maxAttempts: 1, timeLimit: 110),
            PuzzleModel(levelNumber: 54, targetWord: "PREMONITION", hint: "A forewarning of future events", difficulty: .expert, maxAttempts: 1, timeLimit: 110),
            PuzzleModel(levelNumber: 55, targetWord: "EXORCISM", hint: "The expulsion of evil spirits", difficulty: .expert, maxAttempts: 1, timeLimit: 90),
            PuzzleModel(levelNumber: 56, targetWord: "LEVITATION", hint: "Rising and floating in the air", difficulty: .expert, maxAttempts: 1, timeLimit: 100),
            PuzzleModel(levelNumber: 57, targetWord: "PYROMANCY", hint: "Divination through fire", difficulty: .expert, maxAttempts: 1, timeLimit: 90),
            PuzzleModel(levelNumber: 58, targetWord: "INVOCATION", hint: "The summoning of a deity", difficulty: .expert, maxAttempts: 1, timeLimit: 100),
            PuzzleModel(levelNumber: 59, targetWord: "ASTRAL", hint: "Relating to the stars or spirit realm", difficulty: .expert, maxAttempts: 1, timeLimit: 80),
            PuzzleModel(levelNumber: 60, targetWord: "OMNISCIENCE", hint: "Infinite knowledge and awareness", difficulty: .expert, maxAttempts: 1, timeLimit: 120)
        ]
    }
    
    func calculateScore(puzzle: PuzzleModel, attempts: Int, timeRemaining: Int?) -> Int {
        var baseScore = 100
        
        // Difficulty multiplier
        switch puzzle.difficulty {
        case .easy:
            baseScore *= 1
        case .medium:
            baseScore *= 2
        case .hard:
            baseScore *= 3
        case .expert:
            baseScore *= 5
        }
        
        // Attempts penalty
        let attemptPenalty = (puzzle.maxAttempts - attempts) * 20
        baseScore += attemptPenalty
        
        // Time bonus
        if let timeRemaining = timeRemaining, let timeLimit = puzzle.timeLimit {
            let timeBonus = (timeRemaining * baseScore) / timeLimit
            baseScore += timeBonus
        }
        
        return max(baseScore, 10)
    }
    
    func unlockNextLevel(currentLevel: Int, progress: inout UserProgress) {
        let nextLevel = currentLevel + 1
        progress.unlockedLevels.insert(nextLevel)
    }
    
    func checkAchievements(progress: UserProgress) -> [Achievement] {
        var newAchievements: [Achievement] = []
        
        // First completion
        if progress.completedLevels.count == 1 && !progress.achievements.contains(where: { $0.title == "First Steps" }) {
            newAchievements.append(Achievement(title: "First Steps", description: "Complete your first puzzle", icon: "star.fill"))
        }
        
        // Complete 5 levels
        if progress.completedLevels.count == 5 && !progress.achievements.contains(where: { $0.title == "Apprentice" }) {
            newAchievements.append(Achievement(title: "Apprentice", description: "Complete 5 puzzles", icon: "wand.and.stars"))
        }
        
        // Complete 10 levels
        if progress.completedLevels.count == 10 && !progress.achievements.contains(where: { $0.title == "Adept Wizard" }) {
            newAchievements.append(Achievement(title: "Adept Wizard", description: "Complete 10 puzzles", icon: "sparkles"))
        }
        
        // Complete 20 levels
        if progress.completedLevels.count == 20 && !progress.achievements.contains(where: { $0.title == "Sorcerer" }) {
            newAchievements.append(Achievement(title: "Sorcerer", description: "Complete 20 puzzles", icon: "crown.fill"))
        }
        
        // Complete 30 levels
        if progress.completedLevels.count == 30 && !progress.achievements.contains(where: { $0.title == "Archmage" }) {
            newAchievements.append(Achievement(title: "Archmage", description: "Complete 30 puzzles", icon: "bolt.fill"))
        }
        
        // Complete 40 levels
        if progress.completedLevels.count == 40 && !progress.achievements.contains(where: { $0.title == "Master Wizard" }) {
            newAchievements.append(Achievement(title: "Master Wizard", description: "Complete 40 puzzles", icon: "flame.fill"))
        }
        
        // Complete 50 levels
        if progress.completedLevels.count == 50 && !progress.achievements.contains(where: { $0.title == "Legendary Master" }) {
            newAchievements.append(Achievement(title: "Legendary Master", description: "Complete 50 puzzles", icon: "rosette"))
        }
        
        // Complete all levels
        if progress.completedLevels.count == 60 && !progress.achievements.contains(where: { $0.title == "Omniscient Grand Master" }) {
            newAchievements.append(Achievement(title: "Omniscient Grand Master", description: "Complete all 60 puzzles!", icon: "trophy.fill"))
        }
        
        // Score milestones
        if progress.totalScore >= 2000 && !progress.achievements.contains(where: { $0.title == "Point Collector" }) {
            newAchievements.append(Achievement(title: "Point Collector", description: "Reach 2000 points", icon: "star.circle.fill"))
        }
        
        if progress.totalScore >= 5000 && !progress.achievements.contains(where: { $0.title == "Score Champion" }) {
            newAchievements.append(Achievement(title: "Score Champion", description: "Reach 5000 points", icon: "flame.fill"))
        }
        
        if progress.totalScore >= 10000 && !progress.achievements.contains(where: { $0.title == "Score Legend" }) {
            newAchievements.append(Achievement(title: "Score Legend", description: "Reach 10000 points", icon: "crown.fill"))
        }
        
        if progress.totalScore >= 20000 && !progress.achievements.contains(where: { $0.title == "Ultimate Champion" }) {
            newAchievements.append(Achievement(title: "Ultimate Champion", description: "Reach 20000 points!", icon: "trophy.fill"))
        }
        
        // Speed achievements
        let recentAttempts = progress.puzzleAttempts.suffix(10)
        let perfectAttempts = recentAttempts.filter { $0.attempts == 1 && $0.completed }
        if perfectAttempts.count >= 5 && !progress.achievements.contains(where: { $0.title == "Perfect Streak" }) {
            newAchievements.append(Achievement(title: "Perfect Streak", description: "Complete 5 puzzles in a row on first attempt", icon: "bolt.circle.fill"))
        }
        
        return newAchievements
    }
}


