//
//  ExpenseTrackingView.swift
//  cashmate
//
//  Created by student on 30/05/25.
//

// ExpenseTrackingView.swift
// Place this in cashmate/cashmateApp group
// ExpenseTrackingView.swift
// ExpenseTrackingView.swift
import SwiftUI

struct ExpenseTrackView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var showAddExpense = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.expenses.isEmpty {
                    emptyStateView
                } else {
                    expenseListView
                }
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddExpense = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddExpense) {
                AddExpenseView(viewModel: viewModel)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Text("SELAMAT DATANG!")
                .font(.title)
                .bold()
            
            Text("Anda belum memiliki transaksi\nSilahkan menambahkan transaksi")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            Button(action: { showAddExpense = true }) {
                Label("Tambah Transaksi", systemImage: "plus")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var expenseListView: some View {
        List {
            ForEach(viewModel.expenses.sorted { $0.date > $1.date }) { expense in
                VStack(alignment: .leading, spacing: 4) {
                    Text(expense.desc)
                        .font(.headline)
                    
                    HStack {
                        Text(viewModel.formatCurrency(expense.amount))
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // Display photo if available
                    if let photoData = expense.photoData,
                       let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 150)
                            .cornerRadius(8)
                            .padding(.top, 4)
                    }
                }
                .padding(.vertical, 8)
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        viewModel.deleteExpense(expense)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}
