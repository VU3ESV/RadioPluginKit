import SwiftUI

/// Design-system tokens the host injects into every plugin's view tree so all tabs
/// look coherent and follow the host's appearance. Plugins read these (directly or
/// via the components in this module) instead of hard-coding colors/metrics.
public struct RadioTheme {
    public var accent: Color
    public var background: Color
    public var surface: Color
    public var textPrimary: Color
    public var textSecondary: Color
    public var success: Color
    public var warning: Color
    public var danger: Color
    public var cornerRadius: CGFloat
    public var spacing: CGFloat

    public init(accent: Color, background: Color, surface: Color,
                textPrimary: Color, textSecondary: Color,
                success: Color, warning: Color, danger: Color,
                cornerRadius: CGFloat = 10, spacing: CGFloat = 12) {
        self.accent = accent
        self.background = background
        self.surface = surface
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.success = success
        self.warning = warning
        self.danger = danger
        self.cornerRadius = cornerRadius
        self.spacing = spacing
    }

    /// The LP-500/700 dark-LCD palette (teal/blue on near-black) — the suite default.
    public static let dark = RadioTheme(
        accent:        Color(red: 0x6c/255, green: 0xb6/255, blue: 0xff/255),
        background:    Color(red: 0x06/255, green: 0x09/255, blue: 0x0c/255),
        surface:       Color(red: 0x14/255, green: 0x1b/255, blue: 0x25/255),
        textPrimary:   Color(red: 0xe8/255, green: 0xee/255, blue: 0xf6/255),
        textSecondary: Color(red: 0x8a/255, green: 0x97/255, blue: 0xa8/255),
        success:       Color(red: 0x4a/255, green: 0xd6/255, blue: 0xa3/255),
        warning:       Color(red: 0xf2/255, green: 0xb8/255, blue: 0x4b/255),
        danger:        Color(red: 0xff/255, green: 0x6b/255, blue: 0x6b/255)
    )
}

private struct RadioThemeKey: EnvironmentKey {
    static let defaultValue = RadioTheme.dark
}

public extension EnvironmentValues {
    var radioTheme: RadioTheme {
        get { self[RadioThemeKey.self] }
        set { self[RadioThemeKey.self] = newValue }
    }
}

public extension View {
    /// Inject a `RadioTheme` into this view tree. The host calls this around each
    /// plugin's root view; plugins/components read `@Environment(\.radioTheme)`.
    func radioTheme(_ theme: RadioTheme) -> some View {
        environment(\.radioTheme, theme)
    }
}
