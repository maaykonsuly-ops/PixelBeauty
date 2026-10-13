import SwiftUI

struct MakeupToolView: View {
    @ObservedObject var vm: EditorViewModel

    private let lipPalette: [Color] = [
        Color(hex: "#E91E63"), // Pink
        Color(hex: "#D32F2F"), // Red
        Color(hex: "#C2185B"), // Deep Rose
        Color(hex: "#880E4F"), // Wine
        Color(hex: "#FF7043"), // Coral
        Color(hex: "#BCAAA4")  // Nude
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                Text("Maquiagem Virtual")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Theme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                // Lip color selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cor dos Lábios")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Theme.textSecondary)

                    HStack(spacing: 12) {
                        ForEach(lipPalette, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                        .opacity(vm.makeupParams.lipColor == UIColor(color) ? 1 : 0)
                                )
                                .onTapGesture {
                                    vm.makeupParams.lipColor = UIColor(color)
                                    if vm.makeupParams.lipOpacity == 0 {
                                        vm.makeupParams.lipOpacity = 0.4
                                    }
                                    vm.applyMakeup()
                                }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

                VStack(spacing: 14) {
                    SliderRow(
                        icon: "mouth",
                        label: "Intensidade Batom",
                        value: Binding(
                            get: { Double(vm.makeupParams.lipOpacity) },
                            set: { vm.makeupParams.lipOpacity = Float($0) }
                        ),
                        onRelease: vm.applyMakeup
                    )

                    SliderRow(
                        icon: "sparkles",
                        label: "Clareamento Dental",
                        value: Binding(
                            get: { Double(vm.makeupParams.teethWhiten) },
                            set: { vm.makeupParams.teethWhiten = Float($0) }
                        ),
                        onRelease: vm.applyMakeup
                    )

                    SliderRow(
                        icon: "eye.fill",
                        label: "Brilho nos Olhos",
                        value: Binding(
                            get: { Double(vm.makeupParams.eyeBrighten) },
                            set: { vm.makeupParams.eyeBrighten = Float($0) }
                        ),
                        onRelease: vm.applyMakeup
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
    }
}
