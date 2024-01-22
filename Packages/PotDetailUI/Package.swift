// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PotDetailUI",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PotDetailUI",
            targets: ["PotDetailUI"]),
    ],
    dependencies: [
        .package(path: "../GlobalResource"),
        .package(path: "../DefaultExtensions"),
        .package(path: "../CJMapkit"),
        .package(path: "../CJPhotoCollection"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PotDetailUI",
            dependencies: [
                .product(name: "GlobalUIComponents", package: "GlobalResource"),
                .product(name: "DefaultExtensions", package: "DefaultExtensions"),
                .product(name: "CJMapkit", package: "CJMapkit"),
                .product(name: "CJPhotoCollection", package: "CJPhotoCollection"),
            ],
            resources: [
            ]
        ),
        .testTarget(
            name: "PotDetailUITests",
            dependencies: ["PotDetailUI"]),
    ]
)

