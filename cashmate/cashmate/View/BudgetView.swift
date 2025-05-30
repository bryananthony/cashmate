import SwiftUI
import SwiftData

struct BudgetView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Expense.date, order: .forward) var expenses: [Expense]
    @Query var budgets: [Budget]

    @StateObject private var viewModel = BudgetViewModel()
    @State private var budgetInput: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Set Your Budget per Month")
                .font(.title2)
                .bold()

            HStack {
                TextField("Enter budget", text: $budgetInput)
                    .keyboardType(.decimalPad)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                Button("Save") {
                    saveBudget()
                }
                .padding(.leading, 8)
            }

            HStack {
                Text("Total Expenses:")
                Spacer()
                Text("Rp. \(Int(viewModel.totalExpenses))")
                    .bold()
            }

            HStack {
                Text("Remaining Budget:")
                Spacer()
                Text("Rp. \(Int(viewModel.remainingBudget))")
                    .bold()
                    .foregroundColor(viewModel.remainingBudget >= 0 ? .green : .red)
            }

            ProgressView(value: viewModel.progress)
                .accentColor(.green)
                .padding(.vertical)

            Spacer()
        }
        .padding()
        .navigationTitle("Budget Tracker")
        .onAppear {
            syncViewModel()
            if let budget = budgets.first {
                budgetInput = String(format: "%.0f", budget.amount)
            }
        }
        .onChange(of: expenses) { _ in
            viewModel.expenses = expenses
        }
        .onChange(of: budgets) { _ in
            syncViewModel()
        }
    }

    private func syncViewModel() {
        viewModel.expenses = expenses
        viewModel.budget = budgets.first
    }

    private func saveBudget() {
        guard let value = Double(budgetInput) else { return }

        if let existing = budgets.first {
            existing.amount = value
            viewModel.budget = existing
        } else {
            let newBudget = Budget(amount: value)
            context.insert(newBudget)
            viewModel.budget = newBudget
        }

        do {
            try context.save()
        } catch {
            print("Failed to save budget: \(error)")
        }
    }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView()
            .previewDevice("iPhone 16 Pro")
    }
}
