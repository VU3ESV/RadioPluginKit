import Foundation

/// Where a plugin runs.
public enum PluginIsolation: String, Codable, Sendable {
    /// Linked/loaded into the host process — fast, full fidelity, NO crash isolation.
    /// Reserved for first-party / vetted plugins.
    case inProcess = "in-process"
    /// Runs as a sandboxed, crash-isolated ExtensionKit `.appex`. The model for any
    /// third-party plugin.
    case outOfProcess = "out-of-process"
}

/// Declarative description of a plugin, mirroring its `plugin.json`. The host can
/// read this WITHOUT loading the plugin's code — safe for browsing, validation,
/// capability prompts, and compatibility checks.
///
/// `Codable` + `Sendable`: parsed from JSON and able to cross the ExtensionKit boundary.
public struct RadioPluginManifest: Codable, Sendable, Identifiable {
    /// Reverse-DNS identifier, e.g. "com.vendor.myrig".
    public var id: String
    /// Display name.
    public var name: String
    /// Plugin version (semantic).
    public var version: String
    /// `RadioPlugin` contract version this plugin targets (e.g. "1.1").
    public var sdkVersion: String
    /// Minimum host (suite) version required.
    public var minHostVersion: String
    /// Where the plugin runs.
    public var isolation: PluginIsolation
    /// Resources/permissions the plugin needs.
    public var capabilities: [PluginCapability]
    /// SF Symbol used in the sidebar/tabs (matches `PluginMetadata.systemImage`).
    public var systemImage: String
    public var author: String?
    public var homepage: String?
    /// Bundled icon resource name, if any.
    public var iconResource: String?

    public init(id: String, name: String, version: String,
                sdkVersion: String = RadioPluginSDK.version,
                minHostVersion: String = "1.0",
                isolation: PluginIsolation,
                capabilities: [PluginCapability] = [],
                systemImage: String = "app",
                author: String? = nil, homepage: String? = nil,
                iconResource: String? = nil) {
        self.id = id
        self.name = name
        self.version = version
        self.sdkVersion = sdkVersion
        self.minHostVersion = minHostVersion
        self.isolation = isolation
        self.capabilities = capabilities
        self.systemImage = systemImage
        self.author = author
        self.homepage = homepage
        self.iconResource = iconResource
    }

    /// Sidebar/tab identity derived from the manifest.
    public var metadata: PluginMetadata {
        PluginMetadata(id: id, title: name, systemImage: systemImage, version: version)
    }
}

/// SDK version constants for compatibility negotiation.
public enum RadioPluginSDK {
    /// Current contract version. Bumped on additive changes (minor) per the
    /// versioning policy in PLUGIN-PLATFORM.md.
    public static let version = "1.1"
}
