//
//  MainScreenModel.swift
//
//
//  Created by 최준영 on 1/24/24.
//

import SwiftUI
import GlobalObjects
import DefaultExtensions

class MainScreenModel: ObservableObject {
    
    // 팟업로드 화면
    @Published var showPotUploadScreen = false
    
    // 탭 상태
    @Published var selectedTabItem: SpotTapItemSample = .home
    
    // 데이터를 받을 수 없는 사진의 경우 Alert표시
    @Published var showAlert = false
    @Published private(set) var alertTitle = ""
    @Published private(set) var alertMessage = ""
    
    // 맵태그 관련
    @Published var selectedTag: TagCases = .all
    @Published var selectedTagDict: [TagCases: Bool] = [
        .all : true,
        .hot : false,
        .life : false,
        .question : false,
        .information : false,
        .party : false
    ]
    
    // 현재활성화 되어있는 테그의 수를 추적합니다.
    var activeTagCount: Int = 1
    
    
    func showPotUploadSuccess() {
        
        showAlert = true
        alertTitle = "업로드 성공"
        alertMessage = "팟이 성공적으로 업로드됨"
    }
    
    func showPotUploadFailed() {
        
        showAlert = true
        alertTitle = "업로드 실패"
        alertMessage = "팟을 업로드하지 못했습니다."
    }
    
}


enum ImageType { case idle, clk }

enum SpotTapItemSample: Int, CaseIterable, Identifiable {
    
    case home, search, potUpload, myPot, myPage
    
    var id: UUID { UUID() }
    
    func tagItemImage(type: ImageType, color: UIColor) -> Image {
        
        var imageName = ""
        
        switch self {
        case .home:
            imageName = "mt_home_"
        case .search:
            imageName = "mt_search_"
        case .potUpload:
            imageName = "mt_pu_"
        case .myPot:
            imageName = "mt_mp_"
        case .myPage:
            imageName = "mt_mypage_"
        }
        
        imageName += type == .idle ? "idle" : "clk"
        
        let path = Bundle.module.provideFilePath(name: imageName, ext: "png")
        
        let uiImage = UIImage(named: path)!.imageWithColor(color: color)
        
        return Image(uiImage: uiImage)
    }
    
    func tagItemTitle() -> String {
        switch self {
        case .home:
            return "홈"
        case .search:
            return "검색"
        case .potUpload:
            return "업로드"
        case .myPot:
            return "나의 POT"
        case .myPage:
            return "마이페이지"
        }
    }
}


// MARK: - tabItemColorSet

enum TabViewMode {
    
    case idleMode
    case blackMode
    
    func getColorSet() -> TabItemColorSet {
        
        switch self {
        case .idleMode:
            return TabItemColorSet(tabViewBackgroundColor: .white, itemIdleColor: .medium_gray, itemClkColor: .black)
        case .blackMode:
            return TabItemColorSet(tabViewBackgroundColor: .black, itemIdleColor: .white, itemClkColor: .white)
        }
    }
}

struct TabItemColorSet {
    
    let tabViewBackgroundColor: UIColor
    let itemIdleColor: UIColor
    let itemClkColor: UIColor
}
