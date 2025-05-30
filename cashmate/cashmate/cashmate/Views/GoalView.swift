//
//  GoalView.swift
//  cashmate
//
//  Created by student on 30/05/25.
//
import SwiftUI
import SwiftData

struct GoalView: View {
    @Query var goals: [Goal]
    
    var body: some View {
        VStack(spacing: 16) {
            if let goal = goals.first {
                VStack {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 10)
                            .foregroundColor(.green.opacity(0.4))
                        Circle()
                            .trim(from: 0.0, to: CGFloat(goal.savedAmount / goal.targetAmount))
                            .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        Text("Goal\n\(goal.title)")
                            .multilineTextAlignment(.center)
                            .bold()
                    }
                    .frame(width: 150, height: 150)
                    
                    Text("Saving")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.7))
                        .cornerRadius(10)
                }
            } else {
                Text("No goals yet")
            }
        }
        .padding()
        .navigationTitle("Goal")
    }
}
