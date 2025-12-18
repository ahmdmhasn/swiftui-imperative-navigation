import Testing
import SwiftUI
@testable import ImperativeNavigation

/// Integration tests for complete navigation flows.
/// These tests verify end-to-end navigation scenarios that combine multiple operations.
@MainActor
@Suite("Navigation Flow Integration Tests")
struct NavigationFlowIntegrationTests {

    // MARK: - Push Navigation Flows

    @Test("Push multiple views and pop back to root")
    func pushMultipleViewsAndPopToRoot() async throws {
        // Given
        let controller = NavigationController()
        #expect(controller.path.isEmpty)

        // When: Push multiple views
        controller.push(TestView(id: "View1"))
        controller.push(TestView(id: "View2"))
        controller.push(TestView(id: "View3"))

        // Then: Verify stack has 3 views
        #expect(controller.path.count == 3)

        // When: Pop to root
        controller.popToRoot()

        // Then: Verify stack is empty
        #expect(controller.path.isEmpty)
    }

    @Test("Push, pop, then push again")
    func pushPopPushSequence() async throws {
        // Given
        let controller = NavigationController()

        // When: Push view A
        controller.push(TestView(id: "ViewA"))
        #expect(controller.path.count == 1)

        // When: Pop
        controller.pop()
        #expect(controller.path.isEmpty)

        // When: Push view B
        controller.push(TestView(id: "ViewB"))

        // Then: Should have 1 view in stack
        #expect(controller.path.count == 1)
    }

    // MARK: - Modal Navigation Flows

    @Test("Present sheet, then dismiss")
    func presentSheetAndDismiss() async throws {
        // Given
        let controller = NavigationController()

        // When: Present sheet
        controller.sheet(TestView(id: "SheetView"))

        // Then: Sheet should be presented
        #expect(controller.sheetRoute != nil)
        #expect(controller.fullScreenRoute == nil)
        #expect(controller.modal != nil)

        // When: Dismiss
        controller.dismiss()

        // Then: No modal should be presented
        #expect(controller.sheetRoute == nil)
        #expect(controller.fullScreenRoute == nil)
        #expect(controller.modal == nil)
    }

    @Test("Present full screen cover, then dismiss")
    func presentFullScreenAndDismiss() async throws {
        // Given
        let controller = NavigationController()

        // When: Present full screen
        controller.present(TestView(id: "FullScreenView"))

        // Then: Full screen should be presented
        #expect(controller.fullScreenRoute != nil)
        #expect(controller.sheetRoute == nil)
        #expect(controller.modal != nil)

        // When: Dismiss
        controller.dismiss()

        // Then: No modal should be presented
        #expect(controller.fullScreenRoute == nil)
        #expect(controller.sheetRoute == nil)
        #expect(controller.modal == nil)
    }

    @Test("Switch between sheet and full screen")
    func switchBetweenModalTypes() async throws {
        // Given
        let controller = NavigationController()

        // When: Present sheet
        controller.sheet(TestView(id: "Sheet1"))
        #expect(controller.sheetRoute != nil)
        #expect(controller.fullScreenRoute == nil)

        // When: Present full screen (should replace sheet)
        controller.present(TestView(id: "FullScreen1"))

        // Then: Full screen should replace sheet
        #expect(controller.fullScreenRoute != nil)
        #expect(controller.sheetRoute == nil)

        // When: Present sheet (should replace full screen)
        controller.sheet(TestView(id: "Sheet2"))

        // Then: Sheet should replace full screen
        #expect(controller.sheetRoute != nil)
        #expect(controller.fullScreenRoute == nil)
    }

    // MARK: - Complex Navigation Flows

    @Test("E-commerce flow: Browse → Detail → Add to Cart → Checkout → Confirmation")
    func ecommerceNavigationFlow() async throws {
        // Given: Fresh navigation controller
        let controller = NavigationController()

        // When: User browses product catalog (root)
        #expect(controller.path.isEmpty)

        // When: User taps product to see details
        controller.push(TestView(id: "ProductDetail"))
        #expect(controller.path.count == 1)

        // When: User opens cart (sheet modal)
        controller.sheet(TestView(id: "ShoppingCart"))
        #expect(controller.sheetRoute != nil)
        #expect(controller.path.count == 1) // Path unchanged

        // When: User proceeds to checkout (dismiss sheet, push checkout)
        controller.dismiss()
        controller.push(TestView(id: "Checkout"))

        // Then: Should have 2 views in stack, no modal
        #expect(controller.path.count == 2)
        #expect(controller.modal == nil)

        // When: User completes order (show confirmation as full screen)
        controller.present(TestView(id: "OrderConfirmation"))

        // Then: Should show full screen modal
        #expect(controller.fullScreenRoute != nil)
        #expect(controller.path.count == 2) // Path unchanged

        // When: User continues shopping (dismiss modal, pop to root)
        controller.dismiss()
        controller.popToRoot()

        // Then: Should be back at root
        #expect(controller.path.isEmpty)
        #expect(controller.modal == nil)
    }

