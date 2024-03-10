// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoginUI",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LoginUI",
            targets: ["LoginUI"]),
    ],
    dependencies: [
        .package(name: "DefaultExtensions", path: "../DefaultExtensions"),
        .package(name: "GlobalResource", path: "../GlobalResource"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", .upToNextMajor(from: "2.18.2")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LoginUI",
            dependencies: [
                .product(name: "DefaultExtensions", package: "DefaultExtensions"),
                .product(name: "GlobalFonts", package: "GlobalResource"),
                .product(name: "GlobalObjects", package: "GlobalResource"),
                .product(name: "KakaoSDK", package: "kakao-ios-sdk"),
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "LoginUITests",
            dependencies: ["LoginUI"]),
    ]
)
