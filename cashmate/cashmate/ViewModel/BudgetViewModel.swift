import Foundation
import SwiftUI
import SwiftData

class BudgetViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var budget: Budget? // Nullable to handle the case where there's no budget
    
    var totalExpenses: Double {
        let calendar = Calendar.current
        return expenses.filter {
            calendar.isDate($0.date, equalTo: Date(), toGranularity: .month)
        }
        .reduce(0) { $0 + $1.amount }
    }
    
    var remainingBudget: Double {
        guard let budget = budget else { return 0 }
        return max(budget.amount - totalExpenses, 0)
    }
    
    var progress: Double {
        guard let budget = budget, budget.amount > 0 else { return 0 }
        return min(totalExpenses / budget.amount, 1)
    }
    
    func setExpenses(_ expenses: [Expense]) {
        self.expenses = expenses
    }
    
    func setBudget(_ budget: Budget?) {
        self.budget = budget
    }
    
    // Fetch the latest budget from the context (if it's updated or newly created)
    func fetchLatestBudget(budgets: [Budget]) {
        if let latestBudget = budgets.first {
            setBudget(latestBudget)
        }
    }
}
