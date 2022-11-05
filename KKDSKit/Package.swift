// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "KKDSKit",
  platforms: [
    .iOS(.v11)
  ],
  products: [
    .library(
      name: "KKDSKit",
      targets: ["KKDSKit"]
    )
  ],
  dependencies: [],
  targets: [
    .target(
      name: "KKDSKit",
      dependencies: [],
      resources: [.process("Resources")]
    ),
    .testTarget(
      name: "KKDSKitTests",
      dependencies: ["KKDSKit"])
  ]
)
