import SwiftUI



import SwiftUI




struct CardView: View {
    let text: String
    let isFlipped: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(isFlipped ? Color.blue.opacity(0.2) : Color.yellow.opacity(0.8)) // Keep colors
                .shadow(radius: 5)

            Text(text)
                .font(isFlipped ? .footnote : .title) // Smaller font for answer
                .foregroundColor(.black)
                .padding(isFlipped ? 15 : 0) // Apply padding only for the answer
                .multilineTextAlignment(.center)
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0), // Flip only text
                    axis: (x: 0, y: 1, z: 0)
                ) // ✅ Keeps text upright
        }
        .frame(width: 300, height: 250)
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0), // Flip card
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.6), value: isFlipped) // Smooth animation
    }
}


