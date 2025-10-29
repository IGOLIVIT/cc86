//
//  StoryBoardView.swift
//  MystiQuotient: Word Wizardry
//

import SwiftUI

struct StoryBoardView: View {
    @Binding var userProgress: UserProgress
    @State private var selectedLevel: IdentifiableInt?
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "1D1F30")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 10) {
                        Text("Story Board")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Your Magical Journey")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Stats
                    HStack(spacing: 20) {
                        StatCard(
                            icon: "star.fill",
                            title: "Total Score",
                            value: "\(userProgress.totalScore)"
                        )
                        
                        StatCard(
                            icon: "checkmark.circle.fill",
                            title: "Completed",
                            value: "\(userProgress.completedLevels.count)/20"
                        )
                        
                        StatCard(
                            icon: "trophy.fill",
                            title: "Achievements",
                            value: "\(userProgress.achievements.count)"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Level grid
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(1...20, id: \.self) { level in
                            LevelNode(
                                level: level,
                                isUnlocked: userProgress.unlockedLevels.contains(level),
                                isCompleted: userProgress.completedLevels.contains(level),
                                isCurrent: userProgress.currentLevel == level,
                                action: {
                                    if userProgress.unlockedLevels.contains(level) {
                                        selectedLevel = IdentifiableInt(level)
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(item: $selectedLevel) { levelItem in
            SimpleGameView(level: levelItem.value, userProgress: $userProgress)
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "FE284A"))
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1D1F30"))
                .shadow(color: Color.black.opacity(0.3), radius: 8, x: -4, y: -4)
                .shadow(color: Color.white.opacity(0.02), radius: 8, x: 4, y: 4)
        )
    }
}

struct LevelNode: View {
    let level: Int
    let isUnlocked: Bool
    let isCompleted: Bool
    let isCurrent: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            if isUnlocked {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                action()
            }
        }) {
            ZStack {
                Circle()
                    .fill(Color(hex: "1D1F30"))
                    .frame(width: 90, height: 90)
                    .shadow(color: isPressed ? Color.clear : Color.black.opacity(0.3), radius: isPressed ? 2 : 8, x: isPressed ? -2 : -4, y: isPressed ? -2 : -4)
                    .shadow(color: isPressed ? Color.clear : Color.white.opacity(0.02), radius: isPressed ? 2 : 8, x: isPressed ? 2 : 4, y: isPressed ? 2 : 4)
                
                if isCompleted {
                    Circle()
                        .strokeBorder(Color(hex: "FE284A"), lineWidth: 3, antialiased: true)
                        .frame(width: 90, height: 90)
                }
                
                if isCurrent && !isCompleted {
                    Circle()
                        .strokeBorder(Color(hex: "FE284A"), lineWidth: 2, antialiased: true)
                        .frame(width: 90, height: 90)
                        .opacity(0.5)
                }
                
                VStack(spacing: 4) {
                    if isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color(hex: "FE284A"))
                    } else if isUnlocked {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color(hex: "FE284A"))
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    
                    Text("\(level)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isUnlocked ? .white : .white.opacity(0.3))
                }
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isUnlocked)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if isUnlocked {
                        isPressed = true
                    }
                }
                .onEnded { _ in isPressed = false }
        )
    }
}

