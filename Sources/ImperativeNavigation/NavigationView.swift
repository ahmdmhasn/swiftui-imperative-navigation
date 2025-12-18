import SwiftUI

// MARK: - Navigation Controller

@MainActor
public final class NavigationController: ObservableObject {
    public init() { }

    /// Pushes a new route onto the navigation path.
    public func push<V: View>(_ view: V) {
        path.append(Route(view))
    }

    /// Removes the most recently pushed route from the navigation path.
    public func pop() {
        _ = path.popLast()
    }

    /// Removes and returns the most recently pushed route from the navigation path.
    ///
    /// Note: Overloaded version of `pop()` which avoids "Generic parameter 'V' could not be inferred" error.
    public func pop<V: View>() -> V? {
        path.popLast()?.body as? V
    }

    /// Removes all routes from the navigation path except for the root route.
    public func popToRoot() {
        path.removeAll() // Path excludes the root view
    }

    /// Presents a modal route.
    public func present<V: View>(_ view: V) {
        fullScreenRoute = Route(view)
        sheetRoute = nil
    }

    /// Presents a modal route.
    public func sheet<V: View>(_ view: V) {
        fullScreenRoute = nil
        sheetRoute = Route(view)
    }

    /// Dismisses the currently presented modal route, if any.
    public func dismiss() {
        fullScreenRoute = nil
        sheetRoute = nil
    }

    /// The currently active modal presentation, if any.
    /// Returns a `Route` wrapper around the active modal (either full screen or sheet).
    public var modal: Route? { fullScreenRoute ?? sheetRoute }

    /// The current navigation path represented as an array of routes.
    @Published fileprivate(set) var path: [Route] = []

    /// The currently active full screen modal route, if any.
    @Published fileprivate(set) var fullScreenRoute: Route?

    /// The currently active sheet modal route, if any.
    @Published fileprivate(set) var sheetRoute: Route?
}

// MARK: - Navigation View

/// A generic `NavigationView` that handles navigation and modal presentations
/// using a coordinator pattern. It utilizes a `NavigationStack` for navigation and
/// supports both `fullScreenCover` and `sheet` modals.
public struct NavigationView<Root: View>: View {
    @ObservedObject
    private var controller: NavigationController
    private let root: Root

    /// Initializes the `NavigationView` with a coordinator and a root view.
    ///
    /// - Parameters:
    ///   - controller: A `NavigationController` that manages the navigation flow.
    ///   - root: A closure that returns the root view of the navigation stack.
    public init(
        controller: NavigationController,
        @ViewBuilder root: () -> Root
    ) {
        self._controller = ObservedObject(wrappedValue: controller)
        self.root = root()
    }

    public var body: some View {
        NavigationStack(
            path: $controller.path,
            root: {
                root
                    .navigationDestination(
                        for: Route.self,
                        destination: { AnyView($0.body) }
                    )
                    .fullScreenCover(
                        item: $controller.fullScreenRoute,
                        content: { AnyView($0.body) }
                    )
                    .sheet(
                        item: $controller.sheetRoute,
                        content: { AnyView($0.body) }
                    )
            }
        )
    }
}

// MARK: - Route

public struct Route {
    init<Content: View>(_ body: Content) {
        self.body = body // Store same view for later casting.
        self.viewType = String(describing: Content.self) // Keep the view name for reference.
        self.identifier = UUID() // Each route should be unique.
    }

    public let body: any View
    private let viewType: String
    private let identifier: UUID
}

// MARK: Route + Hashable Conformance

extension Route: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(viewType)
        hasher.combine(identifier)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.viewType == rhs.viewType && lhs.identifier == rhs.identifier
    }
}

// MARK: Route + Hashable Conformance

extension Route: Identifiable {
    public var id: Int { hashValue }
}
