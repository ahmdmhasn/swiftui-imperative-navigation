import SwiftUI

@main
struct SampleApp: App {
    private let coordinator = DefaultCoordinator()

    var body: some Scene {
        WindowGroup {
            NavigationView(
                coordinator: coordinator,
                root: { ViewA(coordinator: coordinator) }
            )
        }
    }
}
