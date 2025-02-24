import SwiftUI

// MARK: - ViewModelA

@MainActor
final class ViewModelA: ObservableObject {
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func buttonTapped() {
        coordinator.navigateToB()
    }
    
    private let coordinator: Coordinator
}

// MARK: - ViewA

struct ViewA: View {
    @StateObject
    var viewModel: ViewModelA
    
    var body: some View {
        Text("A")
            .font(.title)
        Button("Navigate to B") {
            viewModel.buttonTapped()
        }
    }
}
