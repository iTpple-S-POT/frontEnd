// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DefaultExtensions",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DefaultExtensions",
            targets: ["DefaultExtensions"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DefaultExtensions"),
        .testTarget(
            name: "DefaultExtensionsTests",
            dependencies: ["DefaultExtensions"]),
    ]
)
