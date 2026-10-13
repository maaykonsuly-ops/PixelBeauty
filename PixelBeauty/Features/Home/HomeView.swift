import SwiftUI
import PhotosUI

struct HomeView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showEditor = false
    @State private var showCamera = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    headerView
                    Spacer()
                    heroSection
                    Spacer()
                    actionButtons
                        .padding(.bottom, 48)
                }
            }
            .navigationDestination(isPresented: $showEditor) {
                if let image = selectedImage {
                    EditorView(image: image)
                }
            }
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let img = UIImage(data: data) {
                    selectedImage = img
                    showEditor = true
                }
            }
        }
    }

    // MARK: - Header
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("PixelBeauty")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.accentGradient)
                Text("Editor de foto com IA")
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSecondary)
            }
            Spacer()
            Image(systemName: "sparkles")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Theme.accentGradient)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }

    // MARK: - Hero
    private var heroSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Theme.accent.opacity(0.08))
                    .frame(width: 200, height: 200)
                Circle()
                    .fill(Theme.accentAlt.opacity(0.05))
                    .frame(width: 260, height: 260)
                Image(systemName: "person.crop.circle.fill.badge.plus")
                    .font(.system(size: 72))
                    .foregroundStyle(Theme.accentGradient)
            }

            VStack(spacing: 8) {
                Text("Transforme suas fotos")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                Text("Retoques de beleza com IA, filtros e\nmaquiagem virtual — tudo grátis.")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: 12) {
            // Galeria
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Escolher da Galeria", systemImage: "photo.on.rectangle.angled")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: Theme.buttonHeight)
                    .background(Theme.accentGradient)
                    .cornerRadius(Theme.cornerRadius)
            }

            // Câmera
            Button {
                showCamera = true
            } label: {
                Label("Abrir Câmera", systemImage: "camera.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: Theme.buttonHeight)
                    .background(Theme.surfaceHigh)
                    .cornerRadius(Theme.cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.cornerRadius)
                            .stroke(Theme.divider, lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 24)
        .sheet(isPresented: $showCamera) {
            CameraView { image in
                selectedImage = image
                showCamera = false
                showEditor = true
            }
        }
    }
}
