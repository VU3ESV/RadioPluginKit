import Foundation

/// A message a plugin asks the host to surface. The host owns presentation
/// (toasts + a persistent list), rate-limiting, de-duplication, and — for system
/// delivery — a single `UNUserNotificationCenter` registration.
///
/// `Codable` + `Sendable` so it can cross the ExtensionKit boundary.
public struct PluginNotification: Codable, Sendable, Identifiable {
    public enum Level: String, Codable, Sendable { case info, success, warning, error }

    public var id: String
    public var level: Level
    public var title: String
    public var body: String?
    /// Request a system (Notification Center) notification in addition to the
    /// in-app toast. Requires the `.notifications` capability.
    public var requestsSystemDelivery: Bool

    public init(id: String = UUID().uuidString, level: Level, title: String,
                body: String? = nil, requestsSystemDelivery: Bool = false) {
        self.id = id
        self.level = level
        self.title = title
        self.body = body
        self.requestsSystemDelivery = requestsSystemDelivery
    }
}

/// Attention indicator a plugin can set on its sidebar/tab item; cleared on activation.
/// `Codable` so it can cross the ExtensionKit boundary.
public enum PluginBadge: Codable, Sendable, Equatable {
    case dot
    case count(Int)
    case text(String)
}
