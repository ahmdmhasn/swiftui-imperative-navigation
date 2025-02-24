import SwiftUI

// MARK: - Navigation Controller

@MainActor
public final class NavigationController: ObservableObject {
    /// The current navigation path represented as an array of routes.
    @Published fileprivate var path: [Route] = []

    /// The currently active modal presentation, if any.
    @Published fileprivate var modal: ModalRoute<Route>?

    /// Pushes a new route onto the navigation path.
    func push<V: View>(_ view: V) {
        path.append(Route(view))
    }

    /// Removes the most recently pushed route from the navigation path.
    func pop() {
        _ = path.popLast()
    }

    /// Removes and returns the most recently pushed route from the navigation path.
    ///
    /// Note: Overloaded version of `pop()` which avoids "Generic parameter 'V' could not be inferred" error.
    func pop<V: View>() -> V? {
        path.popLast()?.view as? V
    }

    /// Removes all routes from the navigation path except for the root route.
    func popToRoot() {
        path.removeAll() // Path excludes the root view
    }

    /// Presents a modal route.
    func present<V: View>(_ view: V) {
        modal = .fullScreen(Route(view))
    }

    /// Presents a modal route.
    func sheet<V: View>(_ view: V) {
        modal = .sheet(Route(view))
    }

    /// Dismisses the currently presented modal route, if any.
    func dismiss() {
        modal = nil
    }
}

// MARK: - Navigation View

/// A generic `NavigationView` that handles navigation and modal presentations
/// using a coordinator pattern. It utilizes a `NavigationStack` for navigation and
/// supports both `fullScreenCover` and `sheet` modals.
struct NavigationView<Root: View>: View {
    @StateObject
    private var controller: NavigationController
    private let root: Root

    /// Initializes the `NavigationView` with a coordinator and a root view.
    ///
    /// - Parameters:
    ///   - controller: A `NavigationController` that manages the navigation flow.
    ///   - root: A closure that returns the root view of the navigation stack.
    init(
        controller: NavigationController,
        @ViewBuilder root: () -> Root
    ) {
        self._controller = StateObject(wrappedValue: controller)
        self.root = root()
    }

    var body: some View {
        NavigationStack(
            path: $controller.path,
            root: {
                root
                    .navigationDestination(for: Route.self, destination: \.body)
                    .fullScreenCover(
                        item: Binding(
                            get: { controller.modal?.asFullScreen() },
                            set: { controller.modal = $0 }
                        ),
                        content: \.route.body
                    )
                    .sheet(
                        item: Binding(
                            get: { controller.modal?.asSheet() },
                            set: { controller.modal = $0 }
                        ),
                        content: \.route.body
                    )
            }
        )
    }
}

// MARK: - Route

private struct Route: View {
    @MainActor
    var body: some View {
        AnyView(erasing: view)
    }

    init<V: View>(_ view: V) {
        self.view = view
        self.viewType = String(describing: V.self)
        self.identifier = UUID()
    }

    let view: any View
    let viewType: String
    let identifier: UUID
}

// MARK: Route + Hashable Conformance

extension Route: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(viewType)
        hasher.combine(identifier)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.viewType == rhs.viewType && lhs.identifier == rhs.identifier
    }
}

// MARK: Route + Hashable Conformance

extension Route: Identifiable {
    var id: Int { hashValue }
}
