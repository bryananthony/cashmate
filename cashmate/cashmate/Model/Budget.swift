import Foundation
import SwiftData

@Model
class Budget {
    var amount: Double

    init(amount: Double) {
        self.amount = amount
    }
}
