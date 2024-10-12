// MARK: - Modal Route

enum ModalRoute<Route: Hashable>: Hashable, Identifiable {
    var id: Int { hashValue }
    
    case fullScreen(Route)
    case sheet(Route)
    
    var route: Route {
        switch self {
            case let .fullScreen(route):
                route
            case let .sheet(route):
                route
        }
    }
    
    func asFullScreen() -> Self? {
        switch self {
            case .fullScreen:
                self
            case .sheet:
                nil
        }
    }
    
    func asSheet() -> Self? {
        switch self {
            case .sheet:
                self
            case .fullScreen:
                nil
        }
    }
}

extension Optional {
    mutating func dismiss<T: Hashable>() where Wrapped == ModalRoute<T> {
        self = nil
    }
    
    mutating func presentFullScreen<T: Hashable>(_ route: T) where Wrapped == ModalRoute<T> {
        self = .fullScreen(route)
    }
    
    mutating func presentSheet<T: Hashable>(_ route: T) where Wrapped == ModalRoute<T> {
        self = .sheet(route)
    }
}
