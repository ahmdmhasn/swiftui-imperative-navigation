import SwiftUI

// MARK: - Cart View Model

@MainActor
final class CartViewModel: ObservableObject {
    let cart: ShoppingCart
    let coordinator: AppCoordinator

    init(cart: ShoppingCart, coordinator: AppCoordinator) {
        self.cart = cart
        self.coordinator = coordinator
    }

    func removeItem(_ product: Product) {
        cart.removeItem(product)
    }

    func updateQuantity(for product: Product, quantity: Int) {
        cart.updateQuantity(for: product, quantity: quantity)
    }

    func proceedToCheckout() {
        coordinator.showCheckout()
    }

    func dismiss() {
        coordinator.dismissModal()
    }
}

// MARK: - Cart View

struct CartView: View {
    @StateObject var viewModel: CartViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.cart.items.isEmpty {
                    emptyCartView
                } else {
                    cartContentView
                }
            }
            .navigationTitle("Shopping Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        viewModel.dismiss()
                    }
                }
            }
        }
    }

    // MARK: - View Components

    private var emptyCartView: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 80))
                .foregroundColor(.gray)

            Text("Your cart is empty")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Add some products to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var cartContentView: some View {
        VStack(spacing: 0) {
            // Cart Items List
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.cart.items) { item in
                        CartItemRow(
                            item: item,
                            onQuantityChange: { newQuantity in
                                viewModel.updateQuantity(for: item.product, quantity: newQuantity)
                            },
                            onRemove: {
                                withAnimation {
                                    viewModel.removeItem(item.product)
                                }
                            }
                        )
                    }
                }
                .padding()
            }

            Divider()

            // Summary Section
            cartSummary
        }
    }

    private var cartSummary: some View {
        VStack(spacing: 16) {
            // Subtotal
            HStack {
                Text("Subtotal (\(viewModel.cart.itemCount) items)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("$\(String(format: "%.2f", viewModel.cart.totalPrice))")
                    .font(.headline)
            }

            // Checkout Button
            Button {
                viewModel.proceedToCheckout()
            } label: {
                HStack {
                    Text("Proceed to Checkout")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("$\(String(format: "%.2f", viewModel.cart.totalPrice))")
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
    }
}

// MARK: - Cart Item Row

struct CartItemRow: View {
    let item: CartItem
    let onQuantityChange: (Int) -> Void
    let onRemove: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Product Image
            Image(systemName: item.product.imageName)
                .font(.system(size: 40))
                .frame(width: 80, height: 80)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 8) {
                // Product Name
                Text(item.product.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)

                // Price
                Text("$\(String(format: "%.2f", item.product.price))")
                    .font(.subheadline)
                    .foregroundColor(.blue)

                // Quantity Controls
                HStack(spacing: 12) {
                    Button {
                        onQuantityChange(item.quantity - 1)
                    } label: {
                        Image(systemName: "minus.circle")
                            .font(.title3)
                            .foregroundColor(item.quantity > 1 ? .blue : .gray)
                    }
                    .disabled(item.quantity <= 1)

                    Text("\(item.quantity)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 30)

                    Button {
                        onQuantityChange(item.quantity + 1)
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }

                    Spacer()

                    // Remove Button
                    Button(role: .destructive) {
                        onRemove()
                    } label: {
                        Image(systemName: "trash")
                            .font(.title3)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
