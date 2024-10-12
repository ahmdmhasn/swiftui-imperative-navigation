import SwiftUI

// MARK: - RoutableCoordinator

@MainActor
protocol RoutableCoordinator: AnyObject, ObservableObject {
    associatedtype Route: Hashable
    associatedtype Content: View
    
    var path: [Route] { get set }
    var modal: ModalRoute<Route>? { get set }
    
    @ViewBuilder
    func view(for route: Route) -> Content
}
