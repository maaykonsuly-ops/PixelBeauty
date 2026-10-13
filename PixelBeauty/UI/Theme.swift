import SwiftUI

enum Theme {
    // MARK: - Colors
    static let background     = Color(hex: "#0D0D0D")
    static let surface        = Color(hex: "#1A1A1A")
    static let surfaceHigh    = Color(hex: "#262626")
    static let accent         = Color(hex: "#E040FB")   // purple-pink
    static let accentAlt      = Color(hex: "#7C4DFF")   // violet
    static let textPrimary    = Color.white
    static let textSecondary  = Color(hex: "#AAAAAA")
    static let divider        = Color(hex: "#2A2A2A")

    // MARK: - Gradients
    static let accentGradient = LinearGradient(
        colors: [Color(hex: "#E040FB"), Color(hex: "#7C4DFF")],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let toolbarGradient = LinearGradient(
        colors: [Color.black.opacity(0), Color.black.opacity(0.9)],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - Dimensions
    static let cornerRadius: CGFloat    = 16
    static let buttonHeight: CGFloat    = 52
    static let iconSize: CGFloat        = 24
    static let toolbarHeight: CGFloat   = 88
}

// MARK: - Color hex initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
