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
            .navigationBarTitleDisplayMode(.inline)
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
            Text("WELCOME!")
                .font(.title)
                .bold()
            
            Text("You don't have any transactions yet\nPlease add a transaction")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            Button(action: { showAddExpense = true }) {
                Label("Add Transaction", systemImage: "plus")
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
            ForEach(viewModel.expenses) { expense in
                ExpenseCard(expense: expense, viewModel: viewModel)
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
