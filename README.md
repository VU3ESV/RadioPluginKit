# RadioPluginKit

Shared plugin contract for the [Amateur Radio Suite](https://github.com/VU3ESV/AmateurRadioApps)
container app. Both the container and each hosted radio app depend on this tiny
package so they agree on a single interface without knowing each other's internals.

## Contract

- **`RadioPlugin`** — what every hosted app implements: `metadata`, `makeRootView()`,
  `activate()` / `deactivate()`, `menuCommands`, `settingsView`.
- **`PluginHost`** — services the container injects into each plugin, including
  `defaults(for:)` for per-plugin (collision-free) `UserDefaults`.
- **`PluginMetadata`** / **`PluginCommand`** — sidebar/tab identity and routed menu items.

A hosted app conforms a single `public` adapter type to `RadioPlugin`; all of its
own views, view models, and networking stay `internal` to its module.

Requires macOS 14+.
