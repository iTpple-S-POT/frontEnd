//
//  MainScreen2.swift
//
//
//  Created by 최준영 on 1/31/24.
//

import SwiftUI
import PotDetailUI

public struct MainScreen: View  {
    
    @StateObject private var screenModel = MainScreenModel()
    
    @StateObject private var mainScreenConfig = MainScreenConfig()
    
    private let tabs: [SpotTapItemSample : AnyView] = [
        .home : AnyView(HomeScreen()),
        .search : AnyView(Text("검색")),
        .myPot : AnyView(Text("내팟")),
        .myPage : AnyView(Text("마이페이지")),
    ]
    
    public init() { }
    
    var tabScreen: some View {
        
        return tabs[screenModel.selectedTabItem]!
    }

    public var body: some View {
        ZStack {
            
            // 스크린
            GeometryReader { geo in
                
                ZStack {
                    
                    Group {
                        // home
                        HomeScreen()
                            .zIndex(screenModel.selectedTabItem == .home ? 1 : 0)
                        
                        // search
                        PotSearchScreen()
                            .zIndex(screenModel.selectedTabItem == .search ? 1 : 0)
                        
                        // myPot
                        MyPotScreen()
                            .zIndex(screenModel.selectedTabItem == .myPot ? 1 : 0)
                        
                        // myPage
                        MyPageScreen()
                            .zIndex(screenModel.selectedTabItem == .myPage ? 1 : 0)
                        
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    .position(x: geo.size.width/2, y: geo.size.height/2)
                    
                }
            }
            .padding(.bottom, 64)
            
            VStack {
                
                Spacer()
                
                // 탭
                ZStack {

                    //여기를 조작하여 원하는 백그라운드를 설정할 수 있다.
                    Color(uiColor: mainScreenConfig.tabViewMode.getColorSet().tabViewBackgroundColor)
                        .ignoresSafeArea(.container, edges: .bottom)
                    
                    GeometryReader { geo in
                        
                        let cellWidth = geo.size.width / 5
                        let cellHeight = geo.size.height
                        
                        HStack(spacing: 0) {
                            
                            ForEach(SpotTapItemSample.allCases) { item in
                                
                                SpotTabItem(activeSample: screenModel.selectedTabItem, identitiy: item) {
                                    
                                    // 팟업로드를 제외한 경우(탭 전환)
                                    if item != .potUpload {
                                        
                                        screenModel.selectedTabItem = item
                                        
                                    } else {
                                        
                                        // 팟업로드 화면 표시
                                        screenModel.showPotUploadScreen = true
                                    }
                                }
                                .frame(width: cellWidth, height: cellHeight)
                            }
                        }
                    }
                }
                .frame(height: 64)
                .background {
                    Rectangle()
                        .fill(.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, y: -3)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .alert(screenModel.alertTitle, isPresented: $screenModel.showAlert, actions: {
            
            Button("닫기") { }
            
        }, message: {
            Text(screenModel.alertMessage)
        })
        .fullScreenCover(isPresented: $screenModel.showPotUploadScreen, content: {
            PotUploadScreen { result in
                
                // TODO: 추후 수정
                DispatchQueue.main.async {
                    if result {
                        
                        screenModel.showPotUploadSuccess()
                        
                    } else {
                        
                        screenModel.showPotUploadFailed()
                    }
                }
            }
        })
        .fullScreenCover(isPresented: $screenModel.presentPotDetailView, content: {
            
            PotDetailView(
                potModel: screenModel.selectedPotModel!,
                userInfo: screenModel.userInfo) {
                    
                    screenModel.presentPotDetailView = false
                    
                    mainScreenConfig.setMode(mode: .idleMode)
                    mainScreenConfig.isPotDetailViewIsPresented = false
                }
                .onAppear(perform: {
                    
                    if !mainScreenConfig.isPotDetailViewIsPresented {
                        
                        mainScreenConfig.setMode(mode: .blackMode)
                        mainScreenConfig.isPotDetailViewIsPresented = true
                    }
                })
        })
        .environmentObject(screenModel)
        .environment(\.mainScreenConfig, mainScreenConfig)
    }
}

// MARK: - 탭 버튼
fileprivate struct SpotTabItem: View {
    
    @Environment(\.mainScreenConfig) var mainScreenConfig
    
    var activeSample: SpotTapItemSample
    
    let identitiy: SpotTapItemSample
    
    let action: () -> Void
    
    private var isActive: Bool { activeSample == identitiy }
    
    private var imageType: ImageType { isActive ? .clk : .idle }
    
    private var tabViewColorSet: TabItemColorSet { mainScreenConfig.tabViewMode.getColorSet() }
    
    private var backgroundColor: UIColor { tabViewColorSet.tabViewBackgroundColor }
    private var idleColor: UIColor { tabViewColorSet.itemIdleColor }
    private var clkColor: UIColor { tabViewColorSet.itemClkColor }
    
    var body: some View {
        VStack(spacing: 4) {
            
            identitiy.tagItemImage(type: imageType, color: isActive ? clkColor : idleColor)
                .resizable()
                .scaledToFit()
                .frame(width: 30)
            
            Text(identitiy.tagItemTitle())
                .font(.system(size: 12))
                .foregroundStyle(Color(uiColor: isActive ? clkColor : idleColor))
                
        }
        .contentShape(Circle())
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    MainScreen()
}
