import Foundation
import UIKit

// MARK: - Editor Tools
enum EditorTool: String, CaseIterable, Identifiable {
    case beauty    = "Beauty"
    case makeup    = "Maquiagem"
    case filter    = "Filtros"
    case adjust    = "Ajustes"
    case retouch   = "Retocar"
    case reshape   = "Reshape"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .beauty:  return "sparkles.rectangle.stack"
        case .makeup:  return "paintpalette.fill"
        case .filter:  return "camera.filters"
        case .adjust:  return "slider.horizontal.3"
        case .retouch: return "bandage.fill"
        case .reshape: return "person.crop.artframe"
        }
    }
}

// MARK: - Filter Presets
enum FilterPreset: String, CaseIterable, Identifiable {
    case natural   = "Natural"
    case vivid     = "Vivid"
    case warm      = "Warm"
    case cool      = "Cool"
    case fadeLight = "Fade Light"
    case fadeDark  = "Fade Dark"
    case noir      = "Noir"
    case chrome    = "Chrome"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .natural:   return "🌿"
        case .vivid:     return "🌈"
        case .warm:      return "☀️"
        case .cool:      return "❄️"
        case .fadeLight: return "☁️"
        case .fadeDark:  return "🌑"
        case .noir:      return "🎞️"
        case .chrome:    return "✨"
        }
    }
}

// MARK: - Adjustment Parameters
struct AdjustmentParams {
    var brightness: Double = 0.0    // -1 to +1
    var contrast:   Double = 0.0    // -1 to +1
    var saturation: Double = 0.0    // -1 to +1
    var exposure:   Double = 0.0    // -2 to +2 EV
    var highlights: Double = 0.0    // -1 to +1
    var shadows:    Double = 0.0    // -1 to +1
    var sharpness:  Double = 0.0    // 0 to 1
    var vignette:   Double = 0.0    // 0 to 1
}

// MARK: - Beauty Parameters
struct BeautyParams {
    var smooth:     Float = 0.0    // 0-1
    var whitenSkin: Float = 0.0    // 0-1
    var brighten:   Float = 0.0    // 0-1
}

// MARK: - Makeup Parameters
struct MakeupParams {
    var lipColor:       UIColor = .red
    var lipOpacity:     Float   = 0.0
    var teethWhiten:    Float   = 0.0
    var eyeBrighten:    Float   = 0.0
}

// MARK: - Reshape Parameters
struct ReshapeParams {
    var slimFace:   Float = 0.0   // 0-1
    var bigEyes:    Float = 0.0   // 0-1
    var slimNose:   Float = 0.0   // 0-1
}
