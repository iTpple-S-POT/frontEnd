import ProjectDescription

private let bundleId: String = "com.itpple.spot.cjcamera"
private let version: String = "0.0.1"
private let bundleVersion: String = "1"
private let iOSTargetVersion: String = "16.0"

// Root
let packagePath = "Packages"

// Relative
let targetPath = "Targets"

let cjCameraProject = Project(
    name: "CJCamera",
    packages: [
        .local(path: .relativeToRoot("\(packagePath)/DefaultExtensions")),
        .local(path: .relativeToRoot("\(packagePath)/GlobalResource")),
    ],
    settings: getSettings(),
    targets: [
        Target(
            name: "CJCamera",
            platform: .iOS,
            product: .staticFramework,
            bundleId: "\(bundleId)",
            sources: ["Targets/CJCamera/Sources/**"],
            resources: ["Targets/CJCamera/Resources/**"],
            dependencies: [
                .package(product: "DefaultExtensions"),
                .package(product: "GlobalObjects"),
                .package(product: "GlobalUIComponents"),
            ]
        ),
        Target(
            name: "DemoApp",
            platform: .iOS,
            product: .app,
            bundleId: "\(bundleId).dempApp",
            sources: ["Targets/DemoApp/Sources/**"],
            dependencies: [
                .target(name: "CJCamera")
            ]
        ),
    ]
)

func getSettings() -> Settings {
    let baseSettings = Settings.settings(configurations: [
        .debug(name: "Debug", xcconfig: .relativeToCurrentFile("Configs/debug.xcconfig")),
        .release(name: "Release", xcconfig: .relativeToCurrentFile("Configs/release.xcconfig")),
    ])
    
    return baseSettings
}
