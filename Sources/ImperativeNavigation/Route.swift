import Foundation
import SwiftUI

// MARK: - Route

public struct Route {
    init<Content: View>(_ body: Content) {
        self.body = body // Store same view for later casting.
        self.viewType = String(describing: Content.self) // Keep the view name for reference.
        self.identifier = UUID() // Each route should be unique.
    }

    let body: any View
    private let viewType: String
    private let identifier: UUID
}

// MARK: Route + Hashable Conformance

extension Route: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(viewType)
        hasher.combine(identifier)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.viewType == rhs.viewType && lhs.identifier == rhs.identifier
    }
}

// MARK: Route + Identifiable Conformance

extension Route: Identifiable {
    public var id: Int { hashValue }
}
