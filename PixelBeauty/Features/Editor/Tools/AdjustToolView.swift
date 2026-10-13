import SwiftUI

struct AdjustToolView: View {
    @ObservedObject var vm: EditorViewModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 14) {
                Text("Ajustes Manuais")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Theme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                VStack(spacing: 14) {
                    SliderRow(
                        icon: "sun.max",
                        label: "Brilho",
                        value: $vm.adjustParams.brightness,
                        range: -0.5...0.5,
                        onRelease: vm.applyAdjustments
                    )

                    SliderRow(
                        icon: "circle.righthalf.filled",
                        label: "Contraste",
                        value: $vm.adjustParams.contrast,
                        range: -0.5...0.5,
                        onRelease: vm.applyAdjustments
                    )

                    SliderRow(
                        icon: "drop.fill",
                        label: "Saturação",
                        value: $vm.adjustParams.saturation,
                        range: -0.5...0.5,
                        onRelease: vm.applyAdjustments
                    )

                    SliderRow(
                        icon: "plusminus.circle",
                        label: "Exposição",
                        value: $vm.adjustParams.exposure,
                        range: -1.0...1.0,
                        onRelease: vm.applyAdjustments
                    )

                    SliderRow(
                        icon: "triangle.fill",
                        label: "Nitidez",
                        value: $vm.adjustParams.sharpness,
                        range: 0...1.0,
                        onRelease: vm.applyAdjustments
                    )

                    SliderRow(
                        icon: "camera.aperture",
                        label: "Vinheta",
                        value: $vm.adjustParams.vignette,
                        range: 0...1.0,
                        onRelease: vm.applyAdjustments
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
    }
}
