import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Budget Settings")) {
                    TextField(
                        "Monthly Budget",
                        value: Binding(
                            get: { viewModel.getCurrentBudget().monthlyBudget },
                            set: { newValue in
                                viewModel.updateBudget(newValue)
                            }
                        ),
                        format: .number
                    )
                    .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}