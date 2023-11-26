// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "KYNearbyService",
  defaultLocalization: "en",
  platforms: [
    .iOS("15.5"),
    .watchOS(.v6),
    .macOS(.v13),
  ],
  products: [
    .library(
      name: "KYNearbyService",
      targets: [
        "KYNearbyService",
      ]),
  ],
  dependencies: [
    .package(url: "https://github.com/Kjuly/KYLogger.git", branch: "main"),
  ],
  targets: [
    .target(
      name: "KYNearbyService",
      dependencies: [
        .product(name: "KYLogger", package: "KYLogger"),
      ],
      path: "KYNearbyService/Sources",
      resources: [
        .process("Resources/"),
      ]),
    .testTarget(
      name: "KYNearbyServiceTests",
      dependencies: [
        "KYNearbyService",
      ],
      path: "KYNearbyServiceTests"),
  ]
)
