import SwiftUI

// MARK: - Navigation View

/// A generic `NavigationView` that handles navigation and modal presentations
/// using a coordinator pattern. It utilizes a `NavigationStack` for navigation and
/// supports both `fullScreenCover` and `sheet` modals.
struct NavigationView<
    Coordinator: RoutableCoordinator,
    Root: View
>: View {
    @StateObject
    private var coordinator: Coordinator
    @ViewBuilder
    private let root: () -> Root

    /// Initializes the `NavigationView` with a coordinator and a root view.
    ///
    /// - Parameters:
    ///   - coordinator: A `RoutableCoordinator` that manages the navigation flow.
    ///   - root: A closure that returns the root view of the navigation stack.
    init(
        coordinator: Coordinator,
        root: @escaping () -> Root
    ) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        self.root = root
    }

    var body: some View {
        NavigationStack(
            path: $coordinator.path,
            root: {
                root()
                    .navigationDestination(for: Coordinator.Route.self) { route in
                        coordinator.view(for: route)
                    }
                    .fullScreenCover(
                        item: Binding(
                            get: { coordinator.modal?.asFullScreen() },
                            set: { coordinator.modal = $0 }
                        ),
                        content: { modal in coordinator.view(for: modal.route) }
                    )
                    .sheet(
                        item: Binding(
                            get: { coordinator.modal?.asSheet() },
                            set: { coordinator.modal = $0 }
                        ),
                        content: { modal in coordinator.view(for: modal.route) }
                    )
            }
        )
    }
}
