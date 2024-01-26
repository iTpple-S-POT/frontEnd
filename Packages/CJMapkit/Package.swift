// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "CJMapkit",
    defaultLocalization: "ko",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CJMapkit",
            targets: ["CJMapkit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", exact: .init(0, 51, 0)),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.2.0"),
        .package(path: "../DefaultExtensions"),
        .package(path: "../GlobalResource"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CJMapkit",
            dependencies: [
                .product(name: "DefaultExtensions", package: "DefaultExtensions"),
                .product(name: "GlobalResource", package: "GlobalResource"),
                .product(name: "Lottie", package: "lottie-ios"),
            ],
            resources: [
                .process("Resources")
            ],
            plugins: [
                
            ]
        )
    ]
)
