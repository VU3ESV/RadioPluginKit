# RadioPluginKit

Shared plugin contract for the [Amateur Radio Suite](https://github.com/VU3ESV/AmateurRadioSuite)
container app. Both the container and each hosted radio app depend on this tiny
package so they agree on a single interface without knowing each other's internals.

## Contract

The package is intentionally small and **semantically versioned** (`RadioPluginSDK.version`,
currently `1.2`). It splits into two products: the **`RadioPluginKit`** contract and the
**`RadioPluginUI`** design system.

**`RadioPluginKit`**

- **`RadioPlugin`** — what every hosted app implements: `metadata`, `makeRootView()`,
  `activate()` / `deactivate()`, `menuCommands`, `settingsView`, and `persistState()` /
  `restoreState(_:)` for restart and crash recovery. Most members have default
  implementations, so a minimal plugin only provides `metadata`, `init(host:)`, and
  `makeRootView()`.
- **`PluginHost`** (aka `PluginContext`) — services the container injects into each plugin:
  `log`, `defaults(for:)` for per-plugin (collision-free) `UserDefaults`, and the optional
  `report` / `notify` / `setBadge` hooks (default no-ops) that drive the host's error banner,
  notification feed, and sidebar/tab badges.
- **`PluginMetadata`** / **`PluginCommand`** — sidebar/tab identity and routed menu items.
- **`RadioPluginManifest`** + **`PluginCapability`** — a `Codable`/`Sendable` mirror of
  `plugin.json` (id, name, versions, isolation, declared capabilities such as `network.client`,
  `serial`, `usb.hid`, `notifications`) the host can read **without loading code**.
- **`PluginError`** / **`PluginNotification`** / **`PluginBadge`** — typed error reporting (with
  host-rendered recovery actions), user-facing notifications, and attention indicators.
- **`RadioExtensionPoint`** + channel messages — the out-of-process (ExtensionKit) contract for
  sandboxed, crash-isolated plugins.

**`RadioPluginUI`**

- A shared SwiftUI design system (`RadioTheme` + components) the host injects so first- and
  third-party plugins stay visually coherent.

A hosted app conforms a single `public` adapter type to `RadioPlugin`; all of its
own views, view models, and networking stay `internal` to its module.

## Developer guide

See **[ARCHITECTURE.md](ARCHITECTURE.md)** for the full, illustrated guide: how the
Amateur Radio Suite and its plugin architecture work, the two-tier (in-process /
out-of-process) model, the plugin lifecycle, and a step-by-step checklist of exactly
what an application must do to be hosted as a plugin.

To package an existing app as an installable out-of-process plugin (ExtensionKit `.appex`
+ `.radioplugin` + catalog entry), follow **[CONVERTING-A-PLUGIN.md](CONVERTING-A-PLUGIN.md)**
— a copy-pasteable playbook with **LP-700** as the worked reference.

Requires macOS 14+.
