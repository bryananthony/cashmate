import SwiftUI

struct ExpenseHistoryView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    
    private var monthlyExpenses: [String: [Expense]] {
        Dictionary(grouping: viewModel.expenses) { expense in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: expense.date)
        }
    }
    
    private var sortedMonths: [String] {
        monthlyExpenses.keys.sorted { (month1, month2) -> Bool in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            guard let date1 = dateFormatter.date(from: month1),
                  let date2 = dateFormatter.date(from: month2) else {
                return false
            }
            return date1 > date2
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sortedMonths, id: \.self) { month in
                    Section(header: 
                        VStack(alignment: .leading) {
                            Text(month)
                                .font(.headline)
                            
                            let total = monthlyExpenses[month]?.reduce(0) { $0 + $1.amount } ?? 0
                            let budget = viewModel.getCurrentBudget().monthlyBudget
                            let percentage = total / budget
                            
                            HStack {
                                Text("Total: \(viewModel.formatCurrency(total))")
                                Spacer()
                                Text("\(Int(percentage * 100))% of budget")
                            }
                            .font(.subheadline)
                            
                            ProgressView(value: min(percentage, 1.0), total: 1.0)
                                .tint(getProgressColor(percentage: percentage))
                        }
                    ) {
                        ForEach(monthlyExpenses[month] ?? []) { expense in
                            ExpenseCard(expense: expense, viewModel: viewModel)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.deleteExpense(expense)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Expense History")
        }
    }
    
    private func getProgressColor(percentage: Double) -> Color {
        if percentage >= 1.0 {
            return .red
        } else if percentage >= 0.75 {
            return .orange
        } else {
            return .green
        }
    }
}