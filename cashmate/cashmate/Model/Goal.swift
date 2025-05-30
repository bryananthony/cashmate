import Foundation
import SwiftData

@Model
final class Goal {
    var id: UUID
    var name: String
    var targetAmount: Double
    var isCompleted: Bool
    var completedDate: Date?
    var createdAt: Date
    
    init(name: String, targetAmount: Double, isCompleted: Bool = false, completedDate: Date? = nil) {
        self.id = UUID()
        self.name = name
        self.targetAmount = targetAmount
        self.isCompleted = isCompleted
        self.completedDate = completedDate
        self.createdAt = Date()
    }
}