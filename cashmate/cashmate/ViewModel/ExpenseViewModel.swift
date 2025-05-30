import SwiftData
import SwiftUI

@MainActor
class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var budgetSettings: [BudgetSetting] = []
    @Published var errorMessage: String?
    @Published var isLoading = false

    private var modelContext: ModelContext?

    func setContext(_ context: ModelContext) {
        self.modelContext = context
    }

    func loadInitialData() {
        guard let context = modelContext else {
            errorMessage = "ModelContext not available."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try fetchData(from: context)

            if !has2024Data() {
                try create2024DummyData(using: context)
                try fetchData(from: context)
            }
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
            expenses = []
            budgetSettings = []
        }
    }

    private func fetchData(from context: ModelContext) throws {
        let expenseDescriptor = FetchDescriptor<Expense>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        expenses = try context.fetch(expenseDescriptor)

        let budgetDescriptor = FetchDescriptor<BudgetSetting>()
        budgetSettings = try context.fetch(budgetDescriptor)
    }

    private func create2024DummyData(using context: ModelContext) throws {
        let has2024 = expenses.contains {
            Calendar.current.component(.year, from: $0.date) == 2024
        }

        guard !has2024 else { return }

        let months = Calendar.current.monthSymbols

        for (index, month) in months.enumerated() {
            let expense = Expense(
                desc: "Expense for \(month)",
                amount: Double.random(in: 100_000...5_000_000),
                date: Calendar.current.date(from: DateComponents(year: 2024, month: index + 1, day: Int.random(in: 1...28)))!,
                photoData: nil
            )
            context.insert(expense)
        }

        try context.save()
    }

    func addExpense(desc: String, amount: Double, photoData: Data?) {
        guard let context = modelContext else { return }
        let newExpense = Expense(desc: desc, amount: amount, date: Date(), photoData: photoData)
        context.insert(newExpense)
        try? context.save()
        try? fetchData(from: context)
    }

    func deleteExpense(_ expense: Expense) {
        guard let context = modelContext else { return }
        context.delete(expense)
        try? context.save()
        try? fetchData(from: context)
    }

    func getCurrentBudget() -> BudgetSetting {
        guard let context = modelContext else {
            return BudgetSetting(monthlyBudget: 0)
        }

        if let existing = budgetSettings.first {
            return existing
        } else {
            let newBudget = BudgetSetting(monthlyBudget: 5_000_000)
            context.insert(newBudget)
            try? context.save()
            return newBudget
        }
    }

    func updateBudget(_ newBudget: Double) {
        let budget = getCurrentBudget()
        budget.monthlyBudget = newBudget
        try? modelContext?.save()
    }

    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: NSNumber(value: value)) ?? "Rp \(Int(value))"
    }

    private func has2024Data() -> Bool {
        expenses.contains { Calendar.current.component(.year, from: $0.date) == 2024 }
    }
}