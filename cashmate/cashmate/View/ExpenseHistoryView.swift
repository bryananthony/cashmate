import SwiftUI

struct ExpenseHistoryView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var showSettings = false
    
    private var groupedExpenses: [String: [Expense]] {
        Dictionary(grouping: viewModel.expenses) { expense in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            dateFormatter.locale = Locale(identifier: "en_US")
            return dateFormatter.string(from: expense.date)
        }
    }
    
    private var yearGroupedExpenses: [String: [String: [Expense]]] {
        Dictionary(grouping: viewModel.expenses) { expense in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            return dateFormatter.string(from: expense.date)
        }.mapValues { expenses in
            Dictionary(grouping: expenses) { expense in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM"
                dateFormatter.locale = Locale(identifier: "en_US")
                return dateFormatter.string(from: expense.date)
            }
        }
    }
    
    private func monthlyTotal(for expenses: [Expense]) -> Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    private func getCardColor(for amount: Double) -> Color {
        let budget = viewModel.getCurrentBudget().monthlyBudget
        guard budget > 0 else { return .gray }

        let percentage = amount / budget

        if percentage >= 1.0 {
            return .red
        } else if percentage >= 0.5 {
            return .orange
        } else if percentage >= 0.25 {
            return .yellow
        } else {
            return .green
        }
    }

        private var sortedYears: [String] {
        yearGroupedExpenses.keys.sorted().reversed()
    }
    
    // Method to get sorted months for a year
    private func getSortedMonths(for year: String) -> [String] {
        let monthsData = yearGroupedExpenses[year] ?? [:]
        let months = ["January", "February", "March", "April", "May", "June",
                     "July", "August", "September", "October", "November", "December"]
        
        return monthsData.keys.sorted { month1, month2 in
            let index1 = months.firstIndex(of: month1) ?? 0
            let index2 = months.firstIndex(of: month2) ?? 0
            return index1 > index2 // Reverse order (newest first)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(sortedYears, id: \.self) { year in
                        yearSectionView(for: year)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(viewModel: viewModel)
            }
        }
    }
    
    // Extracted year section to separate view
    @ViewBuilder
    private func yearSectionView(for year: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Year Header
            Text(year)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
            
            // Month Cards
            ForEach(getSortedMonths(for: year), id: \.self) { month in
                monthCardView(year: year, month: month)
            }
        }
    }
    
    @ViewBuilder
    private func monthCardView(year: String, month: String) -> some View {
        let monthsData = yearGroupedExpenses[year] ?? [:]
        let expenses = monthsData[month] ?? []
        let total = monthlyTotal(for: expenses)
        
        Button(action: {
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(formatCurrency(total))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(month)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .background(getCardColor(for: total))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "IDR"
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "0"
    }
}
