// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "RadioPluginKit",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "RadioPluginKit", targets: ["RadioPluginKit"]),
        .library(name: "RadioPluginUI", targets: ["RadioPluginUI"]),
    ],
    targets: [
        .target(name: "RadioPluginKit", path: "Sources/RadioPluginKit"),
        .target(
            name: "RadioPluginUI",
            dependencies: ["RadioPluginKit"],
            path: "Sources/RadioPluginUI"
        ),
    ]
)
