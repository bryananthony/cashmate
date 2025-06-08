import XCTest
import SwiftData
@testable import cashmate

@MainActor
final class CashmateTests: XCTestCase {
    
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!
    
    override func setUp() async throws {
        try await super.setUp()
        
        // Create in-memory model container for testing
        modelContainer = try ModelContainer(
            for: Expense.self, BudgetSetting.self, Goal.self, Saving.self, Budget.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        modelContext = modelContainer.mainContext
    }
    
    override func tearDown() async throws {
        modelContainer = nil
        modelContext = nil
        try await super.tearDown()
    }
    
    // MARK: - Model Tests
    
    func testExpenseModel() throws {
        // Test Expense initialization
        let expense = Expense(desc: "Test Expense", amount: 100.0, date: Date())
        
        XCTAssertNotNil(expense.id)
        XCTAssertEqual(expense.desc, "Test Expense")
        XCTAssertEqual(expense.amount, 100.0)
        XCTAssertNil(expense.photoData)
    }
    
    func testGoalModel() throws {
        // Test Goal initialization
        let goal = Goal(name: "iPhone 16", targetAmount: 15000000.0)
        
        XCTAssertNotNil(goal.id)
        XCTAssertEqual(goal.name, "iPhone 16")
        XCTAssertEqual(goal.targetAmount, 15000000.0)
        XCTAssertFalse(goal.isCompleted)
        XCTAssertNil(goal.completedDate)
        XCTAssertNotNil(goal.createdAt)
    }
    
    func testSavingModel() throws {
        // Test Saving initialization
        let goal = Goal(name: "Test Goal", targetAmount: 1000.0)
        let saving = Saving(amount: 500.0, note: "Test saving", goal: goal)
        
        XCTAssertNotNil(saving.id)
        XCTAssertEqual(saving.amount, 500.0)
        XCTAssertEqual(saving.note, "Test saving")
        XCTAssertEqual(saving.goal?.name, "Test Goal")
    }
    
    func testBudgetModel() throws {
        // Test Budget initialization
        let budget = Budget(amount: 5000000.0)
        
        XCTAssertEqual(budget.amount, 5000000.0)
    }
    
    func testBudgetSettingModel() throws {
        // Test BudgetSetting initialization
        let budgetSetting = BudgetSetting(monthlyBudget: 3000000.0)
        
        XCTAssertEqual(budgetSetting.monthlyBudget, 3000000.0)
    }
    
    // MARK: - ExpenseViewModel Tests
    
    func testExpenseViewModelInitialization() async throws {
        let viewModel = ExpenseViewModel()
        viewModel.setContext(modelContext)
        
        XCTAssertTrue(viewModel.expenses.isEmpty)
        XCTAssertTrue(viewModel.budgetSettings.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testAddExpense() async throws {
        let viewModel = ExpenseViewModel()
        viewModel.setContext(modelContext)
        
        // Add an expense
        viewModel.addExpense(desc: "Test Expense", amount: 100.0, photoData: nil)
        
        // Verify expense was added
        XCTAssertEqual(viewModel.expenses.count, 1)
        XCTAssertEqual(viewModel.expenses.first?.desc, "Test Expense")
        XCTAssertEqual(viewModel.expenses.first?.amount, 100.0)
    }
    
    func testDeleteExpense() async throws {
        let viewModel = ExpenseViewModel()
        viewModel.setContext(modelContext)
        
        // Add an expense first
        viewModel.addExpense(desc: "Test Expense", amount: 100.0, photoData: nil)
        XCTAssertEqual(viewModel.expenses.count, 1)
        
        // Delete the expense
        let expense = viewModel.expenses.first!
        viewModel.deleteExpense(expense)
        
        // Verify expense was deleted
        XCTAssertEqual(viewModel.expenses.count, 0)
    }
    
    func testUpdateExpense() async throws {
        let viewModel = ExpenseViewModel()
        viewModel.setContext(modelContext)
        
        // Add an expense first
        viewModel.addExpense(desc: "Original Desc", amount: 100.0, photoData: nil)
        let expense = viewModel.expenses.first!
        
        // Update the expense
        viewModel.updateExpense(expense, desc: "Updated Desc", amount: 200.0, photoData: nil)
        
        // Verify expense was updated
        XCTAssertEqual(viewModel.expenses.first?.desc, "Updated Desc")
        XCTAssertEqual(viewModel.expenses.first?.amount, 200.0)
    }
    
    func testFormatCurrency() async throws {
        let viewModel = ExpenseViewModel()
        
        let formatted = viewModel.formatCurrency(1000000.0)
        
        // Should contain currency formatting for Indonesian Rupiah
        XCTAssertTrue(formatted.contains("1.000.000") || formatted.contains("1,000,000"))
    }
    
    func testGetCurrentBudget() async throws {
        let viewModel = ExpenseViewModel()
        viewModel.setContext(modelContext)
        
        let budget = viewModel.getCurrentBudget()
        
        XCTAssertNotNil(budget)
        XCTAssertEqual(budget.monthlyBudget, 5_000_000) // Default budget
    }
    
    func testUpdateBudget() throws {
        let viewModel = ExpenseViewModel()
        viewModel.setContext(modelContext)
        viewModel.loadInitialData()
        
        let newBudgetAmount = 3_000_000.0
        viewModel.updateBudget(newBudgetAmount)
        
        let updatedBudget = viewModel.getCurrentBudget()
        XCTAssertEqual(updatedBudget.monthlyBudget, newBudgetAmount)
    }

    
    // MARK: - GoalViewModel Tests
    
    func testGoalViewModelInitialization() async throws {
        let viewModel = GoalViewModel()
        viewModel.setContext(modelContext)
        
        XCTAssertTrue(viewModel.goals.isEmpty)
    }
    
    func testAddGoal() async throws {
        let viewModel = GoalViewModel()
        viewModel.setContext(modelContext)
        
        viewModel.addGoal(name: "Test Goal", targetAmount: 1000000.0)
        
        XCTAssertEqual(viewModel.goals.count, 1)
        XCTAssertEqual(viewModel.goals.first?.name, "Test Goal")
        XCTAssertEqual(viewModel.goals.first?.targetAmount, 1000000.0)
    }
    
    func testCompleteGoal() async throws {
        let viewModel = GoalViewModel()
        viewModel.setContext(modelContext)
        
        // Add a goal first
        viewModel.addGoal(name: "Test Goal", targetAmount: 1000000.0)
        let goal = viewModel.goals.first!
        
        // Complete the goal
        viewModel.completeGoal(goal)
        
        XCTAssertTrue(goal.isCompleted)
        XCTAssertNotNil(goal.completedDate)
    }
    
    func testCurrentGoal() async throws {
        let viewModel = GoalViewModel()
        viewModel.setContext(modelContext)
        
        // Initially no current goal
        XCTAssertNil(viewModel.currentGoal())
        
        // Add a goal
        viewModel.addGoal(name: "Active Goal", targetAmount: 1000000.0)
        
        let currentGoal = viewModel.currentGoal()
        XCTAssertNotNil(currentGoal)
        XCTAssertEqual(currentGoal?.name, "Active Goal")
        XCTAssertFalse(currentGoal?.isCompleted ?? true)
    }
    
    func testGoalFormatCurrency() async throws {
        let viewModel = GoalViewModel()
        
        let formatted = viewModel.formatCurrency(2000000.0)
        
        XCTAssertTrue(formatted.contains("2.000.000") || formatted.contains("2,000,000"))
    }
    
    // MARK: - SavingViewModel Tests
    
    func testSavingViewModelInitialization() async throws {
        let viewModel = SavingViewModel()
        viewModel.setContext(modelContext)
        
        XCTAssertTrue(viewModel.savings.isEmpty)
    }
    
    func testAddSaving() async throws {
        let savingViewModel = SavingViewModel()
        let goalViewModel = GoalViewModel()
        
        savingViewModel.setContext(modelContext)
        goalViewModel.setContext(modelContext)
        
        // Add a goal first
        goalViewModel.addGoal(name: "Test Goal", targetAmount: 1000000.0)
        let goal = goalViewModel.goals.first!
        
        // Add saving for the goal
        savingViewModel.addSaving(amount: 500000.0, note: "Test saving", goal: goal)
        
        XCTAssertEqual(savingViewModel.savings.count, 1)
        XCTAssertEqual(savingViewModel.savings.first?.amount, 500000.0)
        XCTAssertEqual(savingViewModel.savings.first?.note, "Test saving")
    }
    
    func testDeleteSaving() async throws {
        let viewModel = SavingViewModel()
        viewModel.setContext(modelContext)
        
        // Add a saving first
        viewModel.addSaving(amount: 100000.0)
        XCTAssertEqual(viewModel.savings.count, 1)
        
        // Delete the saving
        let saving = viewModel.savings.first!
        viewModel.deleteSaving(saving)
        
        XCTAssertEqual(viewModel.savings.count, 0)
    }
    
    func testTotalSavings() async throws {
        let savingViewModel = SavingViewModel()
        let goalViewModel = GoalViewModel()
        
        savingViewModel.setContext(modelContext)
        goalViewModel.setContext(modelContext)
        
        // Add a goal
        goalViewModel.addGoal(name: "Test Goal", targetAmount: 1000000.0)
        let goal = goalViewModel.goals.first!
        
        // Add multiple savings for the goal
        savingViewModel.addSaving(amount: 300000.0, goal: goal)
        savingViewModel.addSaving(amount: 200000.0, goal: goal)
        savingViewModel.addSaving(amount: 100000.0) // No goal
        
        let totalForGoal = savingViewModel.totalSavings(for: goal)
        let totalOverall = savingViewModel.totalSavings()
        
        XCTAssertEqual(totalForGoal, 500000.0)
        XCTAssertEqual(totalOverall, 600000.0)
    }
    
    func testSavingFormatCurrency() async throws {
        let viewModel = SavingViewModel()
        
        let formatted = viewModel.formatCurrency(500000.0)
        
        XCTAssertTrue(formatted.contains("500.000") || formatted.contains("500,000"))
    }
    
    // MARK: - BudgetViewModel Tests
    
    func testBudgetViewModelInitialization() async throws {
        let viewModel = BudgetViewModel()
        
        XCTAssertTrue(viewModel.expenses.isEmpty)
        XCTAssertNil(viewModel.budget)
        XCTAssertEqual(viewModel.totalExpenses, 0.0)
        XCTAssertEqual(viewModel.remainingBudget, 0.0)
        XCTAssertEqual(viewModel.progress, 0.0)
    }
    
    func testBudgetViewModelWithExpenses() async throws {
        let viewModel = BudgetViewModel()
        
        // Create mock expenses for current month
        let currentDate = Date()
        let expense1 = Expense(desc: "Expense 1", amount: 100000.0, date: currentDate)
        let expense2 = Expense(desc: "Expense 2", amount: 200000.0, date: currentDate)
        
        // Create mock budget
        let budget = Budget(amount: 1000000.0)
        
        // Set up the view model
        viewModel.setExpenses([expense1, expense2])
        viewModel.setBudget(budget)
        
        XCTAssertEqual(viewModel.totalExpenses, 300000.0)
        XCTAssertEqual(viewModel.remainingBudget, 700000.0)
        XCTAssertEqual(viewModel.progress, 0.3, accuracy: 0.01)
    }
    
    func testBudgetViewModelOverBudget() async throws {
        let viewModel = BudgetViewModel()
        
        // Create expenses that exceed budget
        let currentDate = Date()
        let expense1 = Expense(desc: "Expensive Item", amount: 1500000.0, date: currentDate)
        
        let budget = Budget(amount: 1000000.0)
        
        viewModel.setExpenses([expense1])
        viewModel.setBudget(budget)
        
        XCTAssertEqual(viewModel.totalExpenses, 1500000.0)
        XCTAssertEqual(viewModel.remainingBudget, -500000.0) // Negative remaining budget
        XCTAssertEqual(viewModel.progress, 1.0) // Progress capped at 1.0
    }
    
    // MARK: - Integration Tests
    
    func testGoalSavingIntegration() async throws {
        let goalViewModel = GoalViewModel()
        let savingViewModel = SavingViewModel()
        
        goalViewModel.setContext(modelContext)
        savingViewModel.setContext(modelContext)
        
        // Create a goal
        goalViewModel.addGoal(name: "Integration Test Goal", targetAmount: 1000000.0)
        let goal = goalViewModel.currentGoal()!
        
        // Add savings towards the goal
        savingViewModel.addSaving(amount: 250000.0, goal: goal)
        savingViewModel.addSaving(amount: 300000.0, goal: goal)
        
        let totalSaved = savingViewModel.totalSavings(for: goal)
        XCTAssertEqual(totalSaved, 550000.0)
        
        // Check if goal can be completed when target is reached
        savingViewModel.addSaving(amount: 450000.0, goal: goal)
        let finalTotal = savingViewModel.totalSavings(for: goal)
        XCTAssertEqual(finalTotal, 1000000.0)
        XCTAssertGreaterThanOrEqual(finalTotal, goal.targetAmount)
    }
    
    func testExpenseBudgetIntegration() async throws {
        let expenseViewModel = ExpenseViewModel()
        let budgetViewModel = BudgetViewModel()
        
        expenseViewModel.setContext(modelContext)
        
        // Set up budget
        expenseViewModel.updateBudget(2000000.0)
        let budget = Budget(amount: 2000000.0)
        budgetViewModel.setBudget(budget)
        
        // Add expenses
        expenseViewModel.addExpense(desc: "Groceries", amount: 500000.0, photoData: nil)
        expenseViewModel.addExpense(desc: "Transportation", amount: 300000.0, photoData: nil)
        
        // Update budget view model with expenses
        budgetViewModel.setExpenses(expenseViewModel.expenses)
        
        XCTAssertEqual(budgetViewModel.totalExpenses, 800000.0)
        XCTAssertEqual(budgetViewModel.remainingBudget, 1200000.0)
        XCTAssertEqual(budgetViewModel.progress, 0.4, accuracy: 0.01)
    }
    
    // MARK: - Edge Cases Tests
    
    func testEmptyStateHandling() async throws {
        let expenseViewModel = ExpenseViewModel()
        let goalViewModel = GoalViewModel()
        let savingViewModel = SavingViewModel()
        
        expenseViewModel.setContext(modelContext)
        goalViewModel.setContext(modelContext)
        savingViewModel.setContext(modelContext)
        
        // Test empty states
        XCTAssertTrue(expenseViewModel.expenses.isEmpty)
        XCTAssertTrue(goalViewModel.goals.isEmpty)
        XCTAssertTrue(savingViewModel.savings.isEmpty)
        XCTAssertNil(goalViewModel.currentGoal())
        XCTAssertEqual(savingViewModel.totalSavings(), 0.0)
    }
    
    func testInvalidDataHandling() async throws {
        let expenseViewModel = ExpenseViewModel()
        expenseViewModel.setContext(modelContext)
        
        // Test with empty description (should still work)
        expenseViewModel.addExpense(desc: "", amount: 100.0, photoData: nil)
        XCTAssertEqual(expenseViewModel.expenses.count, 1)
        XCTAssertEqual(expenseViewModel.expenses.first?.desc, "")
        
        // Test with zero amount
        expenseViewModel.addExpense(desc: "Zero Amount", amount: 0.0, photoData: nil)
        XCTAssertEqual(expenseViewModel.expenses.count, 2)
        XCTAssertEqual(expenseViewModel.expenses.first?.amount, 0.0)
    }
    
    func testCurrencyFormattingEdgeCases() async throws {
        let viewModel = ExpenseViewModel()
        
        // Test with zero
        let zeroFormatted = viewModel.formatCurrency(0.0)
        XCTAssertNotNil(zeroFormatted)
        
        // Test with negative amount
        let negativeFormatted = viewModel.formatCurrency(-100.0)
        XCTAssertNotNil(negativeFormatted)
        
        // Test with very large amount
        let largeFormatted = viewModel.formatCurrency(999999999.0)
        XCTAssertNotNil(largeFormatted)
    }
}
