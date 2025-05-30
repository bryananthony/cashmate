import SwiftUI

struct AddGoalView: View {
    @ObservedObject var viewModel: GoalViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var targetAmount: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Goal Name (e.g. iPhone 16)", text: $name)
                    TextField("Target Amount", text: $targetAmount)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let amount = Double(targetAmount) {
                            viewModel.addGoal(name: name, targetAmount: amount)
                            dismiss()
                        }
                    }
                    .disabled(name.isEmpty || targetAmount.isEmpty)
                }
            }
        }
    }
}