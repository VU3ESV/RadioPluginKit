import Foundation

/// A recovery affordance the host renders as a button next to an error
/// (e.g. "Retry", "Reconnect", "Open Settings").
@MainActor
public struct PluginRecoveryAction: Identifiable {
    public let id: String
    public let title: String
    public let handler: () -> Void

    public init(id: String = UUID().uuidString, title: String, handler: @escaping () -> Void) {
        self.id = id
        self.title = title
        self.handler = handler
    }
}

/// A typed error a plugin reports to the host via `PluginHost.report(_:)`. The host
/// decides presentation (an inline banner in the plugin's pane, or a global
/// notification) — plugins never show raw alerts themselves.
@MainActor
public struct PluginError: Error {
    public enum Severity: String, Sendable {
        /// Transient; the plugin keeps working (e.g. a single failed poll).
        case recoverable
        /// The plugin can't function until resolved.
        case fatal
        /// A required capability/permission was denied.
        case permission
        /// Lost connection to the device/server.
        case connectivity
    }

    public var severity: Severity
    public var title: String
    public var message: String?
    public var recoveryActions: [PluginRecoveryAction]

    public init(severity: Severity, title: String, message: String? = nil,
                recoveryActions: [PluginRecoveryAction] = []) {
        self.severity = severity
        self.title = title
        self.message = message
        self.recoveryActions = recoveryActions
    }
}
