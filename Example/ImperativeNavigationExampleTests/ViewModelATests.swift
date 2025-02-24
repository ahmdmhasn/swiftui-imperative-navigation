@testable import ImperativeNavigationExample
import Testing

@MainActor
struct ViewModelATests {
    // MARK: Tests
    @Test func testButtonTapped_navigatesToB() async throws {
        // Given
        let viewModel = makeViewModel()
        
        // When
        viewModel.buttonTapped()
        
        // Then
        #expect(coordinatorMock.navigateToBCallCount == 1)
    }

    // MARK: Private Handlers
    private func makeViewModel() -> ViewModelA {
        ViewModelA(coordinator: coordinatorMock)
    }

    // MARK: Dependencies
    private let coordinatorMock = CoordinatorMock()
}

// MARK: CoordinatorMock

final class CoordinatorMock: Coordinator {
    private(set) var popCallCount: Int = .zero
    func pop() {
        popCallCount += 1
    }
    
    private(set) var navigateToBCallCount: Int = .zero
    func navigateToB() {
        navigateToBCallCount += 1
    }
    
    private(set) var navigateToCCallCount: Int = .zero
    func navigateToC() {
        navigateToCCallCount += 1
    }
    
    private(set) var dismissCThenPresentDCallCount: Int = .zero
    func dismissCThenPresentD() {
        dismissCThenPresentDCallCount += 1
    }
    
    private(set) var navigateToRootCallCount: Int = .zero
    func navigateToRoot() {
        navigateToRootCallCount += 1
    }
}
