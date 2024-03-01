import ProjectDescription

private let bundleId: String = "com.itpple.spot.onBoardingUI"
private let version: String = "0.0.1"
private let bundleVersion: String = "1"
private let iOSTargetVersion: String = "16.0"

private let packagePath = "Packages"

let userInformationProject = Project(
    name: "OnBoardingUI",
    packages: [
        .local(path: .relativeToRoot("\(packagePath)/GlobalResource")),
        .local(path: .relativeToRoot("\(packagePath)/DefaultExtensions")),
    ],
    settings: getSettings(),
    targets: [
        Target(
            name: "OnBoardingUI",
            platform: .iOS,
            product: .staticFramework,
            bundleId: bundleId,
            deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: .iphone),
            sources: ["Targets/OnBoardingUI/Sources/**"],
            resources: ["Targets/OnBoardingUI/Resources/**"],
            dependencies: [
                .package(product: "GlobalObjects"),
                .package(product: "GlobalUIComponents"),
                .package(product: "GlobalFonts"),
                .package(product: "DefaultExtensions")
            ]
        ),
//        Target(
//            name: "DemoApp",
//            platform: .iOS,
//            product: .app,
//            bundleId: "\(bundleId).demoApp",
//            deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: .iphone),
//            infoPlist: dempAppInfoPlist(),
//            sources: ["Targets/DemoApp/Sources/**"],
//            resources: ["Targets/DemoApp/Resources/**"],
//            dependencies: [
//                .target(name: "OnBoardingUI")
//            ]
//        ),
    ]
)

func getSettings() -> Settings {
    let baseSettings = Settings.settings(configurations: [
        .debug(name: "Debug", xcconfig: .relativeToCurrentFile("Configs/debug.xcconfig")),
        .release(name: "Release", xcconfig: .relativeToCurrentFile("Configs/release.xcconfig")),
    ])
    
    return baseSettings
}

func dempAppInfoPlist() -> InfoPlist {
    
    let additionalList: [String : Plist.Value] = [
        "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
        "localization native development region" : "Korea",
        "UIApplicationSceneManifest": ["UIApplicationSupportsMultipleScenes": true],
        "UILaunchScreen": [],
        "UISupportedInterfaceOrientations":
            ["UIInterfaceOrientationPortrait"],
    ]
    
    return InfoPlist.extendingDefault(with: additionalList)
}

