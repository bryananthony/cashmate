//
//  HistoryView.swift
//  cashmate
//
//  Created by student on 30/05/25.
//
import SwiftUI
import SwiftData
struct HistoryView: View {
    @Query var expenses: [ExpenseItem]

    var monthlyTotals: [(String, Double)] {
        Dictionary(grouping: expenses) { expense in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM"
            return formatter.string(from: expense.date)
        }
        .mapValues { $0.reduce(0) { $0 + $1.amount } }
        .sorted { $0.key < $1.key }
    }

    func color(for amount: Double) -> Color {
        switch amount {
        case 10000...: return .red
        case 3000..<10000: return .yellow
        default: return .green
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("2024")
                .font(.headline)
                .padding(.top)

            ForEach(monthlyTotals, id: \.0) { (month, total) in
                HStack {
                    Text("Rp. \(Int(total))")
                        .bold()
                    Spacer()
                    Text(month)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(color(for: total).opacity(0.7))
                .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("History")
    }
}
