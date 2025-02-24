// MARK: - Coordinator for ViewC

@MainActor
final class DefaultCoordinatorC: CoordinatorC {
    /// Initializes the coordinator with a callback for when it's stopped.
    init(onStop: @escaping () -> Void) {
        self.onStop = onStop
    }
    
    /// Starts the flow by presenting `ViewC` inside a navigation controller.
    func start(from navigationController: NavigationController) {
        navigationController.sheet(
            NavigationView(
                controller: self.navigationController,
                root: {
                    ViewC(coordinator: self)
                }
            )
        )
    }
    
    /// Dismisses `ViewC` and triggers the stop callback.
    func dismissCThenPresentD() {
        onStop()
    }

    private let navigationController = NavigationController()
    private let onStop: () -> Void
}
