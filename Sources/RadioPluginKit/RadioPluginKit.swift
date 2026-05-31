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

/// Services the container injects into each plugin. Plugins must NOT touch
/// `UserDefaults.standard` directly — keys would collide across plugins that
/// share the container's process. Use `defaults(for:)` for isolated storage.
@MainActor public protocol PluginHost: AnyObject {
    func log(_ message: String, plugin: String)
    func defaults(for pluginID: String) -> UserDefaults
}

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
}

public extension RadioPlugin {
    func activate() {}
    func deactivate() {}
    var menuCommands: [PluginCommand] { [] }
    var settingsView: AnyView? { nil }
}
