import SwiftUI
import RadioPluginKit

/// A small status pill (colored dot + label) themed by the host. Use for
/// connection state, mode, etc.
public struct StatusBadge: View {
    public enum Kind { case neutral, success, warning, danger }

    @Environment(\.radioTheme) private var theme
    private let text: String
    private let kind: Kind

    public init(_ text: String, kind: Kind = .neutral) {
        self.text = text
        self.kind = kind
    }

    private var color: Color {
        switch kind {
        case .neutral: return theme.textSecondary
        case .success: return theme.success
        case .warning: return theme.warning
        case .danger:  return theme.danger
        }
    }

    public var body: some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(text).font(.caption).foregroundStyle(theme.textPrimary)
        }
        .padding(.horizontal, 10).padding(.vertical, 5)
        .background(theme.surface, in: Capsule())
    }
}

/// An inline banner the host uses to surface a plugin-scoped message (mirrors
/// `PluginNotification.Level`). Plugins can also use it directly inside their pane.
public struct Banner: View {
    @Environment(\.radioTheme) private var theme
    private let level: PluginNotification.Level
    private let title: String
    private let message: String?

    public init(level: PluginNotification.Level, title: String, message: String? = nil) {
        self.level = level
        self.title = title
        self.message = message
    }

    private var tint: Color {
        switch level {
        case .info:    return theme.accent
        case .success: return theme.success
        case .warning: return theme.warning
        case .error:   return theme.danger
        }
    }

    private var symbol: String {
        switch level {
        case .info:    return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error:   return "xmark.octagon.fill"
        }
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: symbol).foregroundStyle(tint)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.callout.weight(.semibold)).foregroundStyle(theme.textPrimary)
                if let message {
                    Text(message).font(.caption).foregroundStyle(theme.textSecondary)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(theme.spacing)
        .background(theme.surface, in: RoundedRectangle(cornerRadius: theme.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: theme.cornerRadius).stroke(tint.opacity(0.4), lineWidth: 1)
        )
    }
}

/// Centered empty/placeholder state (icon + title + optional message + optional action).
public struct EmptyStateView: View {
    @Environment(\.radioTheme) private var theme
    private let systemImage: String
    private let title: String
    private let message: String?
    private let actionTitle: String?
    private let action: (() -> Void)?

    public init(systemImage: String, title: String, message: String? = nil,
                actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.systemImage = systemImage
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        VStack(spacing: theme.spacing) {
            Image(systemName: systemImage)
                .font(.system(size: 42)).foregroundStyle(theme.textSecondary)
            Text(title).font(.title3.weight(.semibold)).foregroundStyle(theme.textPrimary)
            if let message {
                Text(message).font(.callout).foregroundStyle(theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent).tint(theme.accent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(32)
    }
}
