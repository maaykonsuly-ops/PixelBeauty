import SwiftUI

struct BeautyToolView: View {
    @ObservedObject var vm: EditorViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Beauty")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 12)

            VStack(spacing: 14) {
                SliderRow(
                    icon: "wand.and.stars",
                    label: "Suavidade",
                    value: Binding(
                        get: { Double(vm.beautyParams.smooth) },
                        set: { vm.beautyParams.smooth = Float($0) }
                    ),
                    onRelease: vm.applyBeauty
                )
                SliderRow(
                    icon: "sun.max.fill",
                    label: "Clarear Pele",
                    value: Binding(
                        get: { Double(vm.beautyParams.whitenSkin) },
                        set: { vm.beautyParams.whitenSkin = Float($0) }
                    ),
                    onRelease: vm.applyBeauty
                )
                SliderRow(
                    icon: "sparkle",
                    label: "Brilho",
                    value: Binding(
                        get: { Double(vm.beautyParams.brighten) },
                        set: { vm.beautyParams.brighten = Float($0) }
                    ),
                    onRelease: vm.applyBeauty
                )
            }
            .padding(.horizontal, 20)
        }
    }
}
