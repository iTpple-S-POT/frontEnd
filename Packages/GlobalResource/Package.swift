// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GlobalResource",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GlobalResource",
            targets: [
                "GlobalFonts",
                "GlobalObjects",
                "GlobalUIComponents",
            ]),
        
        // Fonts only
        .library(name: "GlobalFonts", targets: ["GlobalFonts"]),
        
        // UIComponents only
        .library(name: "GlobalUIComponents", targets: ["GlobalUIComponents"]),
        
        // Object only
        .library(name: "GlobalObjects", targets: ["GlobalObjects"]),
    ],
    dependencies: [
        .package(path: "../DefaultExtensions"),
        .package(path: "../Persistence"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: .init(5, 7, 1)),
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
        ),
        .target(
            name: "GlobalUIComponents",
            dependencies: [
                .product(name: "DefaultExtensions", package: "DefaultExtensions"),
                "GlobalFonts",
            ],
            resources: [ ]
        ),
        .target(
            name: "GlobalObjects",
            dependencies: [
                .product(name: "DefaultExtensions", package: "DefaultExtensions"),
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Persistence", package: "Persistence"),
            ],
            resources: [
                .process("Resources")
            ]
        ),
        
        //test
        .testTarget(
            name: "GlobalResourceTests",
            dependencies: [
                "GlobalObjects"
            ]
        )
    ]
)
