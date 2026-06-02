import Foundation

/// A resource or permission a plugin declares up front in its manifest. The host
/// maps each capability to the minimal entitlement / permission prompt and surfaces
/// the set to the user at install time. A plugin gets no access it didn't declare.
///
/// `Codable` + `Sendable` so it can be read from `plugin.json` and cross the
/// ExtensionKit process boundary for out-of-process plugins.
public enum PluginCapability: String, Codable, Sendable, CaseIterable {
    /// Outbound network connections (HTTP, WebSocket, TCP client).
    case networkClient = "network.client"
    /// Inbound listeners / servers binding local ports.
    case networkListener = "network.listener"
    /// Bonjour / mDNS service discovery.
    case bonjour = "bonjour"
    /// Serial port (USB-serial) access.
    case serial = "serial"
    /// USB HID device access.
    case usbHID = "usb.hid"
    /// Posting in-app and/or system notifications.
    case notifications = "notifications"

    /// Short human-readable label for permission prompts / the Plugin Browser.
    public var displayName: String {
        switch self {
        case .networkClient:   return "Network (outbound)"
        case .networkListener: return "Network (listen)"
        case .bonjour:         return "Local network discovery"
        case .serial:          return "Serial port"
        case .usbHID:          return "USB device"
        case .notifications:   return "Notifications"
        }
    }
}
