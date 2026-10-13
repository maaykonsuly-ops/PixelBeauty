import SwiftUI

struct FilterToolView: View {
    @ObservedObject var vm: EditorViewModel

    var body: some View {
        VStack(spacing: 12) {
            Text("Filtros Artísticos")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 10)

            // Horizontal filters list
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(FilterPreset.allCases) { filter in
                        VStack(spacing: 6) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Theme.surfaceHigh)
                                    .frame(width: 56, height: 56)

                                Text(filter.icon)
                                    .font(.system(size: 24))

                                if vm.filterEnabled && vm.activeFilter == filter {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Theme.accent, lineWidth: 2)
                                        .frame(width: 56, height: 56)
                                }
                            }

                            Text(filter.rawValue)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(vm.filterEnabled && vm.activeFilter == filter ? Theme.accent : Theme.textSecondary)
                        }
                        .onTapGesture {
                            vm.activeFilter = filter
                            vm.filterEnabled = true
                            vm.applyFilter()
                        }
                    }
                }
                .padding(.horizontal, 20)
            }

            if vm.filterEnabled {
                SliderRow(
                    icon: "slider.horizontal.below.rectangle",
                    label: "Intensidade do Filtro",
                    value: Binding(
                        get: { Double(vm.filterIntensity) },
                        set: { vm.filterIntensity = Float($0) }
                    ),
                    onRelease: vm.applyFilter
                )
                .padding(.horizontal, 20)
            }
        }
    }
}
