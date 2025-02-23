import SwiftUI

// MARK: - Coordinator

@MainActor
protocol Coordinator {
    func navigateToB()
    func navigateToC()
    func dismissCThenPresentD()
    func navigateToRoot()
    func pop()
}

// MARK: - Default Coordinator

final class DefaultCoordinator: RoutableCoordinator {
    enum Route: Hashable {
        case viewB
        case viewC
        case viewD
        case viewE
    }
    
    @Published
    var path: [Route] = []
    
    @Published
    var modal: ModalRoute<Route>?
    
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
            case .viewB:
                ViewB(coordinator: self)
            case .viewC:
                ViewC(coordinator: self)
            case .viewD:
                ViewD()
            case .viewE:
                ViewE(coordinator: self)
        }
    }
}

extension DefaultCoordinator: Coordinator {
    func pop() {
        path.popLast()
    }
    
    func navigateToB() {
        path.append(.viewB)
    }
    
    func navigateToC() {
        modal.presentSheet(.viewC)
    }
    
    func dismissCThenPresentD() {
        Task {
            modal.dismiss()
            
            // Wait for user action...
            try? await Task.sleep(for: .seconds(1))
            
            modal.presentFullScreen(.viewD)
            
            // Wait for user action...
            try? await Task.sleep(for: .seconds(2))
            
            modal.dismiss()
            
            path.append(.viewE)
        }
    }
    
    func navigateToRoot() {
        path.removeAll()
    }
}
