import Foundation

// MARK: - Product Model

struct Product: Identifiable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
    let category: Category
    let imageName: String
    let rating: Double
    let reviewCount: Int

    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        price: Double,
        category: Category,
        imageName: String,
        rating: Double,
        reviewCount: Int
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.category = category
        self.imageName = imageName
        self.rating = rating
        self.reviewCount = reviewCount
    }

    enum Category: String, CaseIterable {
        case electronics = "Electronics"
        case clothing = "Clothing"
        case books = "Books"
        case home = "Home & Garden"
        case sports = "Sports"
    }
}

// MARK: - Sample Data

extension Product {
    static let sampleProducts: [Product] = [
        Product(
            name: "Wireless Headphones",
            description: "Premium noise-cancelling wireless headphones with 30-hour battery life. Perfect for music lovers and travelers.",
            price: 299.99,
            category: .electronics,
            imageName: "headphones",
            rating: 4.5,
            reviewCount: 1234
        ),
        Product(
            name: "Smart Watch",
            description: "Track your fitness goals with this advanced smartwatch featuring heart rate monitoring and GPS.",
            price: 399.99,
            category: .electronics,
            imageName: "applewatch",
            rating: 4.8,
            reviewCount: 892
        ),
        Product(
            name: "Running Shoes",
            description: "Lightweight and comfortable running shoes designed for maximum performance and support.",
            price: 129.99,
            category: .sports,
            imageName: "figure.run",
            rating: 4.6,
            reviewCount: 567
        ),
        Product(
            name: "Denim Jacket",
            description: "Classic denim jacket with modern fit. A timeless piece for any wardrobe.",
            price: 89.99,
            category: .clothing,
            imageName: "tshirt",
            rating: 4.3,
            reviewCount: 345
        ),
        Product(
            name: "Best-Selling Novel",
            description: "A gripping thriller that will keep you on the edge of your seat until the very last page.",
            price: 24.99,
            category: .books,
            imageName: "book",
            rating: 4.7,
            reviewCount: 2103
        ),
        Product(
            name: "Indoor Plant Set",
            description: "Beautiful collection of low-maintenance indoor plants to brighten up your living space.",
            price: 49.99,
            category: .home,
            imageName: "leaf",
            rating: 4.4,
            reviewCount: 456
        ),
        Product(
            name: "Yoga Mat",
            description: "Non-slip eco-friendly yoga mat with extra cushioning for comfortable practice.",
            price: 39.99,
            category: .sports,
            imageName: "figure.yoga",
            rating: 4.5,
            reviewCount: 789
        ),
        Product(
            name: "Coffee Table Book",
            description: "Stunning photography collection showcasing architectural marvels from around the world.",
            price: 59.99,
            category: .books,
            imageName: "book.closed",
            rating: 4.9,
            reviewCount: 234
        )
    ]
}
