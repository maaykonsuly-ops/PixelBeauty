import SwiftUI

struct ReshapeToolView: View {
    @ObservedObject var vm: EditorViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Modelar Rosto (Reshape)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 10)

            VStack(spacing: 14) {
                SliderRow(
                    icon: "person.crop.rectangle",
                    label: "Afinar Rosto",
                    value: Binding(
                        get: { Double(vm.reshapeParams.slimFace) },
                        set: { vm.reshapeParams.slimFace = Float($0) }
                    ),
                    onRelease: vm.applyReshape
                )

                SliderRow(
                    icon: "eye",
                    label: "Aumentar Olhos",
                    value: Binding(
                        get: { Double(vm.reshapeParams.bigEyes) },
                        set: { vm.reshapeParams.bigEyes = Float($0) }
                    ),
                    onRelease: vm.applyReshape
                )

                SliderRow(
                    icon: "nose",
                    label: "Afinar Nariz",
                    value: Binding(
                        get: { Double(vm.reshapeParams.slimNose) },
                        set: { vm.reshapeParams.slimNose = Float($0) }
                    ),
                    onRelease: vm.applyReshape
                )
            }
            .padding(.horizontal, 20)
        }
    }
}
