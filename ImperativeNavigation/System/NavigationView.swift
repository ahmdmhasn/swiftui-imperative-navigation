import SwiftUI

// MARK: - Navigation View

struct NavigationView<
    Coordinator: RoutableCoordinator,
    Root: View
>: View {
    @StateObject
    private var coordinator: Coordinator
    @ViewBuilder
    private let root: () -> Root

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
