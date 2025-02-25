import Testing
import SwiftUI
@testable import ImperativeNavigation

@MainActor
@Suite
struct NavigationControllerTests {
    @Test
    func pushView() {
        // Given
        let navigationController = NavigationController()
        let view = Text("Test View")
        
        // When
        navigationController.push(view)
        
        // Then
        #expect(navigationController.path.count == 1)
    }
    
    @Test
    func popView() {
        // Given
        let navigationController = NavigationController()
        let view = Text("Test View")
        navigationController.push(view)
        
        // When
        navigationController.pop()
        
        // Then
        #expect(navigationController.path.isEmpty)
    }

    @Test
    func popViewReturnsPoppedViewType() {
        // Given
        let navigationController = NavigationController()
        let view1 = View1()
        let view2 = View2()
        navigationController.push(view1)
        navigationController.push(view2)
        
        // When
        let poppedView2: View2? = navigationController.pop()
        let poppedView1: View1? = navigationController.pop()
        
        // Then
        #expect(poppedView2 != nil)
        #expect(poppedView1 != nil)
    }
    
    @Test
    func popToRoot() {
        // Given
        let navigationController = NavigationController()
        navigationController.push(Text("View 1"))
        navigationController.push(Text("View 2"))
        
        // When
        navigationController.popToRoot()
        
        // Then
        #expect(navigationController.path.isEmpty)
    }
    
    @Test
    func presentModal() {
        // Given
        let navigationController = NavigationController()
        let view = Text("Modal View")
        
        // When
        navigationController.present(view)
        
        // Then
        #expect(navigationController.modal != nil)
    }
    
    @Test
    func dismissModal() {
        // Given
        let navigationController = NavigationController()
        navigationController.present(Text("Modal View"))
        
        // When
        navigationController.dismiss()
        
        // Then
        #expect(navigationController.modal == nil)
    }
    
    // MARK: - Nested Views
    
    private struct View1: View {
        var body: some View {
            Text("View 1")
        }
    }

    private struct View2: View {
        var body: some View {
            Text("View 2")
        }
    }
}
