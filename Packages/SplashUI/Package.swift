// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SplashUI",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SplashUI",
            targets: ["SplashUI"]
        ),
    ],
    dependencies: [
        .package(name: "DefaultExtensions", path: "../DefaultExtensions"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SplashUI",
            dependencies: [
                .byNameItem(name: "DefaultExtensions", condition: .none),
            ],
            resources: [
                .process("Resources/splash_logo.png")
            ]
        ),
        .testTarget(
            name: "SplashUITests",
            dependencies: ["SplashUI"]),
    ]
)
