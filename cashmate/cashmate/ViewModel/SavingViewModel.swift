import SwiftData
import SwiftUI

@MainActor
class SavingViewModel: ObservableObject {
    private var modelContext: ModelContext?
    
    @Published var savings: [Saving] = []
    
    init() {
        // modelContext will be set later
    }
    
    func setContext(_ context: ModelContext) {
        self.modelContext = context
        fetchSavings()
    }
    
    func fetchSavings() {
        guard let modelContext else { return }
        let descriptor = FetchDescriptor<Saving>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        savings = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func addSaving(amount: Double, note: String = "", goal: Goal? = nil) {
        guard let modelContext else { return }
        let newSaving = Saving(amount: amount, note: note, goal: goal)
        modelContext.insert(newSaving)
        fetchSavings()
    }
    
    func deleteSaving(_ saving: Saving) {
        guard let modelContext else { return }
        modelContext.delete(saving)
        fetchSavings()
    }
    
    func totalSavings(for goal: Goal? = nil) -> Double {
        if let goal {
            return savings.filter { $0.goal?.id == goal.id }.reduce(0) { $0 + $1.amount }
        }
        return savings.reduce(0) { $0 + $1.amount }
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: NSNumber(value: value)) ?? "Rp \(Int(value))"
    }
    
    func loadInitialData() {
        fetchSavings()
    }
}