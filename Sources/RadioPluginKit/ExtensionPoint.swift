import Foundation

/// The out-of-process (third-party) tier. An installable plugin ships as a sandboxed,
/// crash-isolated ExtensionKit `.appex` that declares this extension point; the host
/// embeds its UI via `EXHostViewController` and talks to it over the typed channel below.
///
/// (Building the `.appex` requires an Xcode app-extension target — SwiftPM cannot produce
/// loadable extension bundles. See docs/EXTENSIONKIT.md.)
public enum RadioExtensionPoint {
    /// Value for the extension's `EXExtensionPointIdentifier` Info.plist key, and what
    /// the host browses for when discovering installed extensions.
    public static let identifier = "org.vu3esv.radiosuite.plugin"
}

/// Codable projection of a `PluginError` for sending across the process boundary
/// (the live `PluginError` carries non-Codable recovery closures; their titles travel,
/// and the host dispatches the chosen action back by index over the channel).
public struct PluginErrorInfo: Codable, Sendable {
    public var severity: String
    public var title: String
    public var message: String?
    public var recoveryActionTitles: [String]

    public init(severity: String, title: String, message: String? = nil,
                recoveryActionTitles: [String] = []) {
        self.severity = severity
        self.title = title
        self.message = message
        self.recoveryActionTitles = recoveryActionTitles
    }
}

/// Messages an out-of-process plugin sends to the host over the ExtensionKit channel.
public enum ExtensionToHostMessage: Codable, Sendable {
    case log(String)
    case report(PluginErrorInfo)
    case notify(PluginNotification)
    case setBadge(PluginBadge?)
    /// Serialized state in response to a `requestState`.
    case state(Data?)
}

/// Messages the host sends to an out-of-process plugin.
public enum HostToExtensionMessage: Codable, Sendable {
    case activate
    case deactivate
    case requestState
    case restoreState(Data)
    /// The user picked recovery action N from a previously reported error.
    case performRecoveryAction(Int)
}
