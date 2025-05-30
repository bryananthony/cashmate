//
//  ExpenseItem.swift
//  cashmate
//
//  Created by student on 30/05/25.
//
import Foundation
import SwiftData

@Model
class ExpenseItem {
    var amount: Double
    var descript: String
    var date: Date
    
    init(amount: Double, description: String, date: Date) {
        self.amount = amount
        self.descript = description
        self.date = date
    }
}
