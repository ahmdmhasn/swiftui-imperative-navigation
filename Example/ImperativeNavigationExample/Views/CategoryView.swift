import SwiftUI

// MARK: - Category View Model

@MainActor
final class CategoryViewModel: ObservableObject {
    let category: Product.Category
    let coordinator: AppCoordinator

    var products: [Product] {
        Product.sampleProducts.filter { $0.category == category }
    }

    init(category: Product.Category, coordinator: AppCoordinator) {
        self.category = category
        self.coordinator = coordinator
    }

    func selectProduct(_ product: Product) {
        coordinator.showProductDetail(product)
    }
}

// MARK: - Category View

struct CategoryView: View {
    @StateObject var viewModel: CategoryViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                headerSection

                // Products List
                productsSection
            }
            .padding()
        }
        .navigationTitle(viewModel.category.rawValue)
    }

    // MARK: - View Components

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: categoryIcon)
                    .font(.title)
                    .foregroundColor(.blue)

                Text(viewModel.category.rawValue)
                    .font(.title)
                    .fontWeight(.bold)
            }

            Text("\(viewModel.products.count) products available")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var productsSection: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.products) { product in
                CategoryProductCard(product: product) {
                    viewModel.selectProduct(product)
                }
            }
        }
    }

    private var categoryIcon: String {
        switch viewModel.category {
        case .electronics: return "laptopcomputer"
        case .clothing: return "tshirt"
        case .books: return "book"
        case .home: return "house"
        case .sports: return "sportscourt"
        }
    }
}

// MARK: - Category Product Card

struct CategoryProductCard: View {
    let product: Product
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Product Image
                Image(systemName: product.imageName)
                    .font(.system(size: 50))
                    .frame(width: 80, height: 80)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)

                // Product Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.name)
                        .font(.headline)
                        .multilineTextAlignment(.leading)

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", product.rating))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("(\(product.reviewCount))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Text("$\(String(format: "%.2f", product.price))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
