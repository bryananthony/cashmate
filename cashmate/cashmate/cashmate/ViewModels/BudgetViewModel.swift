//
//  BudgetViewModel.swift
//  cashmate
//
//  Created by student on 30/05/25.
//

import SwiftUI

@Observable
class BudgetViewModel {
    var expenses: [ExpenseItem] = []
    var budget: Budget?

    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    var remainingBudget: Double {
        max((budget?.amount ?? 0) - totalExpenses, 0)
    }

    var progress: Double {
        guard let budget = budget, budget.amount > 0 else { return 0 }
        return min(totalExpenses / budget.amount, 1)
    }
}
