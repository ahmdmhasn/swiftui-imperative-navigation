# SwiftUI Imperative Navigation Sample

This project demonstrates how to implement **imperative navigation** in SwiftUI using a **coordinator pattern**. This approach aims to separate the navigation logic from the view layer, making it easier to manage, maintain, and test complex navigation flows.

Medium Article: [Link](https://medium.com/@ahmdmhasn/mastering-imperative-navigation-in-swiftui-with-a-coordinator-pattern-8a7e034b242d)

## Features

- **Decoupled Navigation Logic**: Navigation logic is managed by a `Coordinator`, reducing the complexity of views.
- **Improved Testability**: By extracting navigation logic into a separate component, you can write tests for navigation flows without involving the UI layer.
- **Support for Modals**: Handles both sheet and full-screen modals using a custom `ModalRoute` enum.
- **Clean and Maintainable Code**: Uses SwiftUI's `NavigationStack` for a seamless and modern navigation experience.

## How It Works

1. **Coordinator Pattern**: The `DefaultCoordinator` manages all navigation actions. It defines routes (`viewB`, `viewC`, `viewD`) and maps them to the appropriate SwiftUI views.
2. **Custom Navigation View**: A custom `NavigationView` is used to integrate the coordinator with a `NavigationStack`, allowing for imperative-style navigation.
3. **Modals Management**: Uses `ModalRoute` to manage presentation of views as sheets or full-screen covers.

## Usage

To run this project:

1. Clone the repository:
    ```bash
    git clone https://github.com/your-username/SwiftUI-Imperative-Navigation.git
    ```

2. Open the .xcodeproj file in Xcode.
3. Build and run the project on the simulator or your device.

## Screenshots

<img src="Screenshots/Sample.gif"/>

## Contributing
Contributions are welcome! Feel free to open a pull request or submit issues for any bugs or suggestions.

## License
This project is licensed under the [MIT License](https://opensource.org/license/mit).

