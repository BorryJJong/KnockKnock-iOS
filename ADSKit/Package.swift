// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ADSKit",
    products: [
        .library(
            name: "ADSKit",
            targets: ["ADSKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ADSKit",
            dependencies: [],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "ADSKitTests",
            dependencies: ["ADSKit"]
        ),
    ]
)
