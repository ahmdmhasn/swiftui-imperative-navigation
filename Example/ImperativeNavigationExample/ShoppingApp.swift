import ImperativeNavigation
import SwiftUI

/// A comprehensive example app demonstrating the ImperativeNavigation package.
///
/// This shopping app showcases various navigation patterns:
/// - **Push Navigation**: Browse products and navigate to detail views
/// - **Modal Sheets**: View shopping cart as a sheet presentation
/// - **Full Screen Cover**: Display order confirmation
/// - **Complex Flows**: Multi-step checkout process
/// - **State Management**: Shopping cart shared across views
///
/// The app demonstrates a real-world e-commerce flow:
/// 1. Browse products in the catalog
/// 2. View product details
/// 3. Add items to cart
/// 4. Review cart (presented as sheet)
/// 5. Complete checkout
/// 6. View order confirmation (full screen cover)
@main
struct ShoppingApp: App {
    private var coordinator = DefaultAppCoordinator()

    var body: some Scene {
        WindowGroup {
            NavigationView(
                controller: coordinator.navigationController,
                root: {
                    ProductCatalogView(
                        viewModel: ProductCatalogViewModel(
                            coordinator: coordinator,
                            cart: coordinator.shoppingCart
                        )
                    )
                }
            )
        }
    }
}
