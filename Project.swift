import ProjectDescription
import Foundation

private let bundleId: String = "com.itpple.spot"
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
                            .local(path: "\(packagePath)/LoginUI"),
                      ],
                      settings: Settings.settings(configurations: makeConfiguration()),
                      targets: [
                          Target(
                              name: appName,
                              platform: .iOS,
                              product: .app,
                              bundleId: bundleId,
                              deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: .iphone),
                              infoPlist: makeInfoPlist(),
                              sources: [
                                "\(basePath)/SPOT_Application/Sources/**"
                              ],
                              resources: [
                                "\(basePath)/SPOT_Application/Resources/**",
                                "Secrets/secret.json",
                              ],
                              dependencies: [
                                .project(target: "InitialScreenUI", path: .relativeToRoot("Modules/Presentation/InitialScreenUI")),
                                .package(product: "LoginUI"),
                              ],
                              settings: baseSettings()
                          )
                      ],
                      additionalFiles: [
                          "README.md"
                      ]
)
/// Create extended plist for iOS
/// - Returns: InfoPlist
private func makeInfoPlist(merging other: [String: Plist.Value] = [:]) -> InfoPlist {
    var extendedPlist: [String: Plist.Value] = [
        "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
        "localization native development region" : "Korea",
        "UIApplicationSceneManifest": ["UIApplicationSupportsMultipleScenes": true],
        "UILaunchScreen": [],
        "UISupportedInterfaceOrientations":
            [
                "UIInterfaceOrientationPortrait"
            ],
        "CFBundleShortVersionString": "\(version)",
        "CFBundleVersion": "\(bundleVersion)",
        "CFBundleDisplayName": "$(APP_DISPLAY_NAME)",
        "NSLocationWhenInUseUsageDescription": "회원님의 위치정보를 사용하여 지도의 정확한 위치에 업로드한 컨텐츠를 표시합니다. 그리고 회원님 주위의 다양한 컨텐츠를 수집합니다. 위치정보에 동의를 하지 않을 경우 게시물 작성및 조회 기능이 제한될 수 있습니다.",
        "LSApplicationQueriesSchemes": ["kakaokompassauth", "kakaolink", "kakaoplus"],
        "CFBundleURLTypes": [
            ["CFBundleURLSchemes" : ["kakao\(kakaoNativeAppKey)"]]
        ],
        "NSPhotoLibraryUsageDescription": "게시되는 컨텐츠에 사용되는 이미지를 선택하기 위해 사진 어플리케이션의 접근을 요청합니다.",
        "NSCameraUsageDescription" : "게시되는 컨텐츠애 포함될 사진을 촬영하기위해 카메라에 접근합니다.",
        "NSPhotoLibraryAddUsageDescription" : "촬영한 사진을 사진 어플리케이션에 저장합니다.",
        "UIUserInterfaceStyle" : "Light",
        "ITSAppUsesNonExemptEncryption" : "NO",
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
