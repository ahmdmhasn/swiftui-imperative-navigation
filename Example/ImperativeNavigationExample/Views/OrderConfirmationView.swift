import SwiftUI

// MARK: - Order Confirmation View Model

@MainActor
final class OrderConfirmationViewModel: ObservableObject {
    let orderNumber: String
    let coordinator: AppCoordinator

    init(orderNumber: String, coordinator: AppCoordinator) {
        self.orderNumber = orderNumber
        self.coordinator = coordinator
    }

    func continueShopping() {
        coordinator.dismissModal()
        coordinator.popToRoot()
    }
}

// MARK: - Order Confirmation View

struct OrderConfirmationView: View {
    @StateObject var viewModel: OrderConfirmationViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                // Success Icon
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 120, height: 120)

                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                }

                // Success Message
                VStack(spacing: 12) {
                    Text("Order Confirmed!")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Thank you for your purchase")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }

                // Order Details
                VStack(spacing: 16) {
                    OrderDetailRow(
                        icon: "number",
                        title: "Order Number",
                        value: viewModel.orderNumber
                    )

                    OrderDetailRow(
                        icon: "calendar",
                        title: "Estimated Delivery",
                        value: estimatedDeliveryDate
                    )

                    OrderDetailRow(
                        icon: "envelope",
                        title: "Confirmation Email",
                        value: "Sent to your inbox"
                    )
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(16)
                .padding(.horizontal)

                Spacer()

                // Continue Shopping Button
                Button {
                    viewModel.continueShopping()
                } label: {
                    Text("Continue Shopping")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Success")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
        }
    }

    private var estimatedDeliveryDate: String {
        let calendar = Calendar.current
        if let futureDate = calendar.date(byAdding: .day, value: 5, to: Date()) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: futureDate)
        }
        return "5-7 business days"
    }
}

// MARK: - Order Detail Row

struct OrderDetailRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }

            Spacer()
        }
    }
}
