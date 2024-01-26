// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MainScreenUI",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MainScreenUI",
            targets: ["MainScreenUI"]),
    ],
    dependencies: [
        .package(path: "../GlobalResource"),
        .package(path: "../DefaultExtensions"),
        .package(path: "../CJMapkit"),
        .package(path: "../CJPhotoCollection"),
        .package(path: "../PotDetailUI"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MainScreenUI",
            dependencies: [
                .product(name: "GlobalResource", package: "GlobalResource"),
                .product(name: "DefaultExtensions", package: "DefaultExtensions"),
                .product(name: "CJMapkit", package: "CJMapkit"),
                .product(name: "CJPhotoCollection", package: "CJPhotoCollection"),
                .product(name: "PotDetailUI", package: "PotDetailUI"),
            ],
            resources: [
                .process("Resources/TitlePart"),
                .process("Resources/Tags"),
                .process("Resources/Tab"),
                .process("Resources/DetailPart"),
                .process("Resources"),

            ]
        ),
        .testTarget(
            name: "MainScreenUITests",
            dependencies: ["MainScreenUI"]),
    ]
)
