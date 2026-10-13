import SwiftUI

struct EditorView: View {
    @StateObject private var vm: EditorViewModel
    @Environment(\.dismiss) private var dismiss

    init(image: UIImage) {
        _vm = StateObject(wrappedValue: EditorViewModel(image: image))
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                imageCanvas
                toolSelector
                toolPanel
                    .frame(height: 220)
            }

            if vm.isProcessing {
                processingOverlay
            }
        }
        .navigationBarHidden(true)
        .toast(isPresented: $vm.showExportSuccess, message: "✅ Salvo na galeria!")
    }

    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                    .frame(width: 44, height: 44)
                    .background(Theme.surfaceHigh)
                    .clipShape(Circle())
            }

            Spacer()

            Text("Editar")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Theme.textPrimary)

            Spacer()

            HStack(spacing: 8) {
                // Undo
                Button { vm.undo() } label: {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(vm.canUndo ? Theme.textPrimary : Theme.textSecondary)
                        .frame(width: 44, height: 44)
                        .background(Theme.surfaceHigh)
                        .clipShape(Circle())
                }
                .disabled(!vm.canUndo)

                // Export
                Button { vm.exportImage() } label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Theme.accentGradient)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    // MARK: - Image Canvas
    private var imageCanvas: some View {
        GeometryReader { geo in
            ZStack {
                Image(uiImage: vm.displayImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()

                if vm.activeTool == .retouch {
                    RetouchCanvas(vm: vm, size: geo.size)
                }
            }
        }
        .background(Color.black)
        .animation(.easeInOut(duration: 0.3), value: vm.displayImage)
    }

    // MARK: - Tool Selector
    private var toolSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(EditorTool.allCases) { tool in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            vm.activeTool = tool
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: tool.icon)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(vm.activeTool == tool
                                    ? Theme.accentGradient
                                    : LinearGradient(colors: [Theme.textSecondary], startPoint: .leading, endPoint: .trailing))

                            Text(tool.rawValue)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(vm.activeTool == tool ? Theme.accent : Theme.textSecondary)
                        }
                        .frame(width: 70, height: 56)
                        .background(
                            vm.activeTool == tool
                                ? Theme.accent.opacity(0.12)
                                : Color.clear
                        )
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 64)
        .background(Theme.surface)
    }

    // MARK: - Tool Panel
    @ViewBuilder
    private var toolPanel: some View {
        ZStack {
            Theme.surface.ignoresSafeArea(edges: .bottom)
            switch vm.activeTool {
            case .beauty:  BeautyToolView(vm: vm)
            case .makeup:  MakeupToolView(vm: vm)
            case .filter:  FilterToolView(vm: vm)
            case .adjust:  AdjustToolView(vm: vm)
            case .retouch: RetouchToolInfoView()
            case .reshape: ReshapeToolView(vm: vm)
            }
        }
    }

    // MARK: - Processing overlay
    private var processingOverlay: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack(spacing: 12) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(Theme.accent)
                    .scaleEffect(1.5)
                Text("Processando...")
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSecondary)
            }
        }
    }
}

// MARK: - Retouch Canvas (touch-to-heal)
private struct RetouchCanvas: View {
    let vm: EditorViewModel
    let size: CGSize
    @State private var brushRadius: CGFloat = 24

    var body: some View {
        Color.clear
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { val in
                        let imageSize = vm.displayImage.size
                        let scale = min(size.width / imageSize.width, size.height / imageSize.height)
                        let offsetX = (size.width  - imageSize.width  * scale) / 2
                        let offsetY = (size.height - imageSize.height * scale) / 2
                        let imgX = (val.location.x - offsetX) / scale
                        let imgY = (val.location.y - offsetY) / scale
                        vm.healBlemish(at: CGPoint(x: imgX, y: imgY), radius: brushRadius / scale)
                    }
            )
    }
}

// MARK: - Retouch Info
private struct RetouchToolInfoView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "hand.tap.fill")
                .font(.system(size: 32))
                .foregroundStyle(Theme.accentGradient)
            Text("Toque sobre manchas ou imperfeições\npara remover automaticamente")
                .font(.system(size: 13))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - Toast modifier
struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if isPresented {
                Text(message)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Theme.surfaceHigh)
                    .cornerRadius(24)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { isPresented = false }
                        }
                    }
            }
        }
        .animation(.spring(), value: isPresented)
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        modifier(ToastModifier(isPresented: isPresented, message: message))
    }
}
