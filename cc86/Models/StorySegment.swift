//
//  StorySegment.swift
//  MystiQuotient: Word Wizardry
//

import Foundation

struct StorySegment: Identifiable, Codable {
    let id: UUID
    let levelNumber: Int
    let title: String
    let narrative: String
    let characterName: String?
    let mysteryClue: String
    
    init(id: UUID = UUID(), levelNumber: Int, title: String, narrative: String, characterName: String? = nil, mysteryClue: String) {
        self.id = id
        self.levelNumber = levelNumber
        self.title = title
        self.narrative = narrative
        self.characterName = characterName
        self.mysteryClue = mysteryClue
    }
}


