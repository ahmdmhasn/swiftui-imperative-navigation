import SwiftUI

// MARK: - Product Catalog View Model

@MainActor
final class ProductCatalogViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedCategory: Product.Category?

    let coordinator: AppCoordinator
    let cart: ShoppingCart

    var filteredProducts: [Product] {
        var products = Product.sampleProducts

        if let category = selectedCategory {
            products = products.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            products = products.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }

        return products
    }

    init(coordinator: AppCoordinator, cart: ShoppingCart) {
        self.coordinator = coordinator
        self.cart = cart
    }

    func selectProduct(_ product: Product) {
        coordinator.showProductDetail(product)
    }

    func selectCategory(_ category: Product.Category) {
        coordinator.showCategory(category)
    }

    func showCart() {
        coordinator.showCart()
    }
}

// MARK: - Product Catalog View

struct ProductCatalogView: View {
    @StateObject var viewModel: ProductCatalogViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                headerSection

                // Categories
                categorySection

                // Products Grid
                productsSection
            }
            .padding()
        }
        .navigationTitle("Shop")
        .searchable(text: $viewModel.searchText, prompt: "Search products")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                cartButton
            }
        }
    }

    // MARK: - View Components

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome to the Store")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Discover amazing products")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Product.Category.allCases, id: \.self) { category in
                        CategoryChip(
                            category: category,
                            isSelected: viewModel.selectedCategory == category
                        ) {
                            if viewModel.selectedCategory == category {
                                viewModel.selectedCategory = nil
                            } else {
                                viewModel.selectedCategory = category
                            }
                        }
                    }
                }
            }
        }
    }

    private var productsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Products")
                .font(.headline)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(viewModel.filteredProducts) { product in
                    ProductCard(product: product) {
                        viewModel.selectProduct(product)
                    }
                }
            }
        }
    }

    private var cartButton: some View {
        Button {
            viewModel.showCart()
        } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "cart")
                    .font(.title3)

                if viewModel.cart.itemCount > 0 {
                    Text("\(viewModel.cart.itemCount)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 16, height: 16)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 8, y: -8)
                }
            }
        }
    }
}

// MARK: - Category Chip

struct CategoryChip: View {
    let category: Product.Category
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: iconName)
                    .font(.caption)
                Text(category.rawValue)
                    .font(.subheadline)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }

    private var iconName: String {
        switch category {
        case .electronics: return "laptopcomputer"
        case .clothing: return "tshirt"
        case .books: return "book"
        case .home: return "house"
        case .sports: return "sportscourt"
        }
    }
}

// MARK: - Product Card

struct ProductCard: View {
    let product: Product
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                // Product Image
                Image(systemName: product.imageName)
                    .font(.system(size: 50))
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)

                VStack(alignment: .leading, spacing: 4) {
                    // Product Name
                    Text(product.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    // Rating
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", product.rating))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("(\(product.reviewCount))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }

                    // Price
                    Text("$\(String(format: "%.2f", product.price))")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
