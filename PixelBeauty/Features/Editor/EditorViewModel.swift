import SwiftUI
import Combine

@MainActor
final class EditorViewModel: ObservableObject {
    // MARK: - Source
    let originalImage: UIImage

    // MARK: - Published state
    @Published var displayImage: UIImage
    @Published var activeTool: EditorTool = .beauty
    @Published var isProcessing = false
    @Published var showExportSuccess = false

    // MARK: - Tool params
    @Published var beautyParams   = BeautyParams()
    @Published var makeupParams   = MakeupParams()
    @Published var adjustParams   = AdjustmentParams()
    @Published var reshapeParams  = ReshapeParams()
    @Published var activeFilter: FilterPreset = .natural
    @Published var filterIntensity: Float = 0.5
    @Published var filterEnabled = false

    // MARK: - History (undo)
    private var history: [UIImage] = []
    var canUndo: Bool { !history.isEmpty }

    init(image: UIImage) {
        self.originalImage = image
        self.displayImage  = image
    }

    // MARK: - Apply

    func applyBeauty() {
        guard beautyParams.smooth > 0 || beautyParams.whitenSkin > 0 else { return }
        process {
            var img = self.originalImage
            if self.beautyParams.smooth > 0 {
                img = ImageProcessor.shared.applySkinSmooth(to: img, intensity: self.beautyParams.smooth)
            }
            if self.beautyParams.whitenSkin > 0 {
                img = ImageProcessor.shared.applySkinTone(to: img, warmth: -self.beautyParams.whitenSkin, saturation: -self.beautyParams.whitenSkin * 0.3)
            }
            return img
        }
    }

    func applyMakeup() {
        process {
            var img = self.displayImage
            if self.makeupParams.lipOpacity > 0 {
                img = ImageProcessor.shared.applyLipColor(to: img, color: self.makeupParams.lipColor, opacity: self.makeupParams.lipOpacity)
            }
            if self.makeupParams.teethWhiten > 0 {
                img = ImageProcessor.shared.applyTeethWhiten(to: img, intensity: self.makeupParams.teethWhiten)
            }
            if self.makeupParams.eyeBrighten > 0 {
                img = ImageProcessor.shared.applyEyeBrighten(to: img, intensity: self.makeupParams.eyeBrighten)
            }
            return img
        }
    }

    func applyFilter() {
        guard filterEnabled else { return }
        process {
            ImageProcessor.shared.applyFilter(self.activeFilter, to: self.originalImage, intensity: self.filterIntensity)
        }
    }

    func applyAdjustments() {
        process {
            ImageProcessor.shared.applyAdjustments(to: self.originalImage, params: self.adjustParams)
        }
    }

    func applyReshape() {
        process {
            var img = self.displayImage
            if self.reshapeParams.slimFace > 0 {
                img = ImageProcessor.shared.applySlimFace(to: img, intensity: self.reshapeParams.slimFace)
            }
            return img
        }
    }

    func healBlemish(at point: CGPoint, radius: CGFloat) {
        let saved = displayImage
        history.append(saved)
        Task {
            isProcessing = true
            let result = await Task.detached(priority: .userInitiated) {
                ImageProcessor.shared.removeBlemish(from: saved, at: point, radius: radius)
            }.value
            displayImage = result
            isProcessing = false
        }
    }

    // MARK: - Undo
    func undo() {
        guard let prev = history.popLast() else { return }
        displayImage = prev
    }

    func reset() {
        history.removeAll()
        displayImage     = originalImage
        beautyParams     = BeautyParams()
        makeupParams     = MakeupParams()
        adjustParams     = AdjustmentParams()
        reshapeParams    = ReshapeParams()
        filterEnabled    = false
    }

    // MARK: - Export
    func exportImage() {
        UIImageWriteToSavedPhotosAlbum(displayImage, nil, nil, nil)
        showExportSuccess = true
    }

    // MARK: - Private
    private func process(_ operation: @escaping () -> UIImage) {
        let saved = displayImage
        history.append(saved)
        Task {
            isProcessing = true
            let result = await Task.detached(priority: .userInitiated) { operation() }.value
            displayImage = result
            isProcessing = false
        }
    }
}
