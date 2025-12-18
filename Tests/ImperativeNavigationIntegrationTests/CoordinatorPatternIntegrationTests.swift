import Testing
import SwiftUI
@testable import ImperativeNavigation

/// Integration tests for coordinator pattern usage.
/// These tests verify that coordinators can manage navigation flows correctly.
@MainActor
@Suite("Coordinator Pattern Integration Tests")
struct CoordinatorPatternIntegrationTests {

    // MARK: - Basic Coordinator Tests

    @Test("Coordinator can push views")
    func coordinatorPushesViews() async throws {
        // Given
        let coordinator = TestCoordinator()

        // When
        coordinator.navigateToDetail()

        // Then
        #expect(coordinator.navigationController.path.count == 1)
    }

    @Test("Coordinator can present modals")
    func coordinatorPresentsModals() async throws {
        // Given
        let coordinator = TestCoordinator()

        // When
        coordinator.showSettings()

        // Then
        #expect(coordinator.navigationController.sheetRoute != nil)
    }

    @Test("Coordinator can handle complex flows")
    func coordinatorHandlesComplexFlows() async throws {
        // Given
        let coordinator = TestCoordinator()

        // When: Execute multi-step flow
        coordinator.navigateToDetail()
        coordinator.showSettings()
        coordinator.navigationController.dismiss()
        coordinator.navigateToDetail()

        // Then
        #expect(coordinator.navigationController.path.count == 2)
        #expect(coordinator.navigationController.modal == nil)
    }

    // MARK: - Child Coordinator Tests

    @Test("Parent coordinator can present child coordinator")
    func parentCoordinatorPresentsChild() async throws {
        // Given
        let parentCoordinator = TestCoordinator()

        // When: Present child flow
        parentCoordinator.presentChildFlow()

        // Then: Child coordinator's view should be presented
        #expect(parentCoordinator.navigationController.sheetRoute != nil)
    }

    @Test("Child coordinator can dismiss itself")
    func childCoordinatorDismisses() async throws {
        // Given
        let parentCoordinator = TestCoordinator()
        parentCoordinator.presentChildFlow()
        #expect(parentCoordinator.navigationController.sheetRoute != nil)

        // When: Child dismisses
        parentCoordinator.dismissChildFlow()

        // Then: Modal should be dismissed
        #expect(parentCoordinator.navigationController.modal == nil)
    }

    // MARK: - State Management Tests

    @Test("Coordinator maintains shared state across navigation")
    func coordinatorMaintainsSharedState() async throws {
        // Given
        let coordinator = TestCoordinatorWithState()
        #expect(coordinator.sharedState.items.isEmpty)

        // When: Add item and navigate
        coordinator.addItem("Item1")
        coordinator.navigateToDetail()
        coordinator.addItem("Item2")

        // Then: State should be maintained
        #expect(coordinator.sharedState.items.count == 2)
        #expect(coordinator.sharedState.items.contains("Item1"))
        #expect(coordinator.sharedState.items.contains("Item2"))
    }

    @Test("Shared state persists across modal presentations")
    func sharedStatePersistsAcrossModals() async throws {
        // Given
        let coordinator = TestCoordinatorWithState()

        // When: Add items and show modal
        coordinator.addItem("Item1")
        coordinator.showSettings()
        coordinator.addItem("Item2")

        // Then: State should include both items
        #expect(coordinator.sharedState.items.count == 2)

        // When: Dismiss modal
        coordinator.navigationController.dismiss()

        // Then: State should still be there
        #expect(coordinator.sharedState.items.count == 2)
    }

    // MARK: - Testability Tests

    @Test("Mock coordinator can track navigation calls")
    func mockCoordinatorTracksNavigation() async throws {
        // Given
        let mockCoordinator = MockTestCoordinator()

        // When: Navigate
        mockCoordinator.navigateToDetail()
        mockCoordinator.showSettings()
        mockCoordinator.navigateToDetail()

        // Then: Mock should track calls
        #expect(mockCoordinator.detailNavigationCount == 2)
        #expect(mockCoordinator.settingsNavigationCount == 1)
    }

