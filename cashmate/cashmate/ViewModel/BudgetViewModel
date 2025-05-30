import Foundation
import SwiftUI

class BudgetViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var budget: Budget?

    var totalExpenses: Double {
        let calendar = Calendar.current
        return expenses.filter {
            calendar.isDate($0.date, equalTo: Date(), toGranularity: .month)
        }
        .reduce(0) { $0 + $1.amount }
    }

    var remainingBudget: Double {
        max((budget?.amount ?? 0) - totalExpenses, 0)
    }

    var progress: Double {
        guard let budget = budget, budget.amount > 0 else { return 0 }
        return min(totalExpenses / budget.amount, 1)
    }
}
