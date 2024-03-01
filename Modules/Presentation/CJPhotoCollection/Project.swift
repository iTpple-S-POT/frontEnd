import ProjectDescription

private let bundleId: String = "com.itpple.spot"
private let version: String = "0.0.1"
private let bundleVersion: String = "1"
private let iOSTargetVersion: String = "16.0"

let project = Project(name: "CJPhotoCollection",
                      packages: [
                        .local(path: .relativeToRoot("Packages/GlobalResource")),
                      ],
                      targets: [
                          Target(
                              name: "CJPhotoCollection",
                              platform: .iOS,
                              product: .staticFramework,
                              bundleId: "\(bundleId).photoCollection",
                              deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: .iphone),
                              sources: [
                                "CJPhotoCollection/Sources/**",
                              ],
                              resources: [
                                "CJPhotoCollection/Resources/**"
                              ],
                              dependencies: [
                                .package(product: "GlobalObjects"),
                                .project(target: "CJCamera", path: .relativeToRoot("Modules/Feature/CJCamera"))
                              ]
                          )
                      ])
