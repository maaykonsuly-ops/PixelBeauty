import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit
import Vision

/// Handles all image processing: beauty, filters, makeup, adjustments.
final class ImageProcessor {
    static let shared = ImageProcessor()
    private let context = CIContext(options: [.useSoftwareRenderer: false])

    // MARK: - Skin Smoothing (Beauty)
    /// Smooths skin while preserving edges using a bilateral-like approach.
    func applySkinSmooth(to image: UIImage, intensity: Float) -> UIImage {
        guard let ci = CIImage(image: image) else { return image }
        let blur = ci.applyingFilter("CIGaussianBlur", parameters: ["inputRadius": intensity * 8])
        let sharpened = ci.applyingFilter("CIUnsharpMask", parameters: [
            "inputRadius": 2.5,
            "inputIntensity": 0.5
        ])
        let blended = blur.applyingFilter("CIBlendWithMask", parameters: [
            kCIInputBackgroundImageKey: sharpened,
            kCIInputMaskImageKey: generateSkinMask(from: ci)
        ])
        return render(blended, original: image)
    }

    // MARK: - Skin Tone Adjust
    func applySkinTone(to image: UIImage, warmth: Float, saturation: Float) -> UIImage {
        guard let ci = CIImage(image: image) else { return image }
        let filter = CIFilter.vibrance()
        filter.inputImage = ci
        filter.amount = saturation
        guard let out = filter.outputImage else { return image }
        let warm = out.applyingFilter("CITemperatureAndTint", parameters: [
            "inputNeutral": CIVector(x: CGFloat(6500 - warmth * 1000), y: 0),
            "inputTargetNeutral": CIVector(x: 6500, y: 0)
        ])
        return render(warm, original: image)
    }

    // MARK: - Blemish Removal (spot heal)
    func removeBlemish(from image: UIImage, at point: CGPoint, radius: CGFloat) -> UIImage {
        guard let ci = CIImage(image: image) else { return image }
        let scale = image.scale
        let flippedY = image.size.height - point.y
        let ciPoint = CGPoint(x: point.x * scale, y: flippedY * scale)
        let blurred = ci.applyingFilter("CIGaussianBlur", parameters: ["inputRadius": radius * scale])
        let mask = generateCircleMask(center: ciPoint, radius: radius * scale, imageSize: ci.extent.size)
        let healed = blurred.applyingFilter("CIBlendWithMask", parameters: [
            kCIInputBackgroundImageKey: ci,
            kCIInputMaskImageKey: mask
        ])
        return render(healed, original: image)
    }

    // MARK: - Makeup: Lip Color
    func applyLipColor(to image: UIImage, color: UIColor, opacity: Float) -> UIImage {
        guard let ci = CIImage(image: image) else { return image }
        let (r, g, b, _) = color.components
        let colorOverlay = CIImage(color: CIColor(red: r, green: g, blue: b, alpha: CGFloat(opacity)))
            .cropped(to: ci.extent)
        let blended = colorOverlay.applyingFilter("CIMultiplyBlendMode", parameters: [
            kCIInputBackgroundImageKey: ci
        ])
        return render(blended, original: image)
    }

    // MARK: - Filters
    func applyFilter(_ name: FilterPreset, to image: UIImage, intensity: Float) -> UIImage {
        guard let ci = CIImage(image: image) else { return image }
        let filtered: CIImage
        switch name {
        case .natural:
            filtered = applyNatural(ci, intensity: intensity)
        case .vivid:
            filtered = applyVivid(ci, intensity: intensity)
        case .warm:
            filtered = applyWarm(ci, intensity: intensity)
        case .cool:
            filtered = applyCool(ci, intensity: intensity)
        case .fadeLight:
            filtered = applyFade(ci, intensity: intensity, bright: true)
        case .fadeDark:
            filtered = applyFade(ci, intensity: intensity, bright: false)
        case .noir:
            filtered = applyNoir(ci, intensity: intensity)
        case .chrome:
            filtered = applyChrome(ci, intensity: intensity)
        }
        return render(filtered, original: image)
    }

    // MARK: - Adjustments
    func applyAdjustments(to image: UIImage, params: AdjustmentParams) -> UIImage {
        guard var ci = CIImage(image: image) else { return image }

        ci = ci.applyingFilter("CIColorControls", parameters: [
            "inputBrightness": params.brightness,
            "inputContrast":   1.0 + params.contrast,
            "inputSaturation": 1.0 + params.saturation
        ])
        ci = ci.applyingFilter("CIExposureAdjust", parameters: [
            "inputEV": params.exposure
        ])
        ci = ci.applyingFilter("CIHighlightShadowAdjust", parameters: [
            "inputHighlightAmount": 1.0 + params.highlights,
            "inputShadowAmount":    params.shadows
        ])
        ci = ci.applyingFilter("CISharpenLuminance", parameters: [
            "inputSharpness": params.sharpness
        ])
        if params.vignette > 0 {
            ci = ci.applyingFilter("CIVignette", parameters: [
                "inputIntensity": params.vignette * 2,
                "inputRadius":    1.5
            ])
        }
        return render(ci, original: image)
    }

    // MARK: - Face Reshape (mesh warp)
    func applySlimFace(to image: UIImage, intensity: Float) -> UIImage {
        guard let ci = CIImage(image: image) else { return image }
        // CIBumpDistortion simulates face slim on center
        let center = CIVector(x: ci.extent.midX, y: ci.extent.midY)
        let filter = ci.applyingFilter("CIBumpDistortion", parameters: [
            "inputCenter": center,
            "inputRadius": ci.extent.width * 0.45,
            "inputScale":  -Double(intensity) * 0.15
        ])
        return render(filter, original: image)
    }