    @Test("Settings flow: Open settings → Change preferences → Save confirmation")
    func settingsNavigationFlow() async throws {
        // Given
        let controller = NavigationController()

        // When: User opens settings as sheet
        controller.sheet(TestView(id: "Settings"))
        #expect(controller.sheetRoute != nil)

        // When: User navigates to sub-setting (push in sheet context)
        // Note: In real app, this would be in a separate navigation stack within the sheet
        controller.dismiss()
        controller.push(TestView(id: "SettingsDetail"))

        // When: User saves and sees confirmation modal
        controller.present(TestView(id: "SaveConfirmation"))

        // Then: Should show confirmation
        #expect(controller.fullScreenRoute != nil)

        // When: Dismiss confirmation and go back
        controller.dismiss()
        controller.pop()

        // Then: Back to root
        #expect(controller.path.isEmpty)
        #expect(controller.modal == nil)
    }

    @Test("Deep linking flow: Jump to specific screen")
    func deepLinkingFlow() async throws {
        // Given: Fresh controller
        let controller = NavigationController()

        // When: Deep link requires pushing multiple views
        controller.push(TestView(id: "Category"))
        controller.push(TestView(id: "ProductList"))
        controller.push(TestView(id: "ProductDetail"))

        // Then: Should have 3 views in stack
        #expect(controller.path.count == 3)

        // When: User navigates back to root
        controller.popToRoot()

        // Then: Stack should be clear
        #expect(controller.path.isEmpty)
    }

    // MARK: - Edge Cases

    @Test("Pop when stack is empty does not crash")
    func popEmptyStack() async throws {
        // Given
        let controller = NavigationController()
        #expect(controller.path.isEmpty)

        // When: Attempt to pop empty stack
        controller.pop()

        // Then: Should handle gracefully
        #expect(controller.path.isEmpty)
    }

    @Test("Dismiss when no modal is presented")
    func dismissWithoutModal() async throws {
        // Given
        let controller = NavigationController()
        #expect(controller.modal == nil)

        // When: Attempt to dismiss
        controller.dismiss()

        // Then: Should handle gracefully
        #expect(controller.modal == nil)
    }

    @Test("Multiple push operations maintain order")
    func multiplePushMaintainsOrder() async throws {
        // Given
        let controller = NavigationController()
        let views = (1...10).map { TestView(id: "View\($0)") }

        // When: Push 10 views
        views.forEach { controller.push($0) }

        // Then: Stack should have 10 views
        #expect(controller.path.count == 10)

        // When: Pop 5 views
        (0..<5).forEach { _ in controller.pop() }

        // Then: Stack should have 5 views
        #expect(controller.path.count == 5)
    }

    // MARK: - State Consistency Tests

    @Test("Modal property reflects sheet state correctly")
    func modalPropertyReflectsSheetState() async throws {
        // Given
        let controller = NavigationController()

        // When: Present sheet
        controller.sheet(TestView(id: "Sheet"))

        // Then: modal property should not be nil
        #expect(controller.modal != nil)
        #expect(controller.sheetRoute != nil)
        #expect(controller.fullScreenRoute == nil)
    }

    @Test("Modal property reflects full screen state correctly")
    func modalPropertyReflectsFullScreenState() async throws {
        // Given
        let controller = NavigationController()

        // When: Present full screen
        controller.present(TestView(id: "FullScreen"))

        // Then: modal property should not be nil
        #expect(controller.modal != nil)
        #expect(controller.fullScreenRoute != nil)
        #expect(controller.sheetRoute == nil)
    }

    @Test("Modal property is nil when no modal presented")
    func modalPropertyNilWhenNoModal() async throws {
        // Given
        let controller = NavigationController()

        // When: No modal presented
        // Then: modal property should be nil
        #expect(controller.modal == nil)
        #expect(controller.sheetRoute == nil)
        #expect(controller.fullScreenRoute == nil)
    }
}

// MARK: - Test Helpers

private struct TestView: View {
    let id: String

    var body: some View {
        Text(id)
    }
}
