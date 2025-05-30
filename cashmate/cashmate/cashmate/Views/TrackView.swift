//
//  TrackView.swift
//  cashmate
//
//  Created by student on 30/05/25.
//
import SwiftUI
import SwiftData

struct TrackView: View {
    @Query var expenses: [ExpenseItem]
    @State private var showAddExpense = false

    var body: some View {
        VStack {
            if expenses.isEmpty {
                Text("No expenses yet")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(expenses) { expense in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Price: Rp. \(Int(expense.amount))")
                                        .bold()
                                    Text("Description: \(expense.descript)")
                                    Text(expense.date, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Image(systemName: "photo.on.rectangle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(6)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Expense Tracking")
        .toolbar {
            Button {
                showAddExpense.toggle()
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showAddExpense) {
            AddExpenseView()
        }
    }
}


struct ExpenseRow: View {
    let expense: ExpenseItem

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Price: Rp. \(Int(expense.amount))")
                    .bold()
                Text("Description: \(expense.descript)")
                Text(expense.date, style: .date)
                    .font(.caption)
            }
        }
    }
}
