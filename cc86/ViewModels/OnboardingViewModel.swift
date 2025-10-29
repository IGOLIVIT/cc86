//
//  OnboardingViewModel.swift
//  MystiQuotient: Word Wizardry
//

import Foundation
import SwiftUI
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    @Published var isCompleted: Bool = false
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "book.fill",
            title: "Welcome to MystiQuotient",
            description: "Embark on a magical journey through the world of words and wizardry. Solve mystical puzzles and uncover ancient secrets."
        ),
        OnboardingPage(
            icon: "wand.and.stars",
            title: "Solve Word Puzzles",
            description: "Unscramble magical words by tapping letters in the correct order. Each puzzle comes with hints from your story companions."
        ),
        OnboardingPage(
            icon: "map.fill",
            title: "Follow the Story",
            description: "Progress through an engaging narrative filled with mysterious characters and ancient wisdom. Each level reveals more of the tale."
        ),
        OnboardingPage(
            icon: "star.fill",
            title: "Unlock Achievements",
            description: "Earn achievements and climb the levels from Apprentice to Grand Master. Challenge yourself with timed puzzles and expert modes."
        )
    ]
    
    func nextPage() {
        if currentPage < pages.count - 1 {
            withAnimation {
                currentPage += 1
            }
        } else {
            completeOnboarding()
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            withAnimation {
                currentPage -= 1
            }
        }
    }
    
    func skipOnboarding() {
        completeOnboarding()
    }
    
    private func completeOnboarding() {
        withAnimation {
            isCompleted = true
        }
    }
}

struct OnboardingPage: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

