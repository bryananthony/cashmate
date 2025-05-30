//
//  BudgetView.swift
//  cashmate
//
//  Created by student on 30/05/25.
//
import SwiftUI
import SwiftData

struct BudgetView: View {
    @Environment(\.modelContext) private var context
    @Query var expenses: [ExpenseItem]
    @Query var budgets: [Budget]
    @State private var viewModel = BudgetViewModel()
    @State private var budgetInput: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Set Your Budget per Month")
                .font(.title2)
                .bold()

            HStack {
                TextField("Enter budget", text: $budgetInput)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                Button("Save") {
                    if let value = Double(budgetInput) {
                        if let existing = budgets.first {
                            existing.amount = value
                            viewModel.budget = existing
                        } else {
                            let newBudget = Budget(amount: value)
                            context.insert(newBudget)
                            viewModel.budget = newBudget
                        }
                    }
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

            Spacer()
        }
        .padding()
        .navigationTitle("Budget Tracker")
        .onAppear {
            viewModel.expenses = expenses
            viewModel.budget = budgets.first
        }
    }
}


struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView()
            .previewDevice("iPhone 16 Pro")
    }
}
