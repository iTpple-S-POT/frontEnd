import ProjectDescription
import Foundation

private let bundleId: String = "com.spot"
private let version: String = "0.0.1"
private let bundleVersion: String = "1"
private let iOSTargetVersion: String = "16.0"

// 아래의 Targets는 Tuist파일에 존재한다.
private let basePath: String = "Targets"
private let packagePath: String = "Packages"
private let appName: String = "SPOT"

// kakao api key
// TODO: API_KEY보관파일에서 키값 불러오기, .gitignore로 해당파일 무시
private let kakaoNativeAppKey = getKakaoAppKey()

let project = Project(name: "\(appName)",
                      packages: [
                            .local(path: "\(packagePath)/SplashUI"),
                            .local(path: "\(packagePath)/LoginUI"),
                            .local(path: "\(packagePath)/UserInformationUI")
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
                              resources: [
                                "\(basePath)/SPOT_Application/Resources/**",
                                "Secrets/secret.json",
                              ],
                              dependencies: [
                                .package(product: "SplashUI"),
                                .package(product: "LoginUI"),
                                .package(product: "UserInformationUI"),
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
        "LSApplicationQueriesSchemes": ["kakaokompassauth", "kakaolink", "kakaoplus"],
        "CFBundleURLTypes" : [
            ["CFBundleURLSchemes" : ["kakao\(kakaoNativeAppKey)"]]
        ]
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

/// Kakao네이티브 앱 키를 반환하는 함수이다.
/// - Returns: api key
private func getKakaoAppKey() -> String {
    let manager = FileManager.default

    let path = manager.currentDirectoryPath + "/Secrets/secret.json"
    
    if manager.fileExists(atPath: path) {
        if let contentsOfFile = try? Data(contentsOf: URL(filePath: path)) {
            if let decodedContents = try? JSONDecoder().decode(SecretModel.self, from: contentsOfFile) {
                return decodedContents.keys.kakao_native_app_key
            }
            return "DecodingFailure"
        }
        return "noContents"
    }
    return "notFound"
}

private struct SecretModel: Decodable {
    struct App_key: Decodable {
        var kakao_native_app_key: String
    }
    var keys: App_key
}
