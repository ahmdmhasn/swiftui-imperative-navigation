// MARK: - Coordinator Protocol

/// Defines navigation methods to transition between views.
@MainActor
protocol Coordinator {
    func navigateToB()
    func navigateToC()
    func navigateToRoot()
    func pop()
}

// MARK: - Default Coordinator

@MainActor
final class DefaultCoordinator {
    let navigationController = NavigationController()
}

extension DefaultCoordinator: Coordinator {
    func pop() {
        navigationController.pop()
    }
    
    
    /// Pushes `ViewB` onto the navigation stack.
    func navigateToB() {
        navigationController.push(ViewB(coordinator: self))
    }
    
    /// Presents `ViewC` in a modal sheet and handles dismissal logic.
    func navigateToC() {
        var coordinatorC: DefaultCoordinatorC?
        coordinatorC = DefaultCoordinatorC { [weak self] in
            self?.navigationController.dismiss()
            self?.presentDThenE()
            coordinatorC = nil
        }

        coordinatorC?.start(from: navigationController)
    }
    
    /// Pops back to the root view in the navigation stack.
    func navigateToRoot() {
        navigationController.popToRoot()
    }
    
    // MARK: - Private Methods
    
    /// Handles sequential navigation steps after `ViewC` is dismissed.
    private func presentDThenE() {
        Task {
            // Simulating delay to mimic user interaction or processing time.
            try? await Task.sleep(for: .seconds(1))
            
            navigationController.present(ViewD())
            
            try? await Task.sleep(for: .seconds(2))
            
            navigationController.dismiss()
            navigationController.push(ViewE(coordinator: self))
        }
    }
}
