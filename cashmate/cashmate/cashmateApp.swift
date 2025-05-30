//
//  cashmateApp.swift
//  cashmate
//
//  Created by student on 30/05/25.
//

import SwiftUI
import SwiftData

@main
struct cashmateApp: App {
    var sharedModelContainer: ModelContainer = {
        do {
            return try ModelContainer(
                for: Expense.self, BudgetSetting.self, Goal.self, Saving.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
        } catch {
            print("Failed to create ModelContainer: \(error.localizedDescription)")
            return try! ModelContainer(for: Expense.self, configurations: .init(isStoredInMemoryOnly: true))
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
        }
    }
}
