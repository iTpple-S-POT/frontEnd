// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GlobalResource",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AllGlobalResource",
            targets: [
                "GlobalFonts",
            ]),
        
        // Fonts only
        .library(name: "GlobalFonts", targets: ["GlobalFonts"])
    ],
    dependencies: [
        .package(path: "../DefaultExtensions"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "GlobalFonts",
            dependencies: [
                .product(name: "DefaultExtensions", package: "DefaultExtensions"),
            ],
            resources: [
                .process("Resources/SUITE")
            ]
        )
    ]
)
