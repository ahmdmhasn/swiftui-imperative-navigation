# SwiftUI Imperative Navigation

[![CI Status](https://img.shields.io/github/actions/workflow/status/ahmdmhasn/swiftui-imperative-navigation/ci.yml?branch=main)](https://github.com/ahmdmhasn/swiftui-imperative-navigation/actions?query=workflow%3ACI+branch%3Amain)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://spdx.org/licenses/MIT.html)

A modern approach to handling navigation in SwiftUI using an imperative style. This method simplifies view logic by extracting navigation concerns, improving testability, and making the codebase more maintainable.

Medium Article: [Link](https://medium.com/@ahmdmhasn/mastering-imperative-navigation-in-swiftui-with-a-coordinator-pattern-8a7e034b242d)

## 📌 Why Imperative Navigation?
While SwiftUI promotes declarative navigation with `NavigationStack` and `NavigationLink`, complex navigation flows can become difficult to manage. Imperative navigation allows:
- **Decoupling navigation logic** from views.
- **Better testability** by moving navigation handling to a dedicated coordinator.
- **Improved maintainability** by centralizing navigation in a single source of truth.

## 🚀 Features
- Navigation managed outside of views.
- Supports deep linking and complex navigation flows.
- Clean and structured architecture using a navigation coordinator.

## 🏞️ Screenshot

<img src="Screenshots/Sample.gif"/>

## 🛠 Setup
### Requirements
- iOS 16.0+
- Xcode 15+
- Swift 5.9+

### Installation
Clone the repository:
```sh
git clone https://github.com/ahmdmhasn/swiftui-imperative-navigation.git
cd swiftui-imperative-navigation
```
Open `SwiftUIImperativeNavigation.xcodeproj` in Xcode and run the sample project.

## 📖 Components
### NavigationView
The `NavigationCoordinator` acts as the central controller for handling navigation events.

```swift
@MainActor
public final class NavigationController: ObservableObject {
    func push<V: View>(_ view: V)

    func pop()

    func popToRoot()

    func present<V: View>(_ view: V)

    func sheet<V: View>(_ view: V)

    func dismiss()
}
```

### NavigationView
The `NavigationView` works with the `NavigationController`.

```swift
struct NavigationView<Root: View>: View {
    ...

    var body: some View {
        NavigationStack(path: $controller.path) {
            root
                .navigationDestination(for: Route.self, destination: \.body)
                .fullScreenCover(item: $controller.modal, content: \.route.body)
                .sheet(item: $controller.modal, content: \.route.body)
        }
    }
}
```

## 📖 Usage
```swift
@MainActor
final class DefaultCoordinator {
    let navigationController = NavigationController()

    func navigateToB() {
        navigationController.push(ViewB(coordinator: self)) // Push SwiftUI.View
    }

    func navigateToC() {
        let coordinatorC = DefaultCoordinatorC { [weak self] in
            self?.navigationController.dismiss() // Dismiss presented modal
        }

        coordinatorC.start(from: navigationController) // Present coordinator
    }
}
```

### 3️2️⃣  Navigate Imperatively
```swift
struct HomeView: View {
    let coordinator: Coordinator
    
    var body: some View {
        Button("Go to Details") {
            coordinator.navigateToB()
        }
    }
}
```

## 🏗 Future Improvements
- Add unit tests for navigation logic.
- Extend examples for more navigation patterns (modals, tab-based navigation).
- Provide better state persistence handling.

## 🤝 Contributing
Contributions are welcome! Feel free to open an issue or submit a pull request.

## 📜 License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🌟 Support
If you find this project helpful, give it a ⭐ on GitHub!