import SwiftUI

// MARK: - RoutableCoordinator

/// A protocol defining a coordinator that manages the navigation flow in a SwiftUI app.
/// The coordinator is responsible for keeping track of the navigation path and
/// presenting views based on the current route.
@MainActor
protocol RoutableCoordinator: AnyObject, ObservableObject {
    associatedtype Route: Hashable
    associatedtype Content: View
    
    /// The current navigation path represented as an array of routes.
    var path: [Route] { get set }
    
    /// The currently active modal presentation, if any.
    var modal: ModalRoute<Route>? { get set }
    
    /// Provides the view for a given route.
    ///
    /// - Parameter route: The route to display.
    @ViewBuilder
    func view(for route: Route) -> Content
}
