import SwiftUI

struct GoalsView: View {
    @ObservedObject var goalViewModel: GoalViewModel
    @ObservedObject var savingViewModel: SavingViewModel
    @State private var showAddGoal = false
    @State private var showSavingForm = false
    @State private var savingAmount: String = ""
    @State private var showHistory = false
    @State private var showProfile = false

    
    var activeGoals: [Goal] {
        goalViewModel.goals.filter { !$0.isCompleted }
    }
    
    var completedGoals: [Goal] {
        goalViewModel.goals.filter { $0.isCompleted }
    }
    
    var pieChartData: [PieChartData] {
        guard let currentGoal = goalViewModel.currentGoal() else { return [] }
        let saved = savingViewModel.totalSavings(for: currentGoal)
        let remaining = max(0, currentGoal.targetAmount - saved)
        
        return [
            PieChartData(value: saved, color: .blue, label: "Saved"),
            PieChartData(value: remaining, color: .gray, label: "Remaining")
        ]
    }
    
    var body: some View {
        
        NavigationStack {
            List {
                if let currentGoal = goalViewModel.currentGoal() {
                    Section {
                        VStack(alignment: .center) {
                            PieChartView(data: pieChartData)
                                .frame(height: 200)
                                .padding()
                            
                            Text("\(savingViewModel.formatCurrency(savingViewModel.totalSavings(for: currentGoal))) / \(goalViewModel.formatCurrency(currentGoal.targetAmount))")
                                .font(.headline)
                            
                            if savingViewModel.totalSavings(for: currentGoal) >= currentGoal.targetAmount {
                                Button("Tap to Complete") {
                                    goalViewModel.completeGoal(currentGoal)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.green)
                                .padding(.top)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Section {
                        Button(action: { showSavingForm = true }) {
                            Label("Add Saving", systemImage: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Section(header: Text("Active Goals")) {
                    if activeGoals.isEmpty {
                        Text("No active goals")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(activeGoals) { goal in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(goal.name)
                                    .font(.headline)
                                
                                HStack {
                                    Text("Target:")
                                    Text(goalViewModel.formatCurrency(goal.targetAmount))
                                        .font(.subheadline)
                                }
                                
                                let progress = min(savingViewModel.totalSavings(for: goal) / goal.targetAmount, 1.0)
                                ProgressView(value: progress, total: 1.0)
                                    .tint(.blue)
                                
                                HStack {
                                    Text("Saved:")
                                    Text(savingViewModel.formatCurrency(savingViewModel.totalSavings(for: goal)))
                                        .font(.subheadline)
                                    Spacer()
                                    Text("\(Int(progress * 100))%")
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                
                Section(header: Text("Completed Goals")) {
                    if completedGoals.isEmpty {
                        Text("No completed goals")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(completedGoals) { goal in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text(goal.name)
                                        .font(.headline)
                                }
                                
                                if let completedDate = goal.completedDate {
                                    Text("Completed on \(completedDate.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: { showHistory = true }) {
                            Image(systemName: "clock.arrow.circlepath")
                        }
                        
                        Button(action: { showAddGoal = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showProfile) {
                ProfileView()
            }

            .sheet(isPresented: $showAddGoal) {
                AddGoalView(viewModel: goalViewModel)
            }
            .sheet(isPresented: $showSavingForm) {
                NavigationStack {
                    Form {
                        Section(header: Text("Add Saving")) {
                            TextField("Amount", text: $savingAmount)
                                .keyboardType(.decimalPad)
                        }
                    }
                    .navigationTitle("Add Saving")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                if let amount = Double(savingAmount) {
                                    savingViewModel.addSaving(amount: amount, goal: goalViewModel.currentGoal())
                                    savingAmount = ""
                                    showSavingForm = false
                                }
                            }
                            .disabled(savingAmount.isEmpty)
                        }
                    }
                }
            }
            .sheet(isPresented: $showHistory) {
                NavigationStack {
                    List {
                        ForEach(completedGoals) { goal in
                            VStack(alignment: .leading) {
                                Text(goal.name)
                                    .font(.headline)
                                Text("\(goalViewModel.formatCurrency(goal.targetAmount)) - Completed on \(goal.completedDate?.formatted(date: .abbreviated, time: .omitted) ?? "")")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .navigationTitle("Goals")
                    .navigationTitle("Goals History")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        // LEFT: Profile button
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                showProfile = true
                            }) {
                                Image(systemName: "person.crop.circle")
                            }
                        }
                        
                        // RIGHT: History & Add Goal buttons
                        ToolbarItem(placement: .navigationBarTrailing) {
                            HStack {
                                Button(action: { showHistory = true }) {
                                    Image(systemName: "clock.arrow.circlepath")
                                }
                                
                                Button(action: { showAddGoal = true }) {
                                    Image(systemName: "plus")
                                    
                                    
                                }
                            }
                        }
                    }

                }
            }
        }
    }
}
