import SwiftUI

/// Static description of a plugin, surfaced by the container in the sidebar/tab bar.
public struct PluginMetadata: Identifiable, Sendable {
    public let id: String           // stable, e.g. "lp700"
    public let title: String        // sidebar / tab label
    public let systemImage: String  // SF Symbol
    public let version: String

    public init(id: String, title: String, systemImage: String, version: String) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
        self.version = version
    }
}

/// A menu item a plugin contributes; the container surfaces it and routes it to
/// whichever plugin is currently active.
public struct PluginCommand: Identifiable {
    public let id: String
    public let title: String
    public let shortcut: KeyboardShortcut?
    public let action: @MainActor () -> Void

    public init(id: String, title: String, shortcut: KeyboardShortcut? = nil,
                action: @escaping @MainActor () -> Void) {
        self.id = id
        self.title = title
        self.shortcut = shortcut
        self.action = action
    }
}

/// Services the container injects into each plugin (the plugin's "context"). Plugins
/// must NOT touch `UserDefaults.standard` directly — keys would collide across plugins
/// that share the container's process. Use `defaults(for:)` for isolated storage.
///
/// The `report` / `notify` / `setBadge` members have default no-op implementations so
/// adopting them is optional and non-breaking; the host overrides them to route to its
/// error surface, notification center, and sidebar badges.
@MainActor public protocol PluginHost: AnyObject {
    func log(_ message: String, plugin: String)
    func defaults(for pluginID: String) -> UserDefaults

    /// Report a typed error; the host presents it (inline banner / notification) and logs it.
    func report(_ error: PluginError, from pluginID: String)
    /// Ask the host to surface a notification (toast + list, optionally system delivery).
    func notify(_ notification: PluginNotification, from pluginID: String)
    /// Set or clear the attention badge on the plugin's sidebar/tab item.
    func setBadge(_ badge: PluginBadge?, for pluginID: String)
}

public extension PluginHost {
    func report(_ error: PluginError, from pluginID: String) {
        log("error[\(error.severity.rawValue)]: \(error.title)", plugin: pluginID)
    }
    func notify(_ notification: PluginNotification, from pluginID: String) {
        log("notify[\(notification.level.rawValue)]: \(notification.title)", plugin: pluginID)
    }
    func setBadge(_ badge: PluginBadge?, for pluginID: String) {}
}

/// Vocabulary alias: a plugin's `host` is its context (services + reporting).
public typealias PluginContext = PluginHost

/// The contract every hosted app implements. Internals of each app stay private
/// to their own module; only the conforming type is `public`.
@MainActor public protocol RadioPlugin: AnyObject {
    static var metadata: PluginMetadata { get }
    init(host: PluginHost)

    /// The app's UI, type-erased so the container needs no knowledge of internals.
    func makeRootView() -> AnyView

    /// Tab became visible. Default policy: resume/connect. Connections may be
    /// started here OR at construction for background-critical plugins.
    func activate()

    /// Tab hidden. Default policy: keep connections live (no-op). Override only
    /// for genuinely tab-bound cost. Background-critical work must NOT stop here.
    func deactivate()

    var menuCommands: [PluginCommand] { get }
    var settingsView: AnyView? { get }

    /// Declarative manifest (capabilities, isolation, versions). Optional for
    /// first-party in-process plugins; required for installable/third-party ones.
    static var manifest: RadioPluginManifest? { get }

    /// Serialize state for restoration after a restart/crash. `nil` = nothing to save.
    func persistState() -> Data?
    /// Restore previously persisted state (called before `activate()` when available).
    func restoreState(_ data: Data)
}

public extension RadioPlugin {
    func activate() {}
    func deactivate() {}
    var menuCommands: [PluginCommand] { [] }
    var settingsView: AnyView? { nil }
    static var manifest: RadioPluginManifest? { nil }
    func persistState() -> Data? { nil }
    func restoreState(_ data: Data) {}
}
