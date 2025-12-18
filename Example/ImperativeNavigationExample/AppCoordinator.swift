import ImperativeNavigation
import SwiftUI

// MARK: - App Coordinator Protocol

@MainActor
protocol AppCoordinator {
    func showProductDetail(_ product: Product)
    func showCategory(_ category: Product.Category)
    func showCart()
    func showCheckout()
    func showOrderConfirmation(orderNumber: String)
    func dismissModal()
    func popToRoot()
}

// MARK: - Coordinator Implementation

@MainActor
final class DefaultAppCoordinator: AppCoordinator {
    func showProductDetail(_ product: Product) {
        let viewModel = ProductDetailViewModel(
            product: product,
            cart: shoppingCart,
            coordinator: self
        )
        navigationController.push(ProductDetailView(viewModel: viewModel))
    }

    func showCategory(_ category: Product.Category) {
        let viewModel = CategoryViewModel(
            category: category,
            coordinator: self
        )
        navigationController.push(CategoryView(viewModel: viewModel))
    }

    func showCart() {
        let viewModel = CartViewModel(
            cart: shoppingCart,
            coordinator: self
        )
        navigationController.sheet(CartView(viewModel: viewModel))
    }

    func showCheckout() {
        navigationController.dismiss()

        let viewModel = CheckoutViewModel(
            cart: shoppingCart,
            coordinator: self
        )
        navigationController.push(CheckoutView(viewModel: viewModel))
    }

    func showOrderConfirmation(orderNumber: String) {
        shoppingCart.clear()

        let viewModel = OrderConfirmationViewModel(
            orderNumber: orderNumber,
            coordinator: self
        )
        navigationController.present(OrderConfirmationView(viewModel: viewModel))
    }

    func dismissModal() {
        navigationController.dismiss()
    }

    func popToRoot() {
        navigationController.popToRoot()
    }

    let shoppingCart = ShoppingCart()
    let navigationController = NavigationController()
}
