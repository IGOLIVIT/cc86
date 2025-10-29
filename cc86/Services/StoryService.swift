//
//  StoryService.swift
//  MystiQuotient: Word Wizardry
//

import Foundation

class StoryService {
    static let shared = StoryService()
    
    private init() {}
    
    func getStorySegments() -> [StorySegment] {
        return [
            StorySegment(levelNumber: 1, title: "The Awakening", narrative: "You wake in an ancient library, surrounded by dusty tomes and flickering candlelight. A mysterious voice whispers through the shadows: 'To unlock the secrets within, you must master the words of power.'", characterName: "The Librarian", mysteryClue: "The first word holds the key to all that follows..."),
            
            StorySegment(levelNumber: 2, title: "The Guardian", narrative: "A hooded figure emerges from the darkness. 'I am the keeper of forgotten knowledge,' they say. 'Prove your worth by solving my riddle, and I shall grant you passage to the next chamber.'", characterName: "The Guardian", mysteryClue: "One who commands the arcane arts..."),
            
            StorySegment(levelNumber: 3, title: "The Book of Shadows", narrative: "Before you lies an ancient grimoire, its pages glowing with ethereal light. The text rearranges itself before your eyes, challenging you to decipher its meaning.", mysteryClue: "The incantation requires precise wording..."),
            
            StorySegment(levelNumber: 4, title: "The Amulet", narrative: "Hanging from a silver chain, a mystical pendant catches your eye. Its inscription is scrambled, but you sense it holds protective power. Arrange the letters to unlock its magic.", characterName: "The Enchantress", mysteryClue: "A talisman of protection..."),
            
            StorySegment(levelNumber: 5, title: "The First Trial", narrative: "You've reached the Chamber of Trials. On a pedestal sits a slender magical instrument. The inscription reads: 'With this tool, channel your will and reshape reality itself.'", mysteryClue: "The instrument of every spellcaster..."),
            
            StorySegment(levelNumber: 6, title: "The Oracle's Gift", narrative: "The Oracle appears in a shimmer of light. 'You have proven yourself worthy. Take this fragment of power - it will reveal truths hidden to mortal eyes.' She presents you with a glowing stone.", characterName: "The Oracle", mysteryClue: "A stone of clarity and vision..."),
            
            StorySegment(levelNumber: 7, title: "The Alchemist's Workshop", narrative: "Vials and flasks line the shelves of this mysterious laboratory. A bubbling cauldron sits in the center. The Alchemist gestures: 'Mix the right ingredients, speak the right words, and transform the ordinary into the extraordinary.'", characterName: "The Alchemist", mysteryClue: "A mystical brew with transformative properties..."),
            
            StorySegment(levelNumber: 8, title: "The Curse", narrative: "A dark presence fills the room. The Guardian warns: 'Something wicked lurks in these halls. To protect yourself, you must learn the art of placing protective spells upon objects and people.'", mysteryClue: "To bewitch or bestow magical properties..."),
            
            StorySegment(levelNumber: 9, title: "The Hidden Path", narrative: "Symbols glow on the wall, forming a map to a secret passage. But the final location remains obscured. 'The path forward is shrouded in enigma,' the Librarian explains. 'Only those who embrace the unknown can proceed.'", mysteryClue: "Something unexplained and intriguing..."),
            
            StorySegment(levelNumber: 10, title: "The Temple", narrative: "You enter a vast temple adorned with hieroglyphics and weathered stone. 'This place has stood for millennia,' whispers the Guardian. 'The knowledge here predates recorded history. Unlock its secrets.'", mysteryClue: "Of great age, from times long past..."),
            
            StorySegment(levelNumber: 11, title: "The Dark Arts", narrative: "Warning runes glow crimson around a forbidden tome. 'Be careful,' warns the Oracle. 'This knowledge is dangerous. The practice of dark magic has corrupted many who sought its power. Prove you can handle it responsibly.'", characterName: "The Oracle", mysteryClue: "The forbidden art of black magic..."),
            
            StorySegment(levelNumber: 12, title: "The Seer's Vision", narrative: "The Seer closes her eyes, her consciousness reaching across time. 'I see glimpses of what is to come,' she murmurs. 'The future is written in fragments, a foretelling that can guide or mislead.'", characterName: "The Seer", mysteryClue: "A divine prediction of future events..."),
            
            StorySegment(levelNumber: 13, title: "The Sacred Circle", narrative: "Candles form a perfect circle on the floor, their flames dancing without wind. The air thrums with otherworldly energy. 'Step into the circle,' invites the Enchantress. 'Here, the veil between worlds grows thin, and spiritual truths become tangible.'", characterName: "The Enchantress", mysteryClue: "Of spiritual or supernatural significance..."),
            
            StorySegment(levelNumber: 14, title: "The Crystal Ball", narrative: "A perfectly clear orb sits upon a velvet cushion, swirling with mist and possibility. 'The art of scrying,' explains the Seer. 'Through this sphere, one can perceive events distant in time and space. It requires focus and the gift of sight beyond sight.'", characterName: "The Seer", mysteryClue: "Foretelling through supernatural means..."),
            
            StorySegment(levelNumber: 15, title: "The Forbidden Ritual", narrative: "You discover a chamber filled with bones and arcane symbols. The Guardian's voice is grave: 'The darkest of arts lies before you - the summoning and binding of souls who have passed beyond. This power is not to be taken lightly.'", characterName: "The Guardian", mysteryClue: "Magic involving communication with the dead..."),
            
            StorySegment(levelNumber: 16, title: "The Grand Spell", narrative: "The walls echo with power as ancient words materialize in the air. 'The mightiest spells require more than simple words,' teaches the Alchemist. 'They demand ritual phrases spoken with precise intention - a full incantation of power.'", characterName: "The Alchemist", mysteryClue: "A complex magical phrase or chant..."),
            
            StorySegment(levelNumber: 17, title: "The Shapeshifter", narrative: "Before your eyes, the Guardian's form shifts and changes - wolf, eagle, serpent, then human again. 'The ultimate expression of transformation magic,' they explain. 'A complete metamorphosis of one's very essence.'", characterName: "The Guardian", mysteryClue: "A complete transformation of form..."),
            
            StorySegment(levelNumber: 18, title: "The Third Eye", narrative: "The Oracle touches your forehead, and suddenly you perceive layers of reality previously hidden. 'You have awakened the inner sight,' she says. 'The ability to perceive beyond the physical realm, to sense truths invisible to ordinary perception.'", characterName: "The Oracle", mysteryClue: "The power to perceive the unseeable..."),
            
            StorySegment(levelNumber: 19, title: "The Haunted Chamber", narrative: "A ghostly figure materializes before you, translucent and shimmering. 'Not all who pass beyond fully depart,' whispers the Librarian. 'Some remain as ethereal manifestations, visible to those with the gift of sight.'", characterName: "The Librarian", mysteryClue: "A spectral manifestation..."),
            
            StorySegment(levelNumber: 20, title: "The Ultimate Secret", narrative: "You stand before the final door, inscribed with the most powerful word of all. The Enchantress appears one last time: 'The highest art - to change the very nature of matter itself. To transmute one element into another. This is the culmination of your journey.'", characterName: "The Enchantress", mysteryClue: "The alchemical transformation of substance...")
        ]
    }
    
    func getStorySegment(for level: Int) -> StorySegment? {
        return getStorySegments().first { $0.levelNumber == level }
    }
}


