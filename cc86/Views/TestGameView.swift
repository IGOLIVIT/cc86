//
//  TestGameView.swift
//  MystiQuotient: Word Wizardry
//

import SwiftUI

struct TestGameView: View {
    let level: Int
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(hex: "1D1F30")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Test Game View")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Level: \(level)")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color(hex: "FE284A"))
                
                Button("Close") {
                    dismiss()
                }
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "FE284A"))
                )
            }
        }
    }
}


