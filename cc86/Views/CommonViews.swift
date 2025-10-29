//
//  CommonViews.swift
//  MystiQuotient: Word Wizardry
//

import SwiftUI

struct NeumorphicButton: View {
    let title: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            action()
        }) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "FE284A"))
                        .shadow(color: Color.black.opacity(0.3), radius: isPressed ? 5 : 10, x: isPressed ? 5 : 10, y: isPressed ? 5 : 10)
                        .shadow(color: Color(hex: "FE284A").opacity(0.3), radius: isPressed ? 5 : 10, x: isPressed ? -5 : -10, y: isPressed ? -5 : -10)
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}


