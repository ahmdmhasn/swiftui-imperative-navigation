// MARK: - Modal Route

/// An enum that manages different modal presentation styles, such as `fullScreen` and `sheet`.
/// It conforms to `Hashable` and `Identifiable`, allowing it to be used in SwiftUI's `sheet`
/// and `fullScreenCover` presentations.
enum ModalRoute<Route: Hashable>: Hashable {
    case fullScreen(Route)
    case sheet(Route)

    /// Extracts the associated route from the modal presentation.
    var route: Route {
        switch self {
            case let .fullScreen(route):
                route
            case let .sheet(route):
                route
        }
    }

    /// Returns the `ModalRoute` as a `fullScreen` type if applicable, otherwise `nil`.
    func asFullScreen() -> Self? {
        switch self {
            case .fullScreen:
                self
            case .sheet:
                nil
        }
    }

    /// Returns the `ModalRoute` as a `sheet` type if applicable, otherwise `nil`.
    func asSheet() -> Self? {
        switch self {
            case .sheet:
                self
            case .fullScreen:
                nil
        }
    }
}

// MARK: - Identifiable Conformance

extension ModalRoute: Identifiable {
    var id: Int { hashValue }
}

// MARK: - Optional <> ModalRoute Accessories

extension Optional {
    /// Dismisses the current modal by setting the value to `nil`.
    mutating func dismiss<T: Hashable>() where Wrapped == ModalRoute<T> {
        self = nil
    }
    
    /// Presents a `fullScreen` modal with the given route.
    mutating func presentFullScreen<T: Hashable>(_ route: T) where Wrapped == ModalRoute<T> {
        self = .fullScreen(route)
    }
    
    /// Presents a `sheet` modal with the given route.
    mutating func presentSheet<T: Hashable>(_ route: T) where Wrapped == ModalRoute<T> {
        self = .sheet(route)
    }
}
