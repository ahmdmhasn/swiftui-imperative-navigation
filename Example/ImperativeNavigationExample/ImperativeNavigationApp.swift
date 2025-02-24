import ImperativeNavigation
import SwiftUI

@main
struct SampleApp: App {
    private let coordinator = DefaultCoordinator()

    var body: some Scene {
        WindowGroup {
            NavigationView(
                controller: coordinator.navigationController,
                root: {
                    ViewA(viewModel: ViewModelA(coordinator: coordinator))
                }
            )
        }
    }
}
