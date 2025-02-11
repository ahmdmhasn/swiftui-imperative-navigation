import SwiftUI

// MARK: - ViewB

struct ViewB: View {
    let coordinator: Coordinator
    
    var body: some View {
        Text("B")
            .font(.title)
        Button("Navigate to C") {
            coordinator.navigateToC()
        }
        Button("Pop to A") {
            coordinator.popLast()
        }
    }
}
