import Foundation
import SwiftUI
import SwiftData


class BudgetViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var budget: Budget?

    var totalExpenses: Double {
        let calendar = Calendar.current
        return expenses.filter {
            // Filter expenses to only include those from the current month
            calendar.isDate($0.date, equalTo: Date(), toGranularity: .month)
        }
        .reduce(0) { $0 + $1.amount } // Sum the expense amounts
    }

    var remainingBudget: Double {
        // Ensure there is a valid budget before calculating remaining
        guard let firstBudget = budget else { return 0 }
        return firstBudget.amount - totalExpenses  // No max to avoid going to 0
    }

    var progress: Double {
        // Calculate progress based on the budget and total expenses
        guard let firstBudget = budget, firstBudget.amount > 0 else { return 0 }
        return min(totalExpenses / firstBudget.amount, 1) // Ensure progress is between 0 and 1
    }

    // Sync expenses from @Query
    func setExpenses(_ expenses: [Expense]) {
        self.expenses = expenses
    }

    // Sync budget from @Query
    func setBudget(_ budget: Budget?) {
        self.budget = budget
    }
}
