// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "article",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .executable(
            name: "article",
            targets: ["article"]
        ),
    ],
    dependencies: [
        .package(path: "../articleCore")
    ],
    targets: [
        .target(
            name: "article",
            dependencies: ["articleCore"]
        )
    ]
)
