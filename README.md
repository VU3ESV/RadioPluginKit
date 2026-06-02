# RadioPluginKit

Shared plugin contract for the [Amateur Radio Suite](https://github.com/VU3ESV/AmateurRadioSuite)
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

## Developer guide

See **[ARCHITECTURE.md](ARCHITECTURE.md)** for the full, illustrated guide: how the
Amateur Radio Suite and its plugin architecture work, the two-tier (in-process /
out-of-process) model, the plugin lifecycle, and a step-by-step checklist of exactly
what an application must do to be hosted as a plugin.

To package an existing app as an installable out-of-process plugin (ExtensionKit `.appex`
+ `.radioplugin` + catalog entry), follow **[CONVERTING-A-PLUGIN.md](CONVERTING-A-PLUGIN.md)**
— a copy-pasteable playbook with **LP-700** as the worked reference.

Requires macOS 14+.
