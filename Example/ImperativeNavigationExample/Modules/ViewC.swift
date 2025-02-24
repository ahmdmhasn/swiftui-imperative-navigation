import SwiftUI

// MARK: - Coordinator C

@MainActor
protocol CoordinatorC {
    func dismissCThenPresentD()
}

// MARK: - ViewC

struct ViewC: View {
    let coordinator: CoordinatorC
    
    @State
    private var countdown: Int = 2
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text("C")
            .font(.title)
        Text("Dismissing C then presenting D in: \(countdown)")
            .onReceive(timer) { _ in
                countdown -= 1

                if countdown == .zero {
                    coordinator.dismissCThenPresentD()
                }
            }
    }
}
