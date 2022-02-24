// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ALTENSwiftUtilities",
    platforms: [.iOS(.v13), .macOS(.v12), .tvOS(.v13), .watchOS(.v7)],
    products: [
        .library(
            name: "ALTENSwiftUtilities",
            targets: ["ALTENSwiftUtilities"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ALTENSwiftUtilities",
            dependencies: []),
        .testTarget(
            name: "ALTENSwiftUtilitiesTests",
            dependencies: ["ALTENSwiftUtilities"]),
    ]
)
