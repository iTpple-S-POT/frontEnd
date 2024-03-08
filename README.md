# frontEnd

## 기술스택

| 이름 |
| - |
| <img src="https://img.shields.io/badge/SwiftUI-0094F5?style=flat&logo=Swift&logoColor=white" style="height : auto; margin-left : 10px; margin-right : 10px;"/>  |
| <img src="https://img.shields.io/badge/UIKit-FF9E0F?style=flat&logo=Swift&logoColor=white" style="height : auto; margin-left : 10px; margin-right : 10px;"/> |
| <img src="https://img.shields.io/badge/Tuist-9b59b6?style=flat&logo=Swift&logoColor=white" style="height : auto; margin-left : 10px; margin-right : 10px;"/> |


## 주요 라이브러리

| 이름 | 목적 |
| --- | --- |
| Combine | '유저의 실시간 위치 정보를 Publish'와 같은 지속적인 데이터 변동 추적에 사용 |
| CoreData | 로그인한 유저정보를 로컬 및 메모리에 유지 |


## 모듈
| 이름 | 목적 |
| --- | --- |
| CJCamera | 카메라 촬영 로직 및 UI 
| InitialScreenUI | 앱 실행시 로컬/ 외부 서버로 부터 필요데이터 조회
| MainScreenUI | 메인 탭뷰및 탭뷰에 사영되는 화면UI | 
| CJPhotoCollection | 사진 어플리케이션으로부터 사진들을 획득과 관련UI | 
| UserInformationUI | 최초가입시 정보 입력UI, 유저프로필 수정UI | 
| OnBoardingUI | 앱기능 온보딩UI ex) *팟 업로드 가이드, MBTI 입력 가이드 | 

*인스타그램 스토리와 비슷한 S:POT의 게시물
   
## 외부 패키지  


| 이름 | 사용 목적 | 버전 |
| --- | --- | --- |
| Kingfisher | 이미지 처리 | 7.10.2 |
| Alamofire | 네트워크 통신 | 5.7.1 |


## 디렉토리 구조

