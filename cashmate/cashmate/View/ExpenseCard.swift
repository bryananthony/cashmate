import SwiftUI

struct ExpenseCard: View {
    var expense: Expense
    @ObservedObject var viewModel: ExpenseViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(expense.desc)
                    .font(.headline)
                Spacer()
                Text(viewModel.formatCurrency(expense.amount))
                    .font(.subheadline)
            }
            
            Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundColor(.gray)
            
            if let photoData = expense.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}