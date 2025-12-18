# SwiftUI Imperative Navigation

[![CI Status](https://img.shields.io/github/actions/workflow/status/ahmdmhasn/swiftui-imperative-navigation/ci.yml?branch=main)](https://github.com/ahmdmhasn/swiftui-imperative-navigation/actions?query=workflow%3ACI+branch%3Amain)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://spdx.org/licenses/MIT.html)
[![Swift Version](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fahmdmhasn%2Fswiftui-imperative-navigation%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ahmdmhasn/swiftui-imperative-navigation)
[![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fahmdmhasn%2Fswiftui-imperative-navigation%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ahmdmhasn/swiftui-imperative-navigation)

A powerful and lightweight Swift package for managing navigation in SwiftUI apps using an imperative, coordinator-based approach. Build complex navigation flows with clean, testable, and maintainable code.

📖 **[Read the full article on Medium](https://medium.com/@ahmdmhasn/mastering-imperative-navigation-in-swiftui-with-a-coordinator-pattern-8a7e034b242d)**

## ✨ Features

- 🎯 **Imperative Navigation API** - Control navigation programmatically from coordinators or view models
- 📱 **Multiple Presentation Styles** - Support for push, sheet, and full-screen cover presentations
- 🏗️ **Coordinator Pattern** - Decouple navigation logic from views for better architecture
- ✅ **Type-Safe** - Compile-time safety for navigation parameters
- 🧪 **Testable** - Mock coordinators and test navigation flows easily
- 🔄 **State Management** - Share state across navigation flows seamlessly
- 📦 **Lightweight** - Minimal dependencies, just SwiftUI

## 📌 Why Imperative Navigation?

While SwiftUI promotes declarative navigation with `NavigationStack` and `NavigationLink`, complex navigation flows can become challenging to manage. Imperative navigation offers:

- ✅ **Separation of Concerns** - Navigation logic lives outside of views
- ✅ **Enhanced Testability** - Test navigation flows independently from UI
- ✅ **Complex Flows Made Simple** - Handle multi-step processes, conditional navigation, and dynamic routing
- ✅ **Single Source of Truth** - Centralized navigation state management
- ✅ **Better Code Organization** - Clear responsibility boundaries between views and navigation

## 🏞️ Screenshot

<img src="Screenshots/Sample.gif"/>

## 📦 Installation

### Swift Package Manager

Add the package to your project using Xcode:

1. File → Add Package Dependencies
2. Enter the repository URL:
   ```
   https://github.com/ahmdmhasn/swiftui-imperative-navigation.git
   ```
3. Select the version and add to your target

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ahmdmhasn/swiftui-imperative-navigation.git", from: "1.0.0")
]
```

### Requirements

- iOS 16.0+ / watchOS 9.0+ / tvOS 16.0+ / visionOS 1.0+
- Xcode 16.0+
- Swift 6.0+

## 🚀 Quick Start

### 1. Create a Navigation Controller

```swift
@MainActor
final class AppCoordinator {
    let navigationController = NavigationController()

    func showDetail(_ item: Item) {
        navigationController.push(DetailView(item: item))
    }

    func showSettings() {
        navigationController.sheet(SettingsView())
    }

    func showConfirmation() {
        navigationController.present(ConfirmationView())
    }
}
```

### 2. Set Up Your Root View

```swift
@main
struct MyApp: App {
    @StateObject private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            NavigationView(
                controller: coordinator.navigationController,
                root: {
                    HomeView(coordinator: coordinator)
                }
            )
        }
    }
}
```

### 3. Navigate From Your Views

```swift
struct HomeView: View {
    let coordinator: AppCoordinator

    var body: some View {
        VStack {
            Button("Show Detail") {
                coordinator.showDetail(selectedItem)
            }

            Button("Show Settings") {
                coordinator.showSettings()
            }
        }
    }
}
```

## 📖 API Reference

### NavigationController

The central controller for managing navigation:

```swift
@MainActor
public final class NavigationController: ObservableObject {
    // Push a view onto the navigation stack
    public func push<V: View>(_ view: V)

    // Pop the top view from the stack
    public func pop()

    // Pop all views and return to root
    public func popToRoot()

    // Present a view as a full-screen cover
    public func present<V: View>(_ view: V)

    // Present a view as a sheet modal
    public func sheet<V: View>(_ view: V)

    // Dismiss the current modal (sheet or full-screen)
    public func dismiss()
}
```

## 💡 Example App

Check out the comprehensive [example app](./Example) included in the repository. It demonstrates:

- 🛒 E-commerce shopping flow with product catalog
- 📦 Product details with reviews and ratings
- 🛍️ Shopping cart with sheet presentation
- 💳 Multi-step checkout process
- ✅ Order confirmation with full-screen cover
- 🔄 Complex navigation flows and state management

[View the example code →](./Example/README.md)

## 🧪 Testing

The package includes comprehensive unit tests for the navigation controller. The coordinator pattern makes your navigation logic highly testable:

```swift
@MainActor
final class MockAppCoordinator: AppCoordinator {
    var didShowDetail = false
    var didShowSettings = false

    override func showDetail(_ item: Item) {
        didShowDetail = true
    }

    override func showSettings() {
        didShowSettings = true
    }
}

// Test your view models or coordinators
func testNavigation() {
    let coordinator = MockCoordinator()
    coordinator.showDetail(item)
    XCTAssertTrue(coordinator.didShowDetail)
}
```

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please read our [contribution guidelines](CONTRIBUTING.md) before submitting a PR.

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Ahmed M. Hassan**
- GitHub: [@ahmdmhasn](https://github.com/ahmdmhasn)
- Medium: [@ahmdmhasn](https://medium.com/@ahmdmhasn)

## 🌟 Support

If you find this project helpful:
- ⭐ Star the repository
- 🐦 Share on social media
- 📝 Write about it
- 💬 Provide feedback and suggestions

## 🙏 Acknowledgments

Thanks to the SwiftUI community for inspiration and feedback on navigation patterns.