//
//  OnboardingView.swift
//  MystiQuotient: Word Wizardry
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color(hex: "1D1F30")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Skip button
                HStack {
                    Spacer()
                    Button(action: {
                        hasCompletedOnboarding = true
                        isPresented = false
                    }) {
                        Text("Skip")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(hex: "FE284A"))
                    }
                    .padding(.trailing, 20)
                }
                .padding(.top, 50)
                
                Spacer()
                
                // Content
                TabView(selection: $viewModel.currentPage) {
                    ForEach(Array(viewModel.pages.enumerated()), id: \.element.id) { index, page in
                        VStack(spacing: 30) {
                            // Icon
                            Image(systemName: page.icon)
                                .font(.system(size: 80))
                                .foregroundColor(Color(hex: "FE284A"))
                                .frame(width: 150, height: 150)
                                .background(
                                    Circle()
                                        .fill(Color(hex: "1D1F30"))
                                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 10, y: 10)
                                        .shadow(color: Color.white.opacity(0.05), radius: 10, x: -10, y: -10)
                                )
                            
                            // Title
                            Text(page.title)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            
                            // Description
                            Text(page.description)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                                .lineSpacing(4)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 450)
                
                // Page indicator
                HStack(spacing: 8) {
                    ForEach(0..<viewModel.pages.count, id: \.self) { index in
                        Circle()
                            .fill(viewModel.currentPage == index ? Color(hex: "FE284A") : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: viewModel.currentPage)
                    }
                }
                .padding(.bottom, 20)
                
                // Next/Get Started button
                NeumorphicButton(
                    title: viewModel.currentPage == viewModel.pages.count - 1 ? "Get Started" : "Next",
                    action: {
                        if viewModel.currentPage == viewModel.pages.count - 1 {
                            hasCompletedOnboarding = true
                            isPresented = false
                        } else {
                            withAnimation {
                                viewModel.currentPage += 1
                            }
                        }
                    }
                )
                .padding(.horizontal, 40)
                
                Spacer()
            }
        }
    }
}

