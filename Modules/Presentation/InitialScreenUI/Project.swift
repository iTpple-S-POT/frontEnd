import ProjectDescription

private let bundleId: String = "com.itpple.spot"
private let version: String = "0.0.1"
private let bundleVersion: String = "1"
private let iOSTargetVersion: String = "16.0"

// 아래의 Targets는 Tuist파일에 존재한다.
private let basePath: String = "Targets"
private let packagePath: String = "Packages"

let project = Project(name: "InitialScreenUI",
                      packages: [
                        .local(path: .relativeToRoot("Packages/SplashUI")),
                        .local(path: .relativeToRoot("Packages/LoginUI")),
                        .local(path: .relativeToRoot("Packages/GlobalResource")),
                        .local(path: .relativeToRoot("\(packagePath)/DefaultExtensions")),
                      ],
                      targets: [
                          Target(
                              name: "InitialScreenUI",
                              platform: .iOS,
                              product: .staticFramework,
                              bundleId: "\(bundleId).initialScreenUI",
                              deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: .iphone),
                              infoPlist: .default,
                              sources: [
                                "InitialScreenUI/Sources/**",
                              ],
                              resources: [
                                "InitialScreenUI/Resources/**",
                              ],
                              dependencies: [
                                .package(product: "SplashUI"),
                                .package(product: "LoginUI"),
                                .package(product: "GlobalObjects"),
                                .package(product: "DefaultExtensions"),
                                .project(target: "MainScreenUI", path: .relativeToRoot("Modules/Presentation/MainScreenUI")),
                                .project(target: "UserInformationUI", path: .relativeToRoot("Modules/Presentation/UserInformationUI")),
                              ]
                          )
                      ])
