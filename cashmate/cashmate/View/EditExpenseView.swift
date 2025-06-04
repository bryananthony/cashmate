struct EditExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ExpenseViewModel

    var expense: Expense

    @State private var desc: String
    @State private var amount: String
    @State private var photoData: Data?

    init(viewModel: ExpenseViewModel, expense: Expense) {
        self.viewModel = viewModel
        self.expense = expense
        _desc = State(initialValue: expense.desc)
        _amount = State(initialValue: String(format: "%.0f", expense.amount))
        _photoData = State(initialValue: expense.photoData)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Description", text: $desc)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                // Tambahkan image picker jika perlu
            }
            .navigationTitle("Edit Expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let value = Double(amount) {
                            expense.desc = desc
                            expense.amount = value
                            expense.photoData = photoData
                            try? viewModel.modelContext?.save()
                            viewModel.loadInitialData()
                            dismiss()
                        }
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
