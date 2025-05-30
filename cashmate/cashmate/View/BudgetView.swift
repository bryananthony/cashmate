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
                    .foregroundColor(viewModel.remainingBudget >= 0 ? .green : .red) // Color red if negative
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
        }
        .onChange(of: expenses) { _ in
            viewModel.setExpenses(expenses)
        }
        .onChange(of: budgets) { _ in
            syncViewModel()
        }
        .onChange(of: budgetInput) { _ in
            // Sync the budget when the input changes
            if let budget = budgets.first {
                viewModel.setBudget(budget)
            }
        }
    }

    private func syncViewModel() {
        // Sync the ViewModel with the latest data
        viewModel.setExpenses(expenses)

        // Explicitly reload the latest budget from the context
        if let latestBudget = budgets.first {
            viewModel.setBudget(latestBudget)
        }

        // Set the text field value to the current budget amount
        if let budget = budgets.first {
            budgetInput = String(format: "%.0f", budget.amount)
        }
    }

    private func saveBudget() {
        guard let value = Double(budgetInput) else { return }

        // Check if a budget already exists
        if let existing = budgets.first {
            existing.amount = value
            viewModel.setBudget(existing)
        } else {
            // Create a new budget if none exists
            let newBudget = Budget(amount: value)
            context.insert(newBudget)
            viewModel.setBudget(newBudget)
        }

        do {
            try context.save()  // Commit the changes to the context
            // After saving, we explicitly refresh the data
            syncViewModel()
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
