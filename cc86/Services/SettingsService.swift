//
//  SettingsService.swift
//  MystiQuotient: Word Wizardry
//

import Foundation
import SwiftUI

class SettingsService {
    static let shared = SettingsService()
    
    private let userProgressKey = "userProgress"
    private let userSettingsKey = "userSettings"
    
    private init() {}
    
    func saveProgress(_ progress: UserProgress) {
        if let encoded = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(encoded, forKey: userProgressKey)
        }
    }
    
    func loadProgress() -> UserProgress {
        guard let data = UserDefaults.standard.data(forKey: userProgressKey),
              let decoded = try? JSONDecoder().decode(UserProgress.self, from: data) else {
            return UserProgress()
        }
        return decoded
    }
    
    func saveSettings(_ settings: UserSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: userSettingsKey)
        }
    }
    
    func loadSettings() -> UserSettings {
        guard let data = UserDefaults.standard.data(forKey: userSettingsKey),
              let decoded = try? JSONDecoder().decode(UserSettings.self, from: data) else {
            return UserSettings()
        }
        return decoded
    }
    
    func resetProgress() {
        let newProgress = UserProgress()
        saveProgress(newProgress)
    }
    
    func exportProgress() -> String? {
        let progress = loadProgress()
        if let jsonData = try? JSONEncoder().encode(progress),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return nil
    }
}

