import SwiftUI

// MARK: - Product Detail View Model

@MainActor
final class ProductDetailViewModel: ObservableObject {
    @Published var selectedQuantity = 1
    @Published var showAddedToCartAlert = false

    let product: Product
    let cart: ShoppingCart
    let coordinator: AppCoordinator

    init(product: Product, cart: ShoppingCart, coordinator: AppCoordinator) {
        self.product = product
        self.cart = cart
        self.coordinator = coordinator
    }

    func addToCart() {
        cart.addItem(product, quantity: selectedQuantity)
        showAddedToCartAlert = true

        // Auto-hide alert after 2 seconds
        Task {
            try? await Task.sleep(for: .seconds(2))
            showAddedToCartAlert = false
        }
    }

    func viewCart() {
        coordinator.showCart()
    }
}

// MARK: - Product Detail View

struct ProductDetailView: View {
    @StateObject var viewModel: ProductDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Product Image
                productImageSection

                // Product Info
                productInfoSection

                // Description
                descriptionSection

                // Reviews
                reviewsSection

                // Quantity Selector
                quantitySection

                // Add to Cart Button
                addToCartButton
            }
            .padding()
        }
        .navigationTitle(viewModel.product.name)
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .top) {
            if viewModel.showAddedToCartAlert {
                addedToCartAlert
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(), value: viewModel.showAddedToCartAlert)
    }

    // MARK: - View Components

    private var productImageSection: some View {
        Image(systemName: viewModel.product.imageName)
            .font(.system(size: 120))
            .frame(maxWidth: .infinity)
            .frame(height: 250)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
    }

    private var productInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.product.name)
                .font(.title)
                .fontWeight(.bold)

            HStack {
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(viewModel.product.rating) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.subheadline)
                    }
                }

                Text(String(format: "%.1f", viewModel.product.rating))
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("·")
                    .foregroundColor(.secondary)

                Text("\(viewModel.product.reviewCount) reviews")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Text("$\(String(format: "%.2f", viewModel.product.price))")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)

            // Category Badge
            HStack {
                Image(systemName: "tag")
                    .font(.caption)
                Text(viewModel.product.category.rawValue)
                    .font(.subheadline)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(8)
        }
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.headline)

            Text(viewModel.product.description)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Customer Reviews")
                .font(.headline)

            VStack(spacing: 16) {
                ReviewRow(
                    author: "John D.",
                    rating: 5,
                    comment: "Excellent product! Highly recommended.",
                    date: "2 days ago"
                )

                ReviewRow(
                    author: "Sarah M.",
                    rating: 4,
                    comment: "Good quality, fast shipping. Very satisfied with my purchase.",
                    date: "1 week ago"
                )
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
        }
    }

    private var quantitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quantity")
                .font(.headline)

            HStack(spacing: 16) {
                Button {
                    if viewModel.selectedQuantity > 1 {
                        viewModel.selectedQuantity -= 1
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(viewModel.selectedQuantity > 1 ? .blue : .gray)
                }
                .disabled(viewModel.selectedQuantity <= 1)

                Text("\(viewModel.selectedQuantity)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(width: 50)

                Button {
                    if viewModel.selectedQuantity < 10 {
                        viewModel.selectedQuantity += 1
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(viewModel.selectedQuantity < 10 ? .blue : .gray)
                }
                .disabled(viewModel.selectedQuantity >= 10)
            }
        }
    }

    private var addToCartButton: some View {
        Button {
            viewModel.addToCart()
        } label: {
            HStack {
                Image(systemName: "cart.badge.plus")
                Text("Add to Cart")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }

    private var addedToCartAlert: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text("Added to cart!")
                .fontWeight(.medium)
            Spacer()
            Button("View Cart") {
                viewModel.viewCart()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 8)
        .padding()
    }
}

// MARK: - Review Row

struct ReviewRow: View {
    let author: String
    let rating: Int
    let comment: String
    let date: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(author)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Spacer()

                Text(date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 2) {
                ForEach(0..<5) { index in
                    Image(systemName: index < rating ? "star.fill" : "star")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
            }

            Text(comment)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
