//
//  MainScreen2.swift
//
//
//  Created by 최준영 on 1/31/24.
//

import SwiftUI

public struct MainScreen: View  {
    
    @StateObject private var screenModel = MainScreenModel()
    
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
    
    
    // TODO: 구현예정
    var placHolderView: some View {
        
        ZStack {
            
            Color.white
            
            Text("not implemented")
            
        }
    }

    public var body: some View {
        VStack(spacing: 0) {
            
            // 스크린
            GeometryReader { geo in
                
                ZStack {
                    
                    Group {
                        
                        // home
                        HomeScreen()
                            .zIndex(screenModel.selectedTabItem == .home ? 1 : 0)
                        
                        // search
                        placHolderView
                            .zIndex(screenModel.selectedTabItem == .search ? 1 : 0)
                        
                        // myPot
                        placHolderView
                            .zIndex(screenModel.selectedTabItem == .myPot ? 1 : 0)
                        
                        // myPage
                        placHolderView
                            .zIndex(screenModel.selectedTabItem == .myPage ? 1 : 0)
                        
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    .position(x: geo.size.width/2, y: geo.size.height/2)
                    
                }
            }
            
            // 탭
            ZStack {

                //여기를 조작하여 원하는 백그라운드를 설정할 수 있다.
                Color.white
                    .ignoresSafeArea(.all, edges: .bottom)

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
                    }
                }
            }
            .frame(height: 64)
        }
        .alert(screenModel.alertTitle, isPresented: $screenModel.showAlert, actions: {
            
            Button("닫기") { }
            
        }, message: {
            Text(screenModel.alertMessage)
        })
        .environmentObject(screenModel)
    }
}


// MARK: - 탭 버튼
fileprivate struct SpotTabItem: View {
    
    var activeSample: SpotTapItemSample
    
    let identitiy: SpotTapItemSample
    
    let action: () -> Void
    
    private var isActive: Bool { activeSample == identitiy }
    
    private var textColor: Color { isActive ? .black : .medium_gray }
    
    private var imageType: ImageType { isActive ? .clk : .idle }
    
    var body: some View {
        ZStack {
            
            Color.clear
            
            VStack(spacing: 4) {
                
                identitiy.tagItemImage(type: imageType)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                
                Text(identitiy.tagItemTitle())
                    .font(.system(size: 12))
                    .foregroundStyle(textColor)
                    
            }
            
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
