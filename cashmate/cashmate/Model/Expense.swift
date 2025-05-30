import Foundation
import SwiftData

@Model
final class Expense {
    var id: UUID
    var desc: String
    var amount: Double
    var date: Date
    var photoData: Data?
    
    init(desc: String, amount: Double, date: Date, photoData: Data? = nil) {
        self.id = UUID()
        self.desc = desc
        self.amount = amount
        self.date = date
        self.photoData = photoData
    }
}