import SwiftUI

struct ViewA: View {
    let coordinator: Coordinator
    
    var body: some View {
        Text("A")
            .font(.title)
        Button("Navigate to B") {
            coordinator.navigateToB()
        }
    }
}
