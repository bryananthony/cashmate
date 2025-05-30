import SwiftData
import SwiftUI

@MainActor
class GoalViewModel: ObservableObject {
    private var modelContext: ModelContext?
    
    @Published var goals: [Goal] = []
    
    init() {
        // modelContext will be set later
    }
    
    func setContext(_ context: ModelContext) {
        self.modelContext = context
        fetchData()
    }
    
    func fetchData() {
        guard let modelContext else { return }
        let descriptor = FetchDescriptor<Goal>(sortBy: [SortDescriptor(\.createdAt)])
        goals = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func addGoal(name: String, targetAmount: Double) {
        guard let modelContext else { return }
        let newGoal = Goal(name: name, targetAmount: targetAmount)
        modelContext.insert(newGoal)
        fetchData()
    }
    
    func completeGoal(_ goal: Goal) {
        guard let modelContext else { return }
        goal.isCompleted = true
        goal.completedDate = Date()
        fetchData()
    }
    
    func currentGoal() -> Goal? {
        goals.first(where: { !$0.isCompleted })
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: NSNumber(value: value)) ?? "Rp \(Int(value))"
    }
    
    func loadInitialData() {
        fetchData()
    }
}