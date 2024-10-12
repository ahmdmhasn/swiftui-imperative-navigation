import SwiftUI

struct ViewE: View {
    let coordinator: Coordinator

    var body: some View {
        Text("D")
            .font(.title)
        Button("Pop to root") {
            coordinator.navigateToRoot()
        }
    }
}
