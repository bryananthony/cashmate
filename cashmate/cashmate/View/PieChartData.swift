import SwiftUI

struct PieChartData: Identifiable {
    let id = UUID()
    let value: Double
    let color: Color
    let label: String
}

struct PieChartView: View {
    var data: [PieChartData]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    let startAngle = angle(for: index)
                    let endAngle = angle(for: index + 1)
                    
                    Path { path in
                        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        let radius = min(geometry.size.width, geometry.size.height) / 2
                        path.move(to: center)
                        path.addArc(
                            center: center,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: false
                        )
                    }
                    .fill(item.color)
                }
            }
        }
    }
    
    private func angle(for index: Int) -> Angle {
        let total = data.reduce(0) { $0 + $1.value }
        let sum = data.prefix(index).reduce(0) { $0 + $1.value }
        return .degrees(sum / total * 360 - 90)
    }
}