// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DynamicTableView",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "DynamicTableView",
            targets: ["DynamicTableView"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DynamicTableView",
            dependencies: []),
        .testTarget(
            name: "DynamicTableViewTests",
            dependencies: ["DynamicTableView"]),
    ]
)
