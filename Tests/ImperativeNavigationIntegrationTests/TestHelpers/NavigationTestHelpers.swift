import Foundation
import SwiftUI
@testable import ImperativeNavigation

// MARK: - Navigation Test Assertions

@MainActor
extension NavigationController {
    /// Assert that the navigation stack has the expected count
    func assertStackCount(_ expected: Int, file: StaticString = #file, line: UInt = #line) {
        assert(path.count == expected, "Expected stack count \(expected), got \(path.count)", file: file, line: line)
    }

    /// Assert that a modal is currently presented
    func assertModalPresented(file: StaticString = #file, line: UInt = #line) {
        assert(modal != nil, "Expected modal to be presented", file: file, line: line)
    }

    /// Assert that no modal is currently presented
    func assertNoModalPresented(file: StaticString = #file, line: UInt = #line) {
        assert(modal == nil, "Expected no modal to be presented", file: file, line: line)
    }

    /// Assert that a sheet is currently presented
    func assertSheetPresented(file: StaticString = #file, line: UInt = #line) {
        assert(sheetRoute != nil, "Expected sheet to be presented", file: file, line: line)
        assert(fullScreenRoute == nil, "Expected no full screen route", file: file, line: line)
    }

    /// Assert that a full screen cover is currently presented
    func assertFullScreenPresented(file: StaticString = #file, line: UInt = #line) {
        assert(fullScreenRoute != nil, "Expected full screen to be presented", file: file, line: line)
        assert(sheetRoute == nil, "Expected no sheet route", file: file, line: line)
    }

    /// Assert that the navigation state is clean (no stack, no modals)
    func assertCleanState(file: StaticString = #file, line: UInt = #line) {
        assert(path.isEmpty, "Expected empty navigation stack", file: file, line: line)
        assert(modal == nil, "Expected no modal presented", file: file, line: line)
    }
}

// MARK: - Navigation Flow Builder

@MainActor
struct NavigationFlowBuilder {
    let controller: NavigationController

    init(controller: NavigationController = NavigationController()) {
        self.controller = controller
    }

    @discardableResult
    func push(_ view: some View) -> Self {
        controller.push(view)
        return self
    }

    @discardableResult
    func pop() -> Self {
        controller.pop()
        return self
    }

    @discardableResult
    func popToRoot() -> Self {
        controller.popToRoot()
        return self
    }

    @discardableResult
    func sheet(_ view: some View) -> Self {
        controller.sheet(view)
        return self
    }

    @discardableResult
    func present(_ view: some View) -> Self {
        controller.present(view)
        return self
    }

    @discardableResult
    func dismiss() -> Self {
        controller.dismiss()
        return self
    }

    func build() -> NavigationController {
        controller
    }
}

// MARK: - Test View Factories

enum TestViewFactory {
    @MainActor
    static func makeSimpleView(id: String) -> some View {
        Text(id)
    }

    @MainActor
    static func makeDetailView(title: String, subtitle: String? = nil) -> some View {
        VStack {
            Text(title).font(.title)
            if let subtitle {
                Text(subtitle).font(.caption)
            }
        }
    }

    @MainActor
    static func makeListView(items: [String]) -> some View {
        List(items, id: \.self) { item in
            Text(item)
        }
    }

    @MainActor
    static func makeFormView(fields: [String]) -> some View {
        Form {
            ForEach(fields, id: \.self) { field in
                TextField(field, text: .constant(""))
            }
        }
    }
}

// MARK: - Mock Coordinators

@MainActor
final class SpyCoordinator {
    let navigationController: NavigationController
    private(set) var navigationHistory: [NavigationEvent] = []

    init(navigationController: NavigationController = NavigationController()) {
        self.navigationController = navigationController
    }

    enum NavigationEvent: Equatable {
        case pushedView(String)
        case popped
        case poppedToRoot
        case presentedSheet(String)
        case presentedFullScreen(String)
        case dismissed
    }

    func push(_ viewId: String) {
        navigationHistory.append(.pushedView(viewId))
        navigationController.push(Text(viewId))
    }

    func pop() {
        navigationHistory.append(.popped)
        navigationController.pop()
    }

    func popToRoot() {
        navigationHistory.append(.poppedToRoot)
        navigationController.popToRoot()
    }

    func sheet(_ viewId: String) {
        navigationHistory.append(.presentedSheet(viewId))
        navigationController.sheet(Text(viewId))
    }

    func present(_ viewId: String) {
        navigationHistory.append(.presentedFullScreen(viewId))
        navigationController.present(Text(viewId))
    }

    func dismiss() {
        navigationHistory.append(.dismissed)
        navigationController.dismiss()
    }

    func clearHistory() {
        navigationHistory.removeAll()
    }
}

// MARK: - Navigation State Snapshots

@MainActor
struct NavigationStateSnapshot {
    let stackCount: Int
    let hasModal: Bool
    let modalType: ModalType?

    enum ModalType {
        case sheet
        case fullScreen
    }

    init(from controller: NavigationController) {
        self.stackCount = controller.path.count
        self.hasModal = controller.modal != nil

        if controller.sheetRoute != nil {
            self.modalType = .sheet
        } else if controller.fullScreenRoute != nil {
            self.modalType = .fullScreen
        } else {
            self.modalType = nil
        }
    }

    static func == (lhs: NavigationStateSnapshot, rhs: NavigationStateSnapshot) -> Bool {
        lhs.stackCount == rhs.stackCount &&
        lhs.hasModal == rhs.hasModal &&
        lhs.modalType == rhs.modalType
    }
}

// MARK: - Test Data Builders

struct TestProduct {
    let id: String
    let name: String
    let price: Double

    static func makeProducts(count: Int) -> [TestProduct] {
        (1...count).map { TestProduct(id: "prod\($0)", name: "Product \($0)", price: Double($0) * 9.99) }
    }
}

struct TestUser {
    let id: String
    let name: String
    let email: String

    static let guest = TestUser(id: "guest", name: "Guest", email: "guest@example.com")
    static let registered = TestUser(id: "user1", name: "John Doe", email: "john@example.com")
    static let admin = TestUser(id: "admin", name: "Admin", email: "admin@example.com")
}

// MARK: - Async Test Helpers

@MainActor
extension NavigationController {
    /// Simulate a navigation flow with delays
    func simulateUserFlow(
        steps: [(action: NavigationAction, delay: Duration)]
    ) async throws {
        for (action, delay) in steps {
            try await Task.sleep(for: delay)
            performAction(action)
        }
    }

    enum NavigationAction {
        case push(String)
        case pop
        case popToRoot
        case sheet(String)
        case present(String)
        case dismiss
    }

    private func performAction(_ action: NavigationAction) {
        switch action {
        case .push(let viewId):
            push(Text(viewId))
        case .pop:
            pop()
        case .popToRoot:
            popToRoot()
        case .sheet(let viewId):
            sheet(Text(viewId))
        case .present(let viewId):
            present(Text(viewId))
        case .dismiss:
            dismiss()
        }
    }
}
