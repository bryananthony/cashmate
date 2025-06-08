import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var expenseViewModel = ExpenseViewModel()
    @StateObject private var goalViewModel = GoalViewModel()
    @StateObject private var savingViewModel = SavingViewModel()
    
    var body: some View {
        TabView {
            // Expenses Tab
            ExpenseTrackView(viewModel: expenseViewModel)
                .tabItem {
                    Label("Expenses", systemImage: "banknote")
                }
            
            // History Tab
            ExpenseHistoryView(viewModel: expenseViewModel)
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            
            // Goals Tab
            GoalsView(goalViewModel: goalViewModel, savingViewModel: savingViewModel)
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
             BudgetView()
                .tabItem {
                    Label("Income", systemImage: "creditcard")
                }
        }
        .onAppear {
            expenseViewModel.setContext(modelContext)
            expenseViewModel.loadInitialData()
            
            goalViewModel.setContext(modelContext)
            goalViewModel.loadInitialData()
            
            savingViewModel.setContext(modelContext)
            savingViewModel.loadInitialData()
        }
    }
}
