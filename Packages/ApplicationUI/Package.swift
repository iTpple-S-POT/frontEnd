// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ApplicationUI",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ApplicationUI",
            targets: ["ApplicationUI"]),
    ],
    dependencies: [
        .package(path: "../SplashUI"),
        .package(path: "../LoginUI"),
        .package(path: "../GlobalResource"),
        .package(path: "../MainScreenUI"),
        .package(path: "../UserInformationUI"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ApplicationUI",
            dependencies: [
                .product(name: "SplashUI", package: "SplashUI"),
                .product(name: "LoginUI", package: "LoginUI"),
                .product(name: "GlobalObjects", package: "GlobalResource"),
                .product(name: "MainScreenUI", package: "MainScreenUI"),
                .product(name: "UserInformationUI", package: "UserInformationUI"),
            ]
        ),
        .testTarget(
            name: "ApplicationUITests",
            dependencies: ["ApplicationUI"]),
    ]
)
