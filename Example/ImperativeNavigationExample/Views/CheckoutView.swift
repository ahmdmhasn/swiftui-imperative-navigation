import SwiftUI

// MARK: - Checkout View Model

@MainActor
final class CheckoutViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var address = ""
    @Published var city = ""
    @Published var zipCode = ""
    @Published var isProcessing = false

    let cart: ShoppingCart
    let coordinator: AppCoordinator

    var isFormValid: Bool {
        !fullName.isEmpty &&
        !email.isEmpty &&
        email.contains("@") &&
        !address.isEmpty &&
        !city.isEmpty &&
        !zipCode.isEmpty
    }

    init(cart: ShoppingCart, coordinator: AppCoordinator) {
        self.cart = cart
        self.coordinator = coordinator
    }

    func placeOrder() {
        guard isFormValid else { return }

        isProcessing = true

        // Simulate API call
        Task {
            try? await Task.sleep(for: .seconds(2))
            isProcessing = false

            let orderNumber = "ORD-\(Int.random(in: 100000...999999))"
            coordinator.showOrderConfirmation(orderNumber: orderNumber)
        }
    }
}

// MARK: - Checkout View

struct CheckoutView: View {
    @StateObject var viewModel: CheckoutViewModel

    var body: some View {
        Form {
            // Order Summary Section
            Section("Order Summary") {
                ForEach(viewModel.cart.items) { item in
                    HStack {
                        Text(item.product.name)
                        Spacer()
                        Text("\(item.quantity)x")
                            .foregroundColor(.secondary)
                        Text("$\(String(format: "%.2f", item.product.price * Double(item.quantity)))")
                            .fontWeight(.medium)
                    }
                }

                HStack {
                    Text("Total")
                        .fontWeight(.bold)
                    Spacer()
                    Text("$\(String(format: "%.2f", viewModel.cart.totalPrice))")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }

            // Shipping Information Section
            Section("Shipping Information") {
                TextField("Full Name", text: $viewModel.fullName)
                    .textContentType(.name)

                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                TextField("Address", text: $viewModel.address)
                    .textContentType(.streetAddressLine1)

                TextField("City", text: $viewModel.city)
                    .textContentType(.addressCity)

                TextField("ZIP Code", text: $viewModel.zipCode)
                    .textContentType(.postalCode)
                    .keyboardType(.numberPad)
            }

            // Payment Section (Mock)
            Section("Payment Method") {
                HStack {
                    Image(systemName: "creditcard")
                    Text("•••• •••• •••• 4242")
                    Spacer()
                    Text("Visa")
                        .foregroundColor(.secondary)
                }
            }

            // Place Order Button
            Section {
                Button {
                    viewModel.placeOrder()
                } label: {
                    HStack {
                        if viewModel.isProcessing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                        Text(viewModel.isProcessing ? "Processing..." : "Place Order")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                }
                .disabled(!viewModel.isFormValid || viewModel.isProcessing)
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
    }
}
