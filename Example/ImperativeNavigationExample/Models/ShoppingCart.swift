import Foundation

// MARK: - Shopping Cart

@MainActor
final class ShoppingCart: ObservableObject {
    @Published private(set) var items: [CartItem] = []

    var totalPrice: Double {
        items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }

    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    func addItem(_ product: Product, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += quantity
        } else {
            items.append(CartItem(product: product, quantity: quantity))
        }
    }

    func removeItem(_ product: Product) {
        items.removeAll { $0.product.id == product.id }
    }

    func updateQuantity(for product: Product, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            if quantity <= 0 {
                items.remove(at: index)
            } else {
                items[index].quantity = quantity
            }
        }
    }

    func clear() {
        items.removeAll()
    }
}

// MARK: - Cart Item

struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
}
