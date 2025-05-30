//
//  Goal.swift
//  cashmate
//
//  Created by student on 30/05/25.
//
import Foundation
import SwiftData
@Model
class Goal {
    var title: String
    var targetAmount: Double
    var savedAmount: Double

    init(title: String, targetAmount: Double, savedAmount: Double) {
        self.title = title
        self.targetAmount = targetAmount
        self.savedAmount = savedAmount
    }
}

