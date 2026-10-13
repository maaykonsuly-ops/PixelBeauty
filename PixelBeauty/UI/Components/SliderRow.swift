import SwiftUI

struct SliderRow: View {
    let icon: String
    let label: String
    @Binding var value: Double
    var range: ClosedRange<Double> = 0...1
    var step: Double = 0.01
    var onRelease: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.accentGradient)
                    .frame(width: 20)

                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Theme.textPrimary)

                Spacer()

                Text("\(Int(value * 100))%")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundColor(Theme.textSecondary)
            }

            Slider(value: $value, in: range, step: step) { editing in
                if !editing {
                    onRelease?()
                }
            }
            .tint(Theme.accent)
        }
        .padding(.vertical, 2)
    }
}
