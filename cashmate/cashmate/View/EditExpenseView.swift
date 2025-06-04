import SwiftUI

struct EditExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ExpenseViewModel

    var expense: Expense

    @State private var desc: String
    @State private var amount: String
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false

    init(viewModel: ExpenseViewModel, expense: Expense) {
        self.viewModel = viewModel
        self.expense = expense
        _desc = State(initialValue: expense.desc)
        _amount = State(initialValue: String(format: "%.0f", expense.amount))
        
        // Initialize selectedImage from existing photoData
        if let photoData = expense.photoData, let uiImage = UIImage(data: photoData) {
            _selectedImage = State(initialValue: uiImage)
        } else {
            _selectedImage = State(initialValue: nil)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Description", text: $desc)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Photo (Optional)")) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .onTapGesture { showImagePicker = true }
                        
                        // Button to remove photo
                        Button("Remove Photo", role: .destructive) {
                            self.selectedImage = nil
                        }
                    } else {
                        Button(action: { showImagePicker = true }) {
                            Label("Add Photo", systemImage: "photo")
                        }
                    }
                }
            }
            .navigationTitle("Edit Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let value = Double(amount) {
                            let photoData = selectedImage?.jpegData(compressionQuality: 0.8)
                            viewModel.updateExpense(expense, desc: desc, amount: value, photoData: photoData)
                            dismiss()
                        }
                    }
                    .disabled(desc.isEmpty || amount.isEmpty)
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
}
