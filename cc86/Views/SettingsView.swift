//
//  SettingsView.swift
//  MystiQuotient: Word Wizardry
//

import SwiftUI

struct SettingsView: View {
    @Binding var userSettings: UserSettings
    @Binding var userProgress: UserProgress
    @State private var showingResetAlert = false
    @State private var showingAbout = false
    
    var body: some View {
        ZStack {
            Color(hex: "1D1F30")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    Text("Settings")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 60)
                    
                    // Audio Settings
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Audio")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "FE284A"))
                            .padding(.leading, 5)
                        
                        SettingsToggle(
                            title: "Sound Effects",
                            icon: "speaker.wave.2.fill",
                            isOn: $userSettings.soundEnabled
                        )
                        
                        SettingsToggle(
                            title: "Background Music",
                            icon: "music.note",
                            isOn: $userSettings.musicEnabled
                        )
                        
                        SettingsToggle(
                            title: "Haptic Feedback",
                            icon: "hand.tap.fill",
                            isOn: $userSettings.hapticEnabled
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Gameplay Settings
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Gameplay")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "FE284A"))
                            .padding(.leading, 5)
                        
                        DifficultyPicker(selectedDifficulty: $userSettings.difficulty)
                    }
                    .padding(.horizontal, 20)
                    
                    // Notifications
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Notifications")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "FE284A"))
                            .padding(.leading, 5)
                        
                        SettingsToggle(
                            title: "Daily Reminders",
                            icon: "bell.fill",
                            isOn: $userSettings.notificationsEnabled
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Progress Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Progress")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "FE284A"))
                            .padding(.leading, 5)
                        
                        VStack(spacing: 12) {
                            ProgressRow(title: "Current Level", value: "\(userProgress.currentLevel)")
                            ProgressRow(title: "Total Score", value: "\(userProgress.totalScore)")
                            ProgressRow(title: "Levels Completed", value: "\(userProgress.completedLevels.count)/20")
                            ProgressRow(title: "Achievements", value: "\(userProgress.achievements.count)")
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "1D1F30"))
                                .shadow(color: Color.black.opacity(0.3), radius: 8, x: -4, y: -4)
                                .shadow(color: Color.white.opacity(0.02), radius: 8, x: 4, y: 4)
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Actions
                    VStack(spacing: 15) {
                        SettingsButton(
                            title: "Reset Progress",
                            icon: "arrow.counterclockwise",
                            color: Color(hex: "FE284A"),
                            action: {
                                showingResetAlert = true
                            }
                        )
                        
                        SettingsButton(
                            title: "About",
                            icon: "info.circle",
                            color: .white.opacity(0.7),
                            action: {
                                showingAbout = true
                            }
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .alert("Reset Progress", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetProgress()
            }
        } message: {
            Text("Are you sure you want to reset all your progress? This action cannot be undone.")
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .onChange(of: userSettings) { newSettings in
            SettingsService.shared.saveSettings(newSettings)
        }
    }
    
    private func resetProgress() {
        SettingsService.shared.resetProgress()
        userProgress = SettingsService.shared.loadProgress()
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

struct SettingsToggle: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "FE284A"))
                .frame(width: 30)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color(hex: "FE284A"))
                .onChange(of: isOn) { _ in
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(hex: "1D1F30"))
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: -3, y: -3)
                .shadow(color: Color.white.opacity(0.02), radius: 5, x: 3, y: 3)
        )
    }
}

struct DifficultyPicker: View {
    @Binding var selectedDifficulty: String
    let difficulties = ["easy", "medium", "hard", "expert"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "gauge.medium")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "FE284A"))
                    .frame(width: 30)
                
                Text("Difficulty Preference")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(.leading, 20)
            
            HStack(spacing: 10) {
                ForEach(difficulties, id: \.self) { difficulty in
                    Button(action: {
                        selectedDifficulty = difficulty
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }) {
                        Text(difficulty.capitalized)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(selectedDifficulty == difficulty ? .white : .white.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedDifficulty == difficulty ? Color(hex: "FE284A") : Color(hex: "1D1F30"))
                                    .shadow(color: selectedDifficulty == difficulty ? Color.black.opacity(0.3) : Color.clear, radius: 3, x: -2, y: -2)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(hex: "1D1F30"))
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: -3, y: -3)
                .shadow(color: Color.white.opacity(0.02), radius: 5, x: 3, y: 3)
        )
    }
}

struct ProgressRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

struct SettingsButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            action()
        }) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(color.opacity(0.5))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: "1D1F30"))
                    .shadow(color: isPressed ? Color.clear : Color.black.opacity(0.3), radius: isPressed ? 2 : 5, x: isPressed ? -2 : -3, y: isPressed ? -2 : -3)
                    .shadow(color: isPressed ? Color.clear : Color.white.opacity(0.02), radius: isPressed ? 2 : 5, x: isPressed ? 2 : 3, y: isPressed ? 2 : 3)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(hex: "1D1F30")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                HStack {
                    Spacer()
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
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                
                Spacer()
                
                // App icon
                Image(systemName: "wand.and.stars")
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: "FE284A"))
                
                Text("MystiQuotient")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Word Wizardry")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                
                Text("Version 1.0.0")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.top, 10)
                
                VStack(spacing: 15) {
                    Text("A captivating word puzzle game that blends magical storytelling with challenging wordplay. Embark on a mystical journey through 20 enchanting levels.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 40)
                    
                    Text("© 2025 MystiQuotient. All rights reserved.")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.top, 20)
                }
                
                Spacer()
            }
        }
    }
}


