import SwiftUI

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
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    func toHex(includeAlpha: Bool = true) -> String? {
#if os(iOS)
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if includeAlpha {
            return String(format: "%02X%02X%02X%02X",
                          Int(alpha * 255),
                          Int(red * 255),
                          Int(green * 255),
                          Int(blue * 255))
        } else {
            return String(format: "%02X%02X%02X",
                          Int(red * 255),
                          Int(green * 255),
                          Int(blue * 255))
        }
#else
        return nil // macOS/tvOS/watchOS: Extend similarly using NSColor if needed
#endif
    }
    
    init(hex: String, alpha: Double) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3:
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: alpha
        )
    }
    
    func darker(by percentage: CGFloat = 0.2) -> Color {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return Color(hue: hue,
                     saturation: saturation,
                     brightness: max(brightness - percentage, 0.0),
                     opacity: alpha)
    }
    
    static func random() -> Color {
        var remaining = 255.0
        let r = Double.random(in: 0...1) * remaining
        remaining -= r
        let g = Double.random(in: 0...1) * remaining
        remaining -= g
        let b = remaining

        return Color(red: r / 255, green: g / 255, blue: b / 255)
    }
}
