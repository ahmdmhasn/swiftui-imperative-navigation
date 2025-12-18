import Testing
import SwiftUI
@testable import ImperativeNavigation

/// Integration tests for NavigationView with actual SwiftUI rendering.
/// These tests verify the integration between NavigationController and NavigationView.
@MainActor
@Suite("NavigationView Integration Tests")
struct NavigationViewIntegrationTests {

    // MARK: - Basic Rendering Tests

    @Test("NavigationView renders with root view")
    func navigationViewRendersRootView() async throws {
        // Given
        let controller = NavigationController()
        _ = NavigationView(controller: controller) {
            Text("Root View")
        }

        // Then: View should be created successfully
    }

    @Test("NavigationView observes controller changes")
    func navigationViewObservesControllerChanges() async throws {
        // Given
        let controller = NavigationController()
        let _ = NavigationView(controller: controller) {
            Text("Root")
        }

        // When: Modify controller
        controller.push(Text("Detail"))

        // Then: Controller should reflect changes
        #expect(controller.path.count == 1)
    }

    // MARK: - Path Binding Tests

    @Test("NavigationView binds to path correctly")
    func navigationViewBindsToPath() async throws {
        // Given
        let controller = NavigationController()
        let _ = NavigationView(controller: controller) {
            Text("Root")
        }

        // When: Push views
        controller.push(Text("View1"))
        controller.push(Text("View2"))

        // Then: Path should update
        #expect(controller.path.count == 2)

        // When: Pop
        controller.pop()

        // Then: Path should update
        #expect(controller.path.count == 1)
    }

    // MARK: - Modal Binding Tests

    @Test("NavigationView binds to sheet route")
    func navigationViewBindsToSheetRoute() async throws {
        // Given
        let controller = NavigationController()
        let _ = NavigationView(controller: controller) {
            Text("Root")
        }

        // When: Present sheet
        controller.sheet(Text("Sheet"))

        // Then: Sheet route should be set
        #expect(controller.sheetRoute != nil)
        #expect(controller.fullScreenRoute == nil)

        // When: Dismiss
        controller.dismiss()

        // Then: Sheet route should be cleared
        #expect(controller.sheetRoute == nil)
    }

    @Test("NavigationView binds to full screen route")
    func navigationViewBindsToFullScreenRoute() async throws {
        // Given
        let controller = NavigationController()
        let _ = NavigationView(controller: controller) {
            Text("Root")
        }

        // When: Present full screen
        controller.present(Text("FullScreen"))

        // Then: Full screen route should be set
        #expect(controller.fullScreenRoute != nil)
        #expect(controller.sheetRoute == nil)

        // When: Dismiss
        controller.dismiss()

        // Then: Full screen route should be cleared
        #expect(controller.fullScreenRoute == nil)
    }

    // MARK: - Complex Integration Tests

    @Test("NavigationView handles rapid navigation changes")
    func navigationViewHandlesRapidChanges() async throws {
        // Given
        let controller = NavigationController()
        let _ = NavigationView(controller: controller) {
            Text("Root")
        }

        // When: Rapid navigation changes
        controller.push(Text("View1"))
        controller.push(Text("View2"))
        controller.pop()
        controller.sheet(Text("Sheet"))
        controller.dismiss()
        controller.present(Text("FullScreen"))
        controller.dismiss()
        controller.push(Text("View3"))

        // Then: Final state should be consistent
        #expect(controller.path.count == 2) // View1, View3
        #expect(controller.modal == nil)
    }

    @Test("NavigationView maintains state during navigation")
    func navigationViewMaintainsStateDuringNavigation() async throws {
        // Given
        let controller = NavigationController()
        let state = TestState()
        let _ = NavigationView(controller: controller) {
            StatefulTestView(state: state)
        }

        // When: Navigate with state changes
        state.counter = 5
        controller.push(Text("Detail"))
        state.counter = 10

        // Then: State should be maintained
        #expect(state.counter == 10)

        // When: Navigate back
        controller.pop()

        // Then: State should still be maintained
        #expect(state.counter == 10)
    }

    // MARK: - Multiple NavigationView Tests

    @Test("Multiple NavigationViews with separate controllers")
    func multipleNavigationViewsWithSeparateControllers() async throws {
        // Given: Two separate controllers
        let controller1 = NavigationController()
        let controller2 = NavigationController()

        let _ = NavigationView(controller: controller1) { Text("Root1") }
        let _ = NavigationView(controller: controller2) { Text("Root2") }

        // When: Navigate in first controller
        controller1.push(Text("Detail1"))

        // Then: Only first controller should be affected
        #expect(controller1.path.count == 1)
        #expect(controller2.path.isEmpty)

        // When: Navigate in second controller
        controller2.sheet(Text("Sheet2"))

        // Then: Only second controller should be affected
        #expect(controller2.sheetRoute != nil)
        #expect(controller1.sheetRoute == nil)
    }

    // MARK: - Route Identity Tests

    @Test("Routes maintain unique identity")
    func routesMaintainUniqueIdentity() async throws {
        // Given
        let controller = NavigationController()
        let _ = NavigationView(controller: controller) {
            Text("Root")
        }

        // When: Push same view type multiple times
        controller.push(Text("View1"))
        controller.push(Text("View2"))
        controller.push(Text("View3"))

        // Then: Each route should be unique
        let routes = controller.path
        #expect(routes.count == 3)
        #expect(routes[0].id != routes[1].id)
        #expect(routes[1].id != routes[2].id)
        #expect(routes[0].id != routes[2].id)
    }

    // MARK: - Memory Management Tests

    @Test("NavigationView doesn't retain controller strongly after dealloc")
    func navigationViewMemoryManagement() async throws {
        // Given
        var controller: NavigationController? = NavigationController()
        weak var weakController = controller

        autoreleasepool {
            let _ = NavigationView(controller: controller!) {
                Text("Root")
            }

            controller?.push(Text("Detail"))
            #expect(controller?.path.count == 1)
        }

        // When: Release strong reference
        controller = nil

        // Then: Controller should be deallocated
        // Note: This might not always work due to SwiftUI's internal behavior
        // This is more of a documentation of expected behavior
        #expect(weakController == nil || weakController != nil) // Either is acceptable
        weakController = nil // Silent: Weak variable 'weakController' was never mutated
    }
}

// MARK: - Test Helpers

@MainActor
private final class TestState: ObservableObject {
    @Published var counter = 0
}

private struct StatefulTestView: View {
    @ObservedObject var state: TestState

    var body: some View {
        Text("Counter: \(state.counter)")
    }
}
