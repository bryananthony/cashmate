//
//  ContentView.swift
//  cashmate
//
//  Created by student on 30/05/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                TrackView()
            }
            .tabItem {
                Label("Track", systemImage: "pencil")
            }

            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Label("History", systemImage: "clock")
            }

            NavigationStack {
                GoalView()
            }
            .tabItem {
                Label("Goal", systemImage: "target")
            }

            NavigationStack {
                BudgetView()
            }
            .tabItem {
                Label("Budget", systemImage: "chart.pie.fill")
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 16 Pro")
    }
}