```bash
├── Configs
├── Derived
│   ├── InfoPlists
│   └── Sources
├── Modules
│   ├── Feature
│   │   └── CJCamera
│   │       ├── CJCamera.xcodeproj
│   │       │   ├── project.xcworkspace
│   │       │   ├── xcshareddata
│   │       │   │   └── xcschemes
│   │       │   └── xcuserdata
│   │       │       └── choijun-yeong.xcuserdatad
│   │       │           └── xcschemes
│   │       ├── CJCamera.xcworkspace
│   │       │   ├── xcshareddata
│   │       │   │   ├── swiftpm
│   │       │   │   │   └── configuration
│   │       │   │   └── xcschemes
│   │       │   └── xcuserdata
│   │       │       └── choijun-yeong.xcuserdatad
│   │       │           ├── xcdebugger
│   │       │           └── xcschemes
│   │       ├── Configs
│   │       ├── Derived
│   │       │   ├── InfoPlists
│   │       │   └── Sources
│   │       └── Targets
│   │           ├── CJCamera
│   │           │   ├── Resources
│   │           │   └── Sources
│   │           │       ├── Model
│   │           │       ├── UIViewRepresentable
│   │           │       └── ViewModel
│   │           └── DemoApp
│   │               ├── Resources
│   │               └── Sources
│   └── Presentation
│       ├── CJPhotoCollection
│       │   ├── CJPhotoCollection
│       │   │   ├── Resources
│       │   │   └── Sources
│       │   │       ├── Cell
│       │   │       ├── Object
│       │   │       └── ViewController
│       │   ├── CJPhotoCollection.xcodeproj
│       │   │   ├── project.xcworkspace
│       │   │   ├── xcshareddata
│       │   │   │   └── xcschemes
│       │   │   └── xcuserdata
│       │   │       └── choijun-yeong.xcuserdatad
│       │   │           └── xcschemes
│       │   ├── CJPhotoCollection.xcworkspace
│       │   │   ├── xcshareddata
│       │   │   │   ├── swiftpm
│       │   │   │   │   └── configuration
│       │   │   │   └── xcschemes
│       │   │   └── xcuserdata
│       │   │       └── choijun-yeong.xcuserdatad
│       │   │           └── xcschemes
│       │   └── Derived
│       │       ├── InfoPlists
│       │       └── Sources
│       ├── InitialScreenUI
│       │   ├── Derived
│       │   │   └── InfoPlists
│       │   ├── InitialScreenUI
│       │   │   └── Sources
│       │   │       └── ApplicationUI
│       │   ├── InitialScreenUI.xcodeproj
│       │   │   ├── project.xcworkspace
│       │   │   ├── xcshareddata
│       │   │   │   └── xcschemes
│       │   │   └── xcuserdata
│       │   │       └── choijun-yeong.xcuserdatad
│       │   │           └── xcschemes
│       │   └── InitialScreenUI.xcworkspace
│       │       ├── xcshareddata
│       │       │   ├── swiftpm
│       │       │   │   └── configuration
│       │       │   └── xcschemes
│       │       └── xcuserdata
│       │           └── choijun-yeong.xcuserdatad
│       │               └── xcschemes
│       ├── MainScreenUI
│       │   ├── Derived
│       │   │   ├── InfoPlists
│       │   │   └── Sources
│       │   ├── MainScreenUI
│       │   │   ├── Resources
│       │   │   │   ├── DetailPart
│       │   │   │   ├── Map
│       │   │   │   ├── MyPage
│       │   │   │   ├── PDF
│       │   │   │   ├── PotUpload
│       │   │   │   ├── SearchScreen
│       │   │   │   ├── Tab
│       │   │   │   │   ├── clk
│       │   │   │   │   └── idle
│       │   │   │   └── TitlePart
│       │   │   └── Sources
│       │   │       ├── Error
│       │   │       ├── Extension
│       │   │       ├── Screen
│       │   │       │   ├── Constant
│       │   │       │   ├── ScreenComponent
│       │   │       │   │   ├── PotDetailScreen
│       │   │       │   │   └── PotUploadScreen
│       │   │       │   │       └── View
│       │   │       │   └── TabScreens
│       │   │       │       ├── HomeScreen
│       │   │       │       │   ├── HomeScreenComponents
│       │   │       │       │   │   └── PotListView
│       │   │       │       │   └── Refactor
│       │   │       │       │       ├── Fetcher
│       │   │       │       │       ├── InterFace
│       │   │       │       │       ├── Model
│       │   │       │       │       ├── Notification
│       │   │       │       │       └── ViewModel
│       │   │       │       ├── MyPageScreen
│       │   │       │       │   └── View
│       │   │       │       ├── MyPotScreen
│       │   │       │       └── SearchScreen
│       │   │       └── ViewModel
│       │   │           ├── MainScreenModel+Extension
│       │   │           └── TabScreenModels
│       │   ├── MainScreenUI.xcodeproj
│       │   │   ├── project.xcworkspace
│       │   │   │   ├── xcshareddata
│       │   │   │   │   └── swiftpm
│       │   │   │   │       └── configuration
│       │   │   │   └── xcuserdata
│       │   │   │       └── choijun-yeong.xcuserdatad
│       │   │   ├── xcshareddata
│       │   │   │   └── xcschemes
│       │   │   └── xcuserdata
│       │   │       └── choijun-yeong.xcuserdatad
│       │   │           └── xcschemes
│       │   └── MainScreenUI.xcworkspace
│       │       ├── xcshareddata
│       │       │   ├── swiftpm
│       │       │   │   └── configuration
│       │       │   └── xcschemes
│       │       └── xcuserdata
│       │           └── choijun-yeong.xcuserdatad
│       │               └── xcschemes
│       ├── OnBoardingUI
│       │   ├── Configs
│       │   ├── Derived
│       │   │   ├── InfoPlists
│       │   │   └── Sources
│       │   ├── OnBoardingUI.xcodeproj
│       │   │   ├── project.xcworkspace
│       │   │   ├── xcshareddata
│       │   │   │   └── xcschemes
│       │   │   └── xcuserdata
│       │   │       └── choijun-yeong.xcuserdatad
│       │   │           └── xcschemes
│       │   ├── OnBoardingUI.xcworkspace
│       │   │   ├── xcshareddata
│       │   │   │   ├── swiftpm
│       │   │   │   │   └── configuration
│       │   │   │   └── xcschemes
│       │   │   └── xcuserdata
│       │   │       └── choijun-yeong.xcuserdatad
│       │   │           ├── xcdebugger
│       │   │           └── xcschemes
│       │   └── Targets
│       │       ├── DemoApp
│       │       │   ├── Resources
│       │       │   │   ├── mbti
│       │       │   │   └── pot
│       │       │   └── Sources
│       │       └── OnBoardingUI
│       │           ├── Resources
│       │           │   ├── mbti
│       │           │   └── pot
│       │           └── Sources
│       │               ├── Mbti
│       │               └── Pot
│       │                   └── Views
│       └── UserInformationUI
│           ├── Configs
│           ├── Derived
│           │   ├── InfoPlists
│           │   └── Sources
│           ├── Targets
│           │   ├── DemoApp
│           │   │   ├── Resources
│           │   │   └── Sources
│           │   └── UserInformationUI
│           │       ├── Resources
│           │       │   ├── Background
│           │       │   ├── ILLust
│           │       │   ├── OnBoarding
│           │       │   └── UiImage
│           │       └── Sources
│           │           ├── Extension
│           │           ├── UserProfileEditView
│           │           │   └── View
│           │           ├── View
│           │           └── ViewModel
│           ├── UserInformationUI.xcodeproj
│           │   ├── project.xcworkspace
│           │   ├── xcshareddata
│           │   │   └── xcschemes
│           │   └── xcuserdata
│           │       └── choijun-yeong.xcuserdatad
│           │           └── xcschemes
│           └── UserInformationUI.xcworkspace
│               ├── xcshareddata
│               │   ├── swiftpm
│               │   │   └── configuration
│               │   └── xcschemes
│               └── xcuserdata
│                   └── choijun-yeong.xcuserdatad
│                       └── xcschemes
├── Packages
│   ├── CJMapkit
│   │   └── Sources
│   │       └── CJMapkit
│   │           ├── CodeFiles
│   │           │   ├── Annotation
│   │           │   │   ├── AnnotationType
│   │           │   │   ├── Protocol
│   │           │   │   └── Views
│   │           │   └── Extensions
│   │           └── Resources
│   │               ├── Pot_anot
│   │               ├── lo.lproj
│   │               └── lottie
│   ├── DefaultExtensions
│   │   ├── Sources
│   │   │   └── DefaultExtensions
│   │   └── Tests
│   │       └── DefaultExtensionsTests
│   ├── GlobalResource
│   │   ├── Sources
│   │   │   ├── GlobalFonts
│   │   │   │   ├── Codes
│   │   │   │   │   ├── Extension
│   │   │   │   │   ├── FontType
│   │   │   │   │   └── Protocol
│   │   │   │   └── Resources
│   │   │   │       └── SUITE
│   │   │   ├── GlobalObjects
│   │   │   │   ├── APIRequest
│   │   │   │   │   └── Model
│   │   │   │   │       ├── Request
│   │   │   │   │       └── Response
│   │   │   │   ├── CommonObjects
│   │   │   │   ├── CoreData
│   │   │   │   │   └── SpotStorageManager
│   │   │   │   ├── ModifierObject
│   │   │   │   └── Resources
│   │   │   │       ├── Model
│   │   │   │       │   └── SpotModel.xcdatamodeld
│   │   │   │       │       └── Model.xcdatamodel
│   │   │   │       └── Tags
│   │   │   │           ├── idle
│   │   │   │           ├── illust
│   │   │   │           └── point
│   │   │   └── GlobalUIComponents
│   │   │       ├── Color
│   │   │       ├── Component
│   │   │       │   ├── Bar
│   │   │       │   ├── Button
│   │   │       │   │   └── ButtonStyle
│   │   │       │   ├── Profile
│   │   │       │   └── Text
│   │   │       └── Resources
│   │   └── Tests
│   │       └── GlobalResourceTests
│   ├── LoginUI
│   │   ├── Sources
│   │   │   └── LoginUI
│   │   │       ├── LoginScreen
│   │   │       │   ├── Managers
│   │   │       │   ├── ScreenModel
│   │   │       │   └── View
│   │   │       └── Resources
│   │   │           └── SVGFiles.xcassets
│   │   │               └── img_Login.imageset
│   │   └── Tests
│   │       └── LoginUITests
│   ├── MyPageUI
│   │   ├── Sources
│   │   │   └── MyPageUI
│   │   │       ├── Resources
│   │   │       │   └── Pot
│   │   │       └── Screen
│   │   └── Tests
│   │       └── MyPageUITests
│   ├── Persistence
│   │   └── Sources
│   │       └── Persistence
│   ├── PotDetailUI
│   │   ├── Sources
│   │   │   └── PotDetailUI
│   │   │       ├── Extension
│   │   │       ├── Resources
│   │   │       │   ├── Emoji
│   │   │       │   ├── PotDetail
│   │   │       │   ├── Pretendard
│   │   │       │   ├── Report
│   │   │       │   ├── SearchImage
│   │   │       │   └── Story
│   │   │       └── Screen
│   │   │           ├── Components
│   │   │           └── New
│   │   │               ├── Profile
│   │   │               ├── Reaction
│   │   │               └── ReportUI
│   │   │                   ├── InterFace
│   │   │                   ├── Model
│   │   │                   ├── View
│   │   │                   └── ViewModel
│   │   └── Tests
│   │       └── PotDetailUITests
│   └── SplashUI
│       └── Sources
│           └── SplashUI
│               ├── Resources
│               ├── SplashScreen
│               │   └── Views
│               └── WelcomeScreen
├── Plugins
│   └── SPOTFE
│       ├── ProjectDescriptionHelpers
│       └── Sources
│           └── tuist-my-cli
├── S:POT.xcodeproj
│   ├── project.xcworkspace
│   ├── xcshareddata
│   │   └── xcschemes
│   └── xcuserdata
│       └── choijun-yeong.xcuserdatad
│           └── xcschemes
├── S:POT.xcworkspace
│   ├── xcshareddata
│   │   ├── swiftpm
│   │   │   └── configuration
│   │   └── xcschemes
│   └── xcuserdata
│       └── choijun-yeong.xcuserdatad
│           └── xcschemes
├── SPOT.xcodeproj
│   ├── project.xcworkspace
│   ├── xcshareddata
│   │   └── xcschemes
│   └── xcuserdata
│       └── choijun-yeong.xcuserdatad
│           └── xcschemes
├── SPOT.xcworkspace
│   ├── xcshareddata
│   │   ├── swiftpm
│   │   │   └── configuration
│   │   └── xcschemes
│   └── xcuserdata
│       └── choijun-yeong.xcuserdatad
│           ├── Bookmarks
│           ├── xcdebugger
│           └── xcschemes
├── Secrets
├── Secrets.docc
├── Targets
│   └── SPOT_Application
│       ├── Resources
│       │   ├── Assets.xcassets
│       │   │   ├── AccentColor.colorset
│       │   │   └── AppIcon.appiconset
│       │   └── Preview Content
│       │       └── Preview Assets.xcassets
│       ├── Sources
│       └── Tests
└── Tuist
    └── ProjectDescriptionHelpers
```
