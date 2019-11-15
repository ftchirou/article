// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "articleCore",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "articleCore",
            targets: ["articleCore"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "articleCore",
            dependencies: []
        ),
        .testTarget(
            name: "articleCoreTests",
            dependencies: ["articleCore"]
        )
    ]
)
