import ProjectDescription

private let bundleId: String = "com.spot"
private let version: String = "0.0.1"
private let bundleVersion: String = "1"
private let iOSTargetVersion: String = "16.0"

// 아래의 Targets는 Tuist파일에 존재한다.
private let basePath: String = "Targets"
private let packagePath: String = "Packages"
private let appName: String = "SPOT"

let project = Project(name: "\(appName)",
                      packages: [
                            .local(path: "\(packagePath)/SplashUI"),
                            .local(path: "\(packagePath)/LoginUI"),
                            .local(path: "\(packagePath)/OnBoardingUI")
                      ],
                      settings: Settings.settings(configurations: makeConfiguration()),
                      targets: [
                          Target(
                              name: "SPOT_Application",
                              platform: .iOS,
                              product: .app,
                              bundleId: bundleId,
                              deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: .iphone),
                              infoPlist: makeInfoPlist(),
                              sources: ["\(basePath)/SPOT_Application/Sources/**"],
                              resources: ["\(basePath)/SPOT_Application/Resources/**"],
                              dependencies: [
                                .package(product: "SplashUI"),
                                .package(product: "LoginUI"),
                                .package(product: "OnBoardingUI"),
                              ],
                              settings: baseSettings()
                          )
                      ],
                      additionalFiles: [
                          "README.md"
                      ])
/// Create extended plist for iOS
/// - Returns: InfoPlist
private func makeInfoPlist(merging other: [String: Plist.Value] = [:]) -> InfoPlist {
    var extendedPlist: [String: Plist.Value] = [
        "UIApplicationSceneManifest": ["UIApplicationSupportsMultipleScenes": true],
        "UILaunchScreen": [],
        "UISupportedInterfaceOrientations":
            [
                "UIInterfaceOrientationPortrait"
            ],
        "CFBundleShortVersionString": "\(version)",
        "CFBundleVersion": "\(bundleVersion)",
        "CFBundleDisplayName": "$(APP_DISPLAY_NAME)",
        "Privacy - Location When In Use Usage Description": "앱을 사용하는 동안 사용자의 위치를 특정합니다.",
    ]

    other.forEach { (key: String, value: Plist.Value) in
        extendedPlist[key] = value
    }

    return InfoPlist.extendingDefault(with: extendedPlist)
}

/// Create dev and release configuration
/// - Returns: Configuration Tuple
/// Configuration을 추가하고 싶다면 해당 함수를 수정하여 추가할 수 있다.
private func makeConfiguration() -> [Configuration] {
    let debug = Configuration.debug(name: "Debug", xcconfig: "Configs/Debug.xcconfig")
    let release = Configuration.release(name: "Release", xcconfig: "Configs/Release.xcconfig")

    return [debug, release]
}

/// Create baseSettings
/// - Returns: Settings
private func baseSettings() -> Settings {
    let msForWarning = 5
    let settings = SettingsDictionary()
//        .otherSwiftFlags("-xfrontend -warn-expression-type-checking=\(msForWarning)",
//                         "-xfrontend -warn-expression-function-bodies=\(msForWarning)")

    return Settings.settings(base: settings,
                             configurations: [],
                             defaultSettings: .recommended)
}
