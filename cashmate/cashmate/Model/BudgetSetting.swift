import Foundation
import SwiftData

@Model
final class BudgetSetting {
    var monthlyBudget: Double
    
    init(monthlyBudget: Double) {
        self.monthlyBudget = monthlyBudget
    }
}