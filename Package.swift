// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "RadioPluginKit",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "RadioPluginKit", targets: ["RadioPluginKit"]),
    ],
    targets: [
        .target(name: "RadioPluginKit", path: "Sources/RadioPluginKit"),
    ]
)
