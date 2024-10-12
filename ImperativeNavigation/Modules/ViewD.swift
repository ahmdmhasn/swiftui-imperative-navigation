import SwiftUI

struct ViewD: View {
    @State
    private var countdown: Int = 2
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text("D")
            .font(.title)
        Text("Dismissing view in: \(countdown)")
            .onReceive(timer) { input in
                countdown -= 1
            }
    }
}
