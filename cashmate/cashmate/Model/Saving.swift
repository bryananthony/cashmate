import Foundation
import SwiftData

@Model
final class Saving {
    var id: UUID
    var amount: Double
    var date: Date
    var note: String
    var goal: Goal?
    
    init(amount: Double, date: Date = Date(), note: String = "", goal: Goal? = nil) {
        self.id = UUID()
        self.amount = amount
        self.date = date
        self.note = note
        self.goal = goal
    }
}