    @Test("Coordinator can be dependency injected")
    func coordinatorDependencyInjection() async throws {
        // Given: Create coordinator with injected dependencies
        let sharedState = SharedState()
        let coordinator = TestCoordinatorWithState(sharedState: sharedState)

        // When: Use coordinator
        coordinator.addItem("TestItem")

        // Then: Injected dependency should be updated
        #expect(sharedState.items.contains("TestItem"))
    }

    // MARK: - Navigation Callback Tests

    @Test("Coordinator can handle navigation completion callbacks")
    func coordinatorHandlesCallbacks() async throws {
        // Given
        let coordinator = TestCoordinatorWithCallbacks()
        var callbackInvoked = false

        // When: Navigate with callback
        coordinator.navigateWithCallback {
            callbackInvoked = true
        }

        // Then: Callback should be stored
        #expect(coordinator.pendingCallback != nil)

        // When: Trigger callback
        coordinator.triggerCallback()

        // Then: Callback should be invoked
        #expect(callbackInvoked)
    }

    // MARK: - Protocol-Based Coordinator Tests

    @Test("Protocol-based coordinator abstraction works")
    func protocolBasedCoordinatorWorks() async throws {
        // Given: Coordinator conforming to protocol
        let coordinator: AppCoordinatorProtocol = TestCoordinator()

        // When: Use protocol methods
        coordinator.navigateToDetail()
        coordinator.showSettings()

        // Then: Should work through protocol
        #expect(coordinator.navigationController.path.count == 1)
        #expect(coordinator.navigationController.sheetRoute != nil)
    }
}

// MARK: - Test Coordinators

@MainActor
protocol AppCoordinatorProtocol {
    var navigationController: NavigationController { get }
    func navigateToDetail()
    func showSettings()
}

@MainActor
final class TestCoordinator: AppCoordinatorProtocol {
    let navigationController = NavigationController()

    func navigateToDetail() {
        navigationController.push(DetailView())
    }

    func showSettings() {
        navigationController.sheet(SettingsView())
    }

    func presentChildFlow() {
        navigationController.sheet(ChildFlowView())
    }

    func dismissChildFlow() {
        navigationController.dismiss()
    }
}

@MainActor
final class TestCoordinatorWithState {
    let navigationController = NavigationController()
    let sharedState: SharedState

    init(sharedState: SharedState = SharedState()) {
        self.sharedState = sharedState
    }

    func navigateToDetail() {
        navigationController.push(DetailView())
    }

    func showSettings() {
        navigationController.sheet(SettingsView())
    }

    func addItem(_ item: String) {
        sharedState.items.append(item)
    }
}

@MainActor
final class MockTestCoordinator: AppCoordinatorProtocol {
    let navigationController = NavigationController()
    private(set) var detailNavigationCount = 0
    private(set) var settingsNavigationCount = 0

    func navigateToDetail() {
        detailNavigationCount += 1
        navigationController.push(DetailView())
    }

    func showSettings() {
        settingsNavigationCount += 1
        navigationController.sheet(SettingsView())
    }
}

@MainActor
final class TestCoordinatorWithCallbacks {
    let navigationController = NavigationController()
    var pendingCallback: (() -> Void)?

    func navigateWithCallback(completion: @escaping () -> Void) {
        pendingCallback = completion
        navigationController.push(DetailView())
    }

    func triggerCallback() {
        pendingCallback?()
        pendingCallback = nil
    }
}

// MARK: - Test State

@MainActor
final class SharedState: ObservableObject {
    @Published var items: [String] = []
}

// MARK: - Test Views

private struct DetailView: View {
    var body: some View {
        Text("Detail View")
    }
}

private struct SettingsView: View {
    var body: some View {
        Text("Settings View")
    }
}

private struct ChildFlowView: View {
    var body: some View {
        Text("Child Flow View")
    }
}
