//
//  cashmateApp.swift
//  cashmate
//
//  Created by student on 30/05/25.
//

import SwiftUI
import SwiftData

@main
struct CashmatedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Budget.self, ExpenseItem.self])
    }
}
