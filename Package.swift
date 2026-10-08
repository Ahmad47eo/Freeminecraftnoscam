// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FreeMinecraftNoScam",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "FreeMinecraftNoScam", targets: ["FreeMinecraftNoScam"])],
    targets: [.target(name: "FreeMinecraftNoScam", path: "Sources")]
)
