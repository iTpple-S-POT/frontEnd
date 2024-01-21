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
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CJMapkit",
            resources: [
                .process("Resources/Pot_anot")
            ],
            plugins: [
                
            ]
        )
    ]
)