    // MARK: - Teeth Whitening
    func applyTeethWhiten(to image: UIImage, intensity: Float) -> UIImage {
        guard let ci = CIImage(image: image) else { return image }
        let whitened = ci.applyingFilter("CIColorMatrix", parameters: [
            "inputRVector":  CIVector(x: 1, y: 0, z: 0, w: 0),
            "inputGVector":  CIVector(x: 0, y: 1, z: 0, w: 0),
            "inputBVector":  CIVector(x: 0, y: 0, z: 1, w: 0),
            "inputBiasVector": CIVector(x: CGFloat(intensity) * 0.12,
                                        y: CGFloat(intensity) * 0.12,
                                        z: CGFloat(intensity) * 0.12,
                                        w: 0)
        ])
        return render(whitened, original: image)
    }

    // MARK: - Eye Brighten
    func applyEyeBrighten(to image: UIImage, intensity: Float) -> UIImage {
        guard let ci = CIImage(image: image) else { return image }
        let brightened = ci.applyingFilter("CIColorControls", parameters: [
            "inputBrightness": CGFloat(intensity) * 0.15,
            "inputContrast":   1.0 + CGFloat(intensity) * 0.1,
            "inputSaturation": 1.0 + CGFloat(intensity) * 0.1
        ])
        return render(brightened, original: image)
    }

    // MARK: - Private helpers

    private func generateSkinMask(from image: CIImage) -> CIImage {
        // Creates a warm-tone mask to roughly isolate skin areas
        let hueFilter = image.applyingFilter("CIHueAdjust", parameters: ["inputAngle": 0])
        return hueFilter.applyingFilter("CIColorMatrix", parameters: [
            "inputRVector":  CIVector(x: 1.0, y: 0,   z: 0,   w: 0),
            "inputGVector":  CIVector(x: 0,   y: 0.7, z: 0,   w: 0),
            "inputBVector":  CIVector(x: 0,   y: 0,   z: 0.5, w: 0),
            "inputBiasVector": CIVector(x: 0, y: 0,   z: 0,   w: 0)
        ])
    }

    private func generateCircleMask(center: CGPoint, radius: CGFloat, imageSize: CGSize) -> CIImage {
        let r = CIVector(x: center.x, y: center.y)
        return CIImage(color: CIColor.white)
            .cropped(to: CGRect(origin: .zero, size: imageSize))
            .applyingFilter("CIRadialGradient", parameters: [
                "inputCenter": r,
                "inputRadius0": radius * 0.5,
                "inputRadius1": radius,
                "inputColor0":  CIColor.white,
                "inputColor1":  CIColor.black
            ])
            .cropped(to: CGRect(origin: .zero, size: imageSize))
    }

    private func render(_ ci: CIImage, original: UIImage) -> UIImage {
        guard let cgImage = context.createCGImage(ci, from: ci.extent) else { return original }
        return UIImage(cgImage: cgImage, scale: original.scale, orientation: original.imageOrientation)
    }

    // MARK: - Filter implementations
    private func applyNatural(_ ci: CIImage, intensity: Float) -> CIImage {
        ci.applyingFilter("CIColorControls", parameters: [
            "inputSaturation": 1.0 + Double(intensity) * 0.15,
            "inputContrast":   1.0 + Double(intensity) * 0.05
        ])
    }

    private func applyVivid(_ ci: CIImage, intensity: Float) -> CIImage {
        ci.applyingFilter("CIColorControls", parameters: [
            "inputSaturation": 1.0 + Double(intensity) * 0.6,
            "inputContrast":   1.0 + Double(intensity) * 0.2
        ])
    }

    private func applyWarm(_ ci: CIImage, intensity: Float) -> CIImage {
        ci.applyingFilter("CITemperatureAndTint", parameters: [
            "inputNeutral":       CIVector(x: 6500, y: 0),
            "inputTargetNeutral": CIVector(x: CGFloat(6500 - intensity * 2000), y: 0)
        ])
    }

    private func applyCool(_ ci: CIImage, intensity: Float) -> CIImage {
        ci.applyingFilter("CITemperatureAndTint", parameters: [
            "inputNeutral":       CIVector(x: 6500, y: 0),
            "inputTargetNeutral": CIVector(x: CGFloat(6500 + intensity * 2000), y: 0)
        ])
    }

    private func applyFade(_ ci: CIImage, intensity: Float, bright: Bool) -> CIImage {
        ci.applyingFilter("CIColorControls", parameters: [
            "inputBrightness": bright ? Double(intensity) * 0.2 : -Double(intensity) * 0.1,
            "inputContrast":   1.0 - Double(intensity) * 0.25,
            "inputSaturation": 1.0 - Double(intensity) * 0.3
        ])
    }

    private func applyNoir(_ ci: CIImage, intensity: Float) -> CIImage {
        let mono = ci.applyingFilter("CIColorMonochrome", parameters: [
            "inputColor":     CIColor.gray,
            "inputIntensity": Double(intensity)
        ])
        return mono.applyingFilter("CIColorControls", parameters: [
            "inputContrast": 1.0 + Double(intensity) * 0.3
        ])
    }

    private func applyChrome(_ ci: CIImage, intensity: Float) -> CIImage {
        ci.applyingFilter("CIPhotoEffectChrome")
            .applyingFilter("CIColorControls", parameters: [
                "inputSaturation": 1.0 - (1 - Double(intensity)) * 0.8
            ])
    }
}

// MARK: - UIColor helper
extension UIColor {
    var components: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
}
