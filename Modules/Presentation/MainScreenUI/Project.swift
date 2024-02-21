import ProjectDescription

private let bundleId: String = "com.itpple.spot"
private let version: String = "0.0.1"
private let bundleVersion: String = "1"
private let iOSTargetVersion: String = "16.0"

let project = Project(name: "MainScreenUI",
                      packages: [
                        .local(path: .relativeToRoot("Packages/GlobalResource")),
                        .local(path: .relativeToRoot("Packages/DefaultExtensions")),
                        .local(path: .relativeToRoot("Packages/CJMapkit")),
                        .local(path: .relativeToRoot("Packages/PotDetailUI")),
                      ],
                      targets: [
                          Target(
                              name: "MainScreenUI",
                              platform: .iOS,
                              product: .staticFramework,
                              bundleId: "\(bundleId).mainScreenUI",
                              deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: .iphone),
                              infoPlist: .default,
                              sources: [
                                "MainScreenUI/Sources/**",
                              ],
                              resources: [
                                "MainScreenUI/Resources/**"
                              ],
                              dependencies: [
                                .package(product: "GlobalResource"),
                                .package(product: "DefaultExtensions"),
                                .package(product: "CJMapkit"),
                                .package(product: "PotDetailUI"),
                                .project(target: "CJCamera", path: .relativeToRoot("Modules/Feature/CJCamera")),
                                .project(target: "CJPhotoCollection", path: .relativeToRoot("Modules/Presentation/CJPhotoCollection"))
                              ]
                          )
                      ])
