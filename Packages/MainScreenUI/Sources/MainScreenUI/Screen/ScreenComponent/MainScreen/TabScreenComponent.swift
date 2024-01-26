//
//  TabScreenComponent.swift
//
//
//  Created by 최준영 on 2023/12/24.
//

import SwiftUI
import GlobalFonts

struct TabScreenComponent: View {
    
    @ObservedObject var mainScreenModel: MainScreenModel
    
    @State private var showPotUploadScreen = false
    
    var body: some View {
        HStack(spacing: 0) {
            
            // 나의 팟 보기
            Rectangle()
                .fill(.white)
                .overlay {
                    
                    Button {
                        
                    } label: {
                        VStack(spacing: 0) {
                            Image.makeImageFromBundle(bundle: .module, name: "tab_pot", ext: .png)
                                .resizable()
                                .scaledToFit()
                            
                            Spacer(minLength: 5)
                            
                            Text("나의 POT")
                                .font(.suite(type: .SUITE_Regular, size: 14))
                                .foregroundStyle(.btn_red_nt)
                        }
                        .frame(height: 47)
                    }
                    
                }
            
            // 팟 추가하기
            Rectangle()
                .fill(.white)
                .overlay {
                    
                    Button {
                        
                        showPotUploadScreen = true
                        
                    } label: {
                        Image.makeImageFromBundle(bundle: .module, name: "tab_plus", ext: .png)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                    }
                }
            
            // 마이페이지
            Rectangle()
                .fill(.white)
                .overlay {
                    
                    Button {
                        
                    } label: {
                        VStack(spacing: 0) {
                            Image.makeImageFromBundle(bundle: .module, name: "tab_user", ext: .png)
                                .resizable()
                                .scaledToFit()
                            
                            Spacer(minLength: 5)
                            
                            Text("마이페이지")
                                .font(.suite(type: .SUITE_Regular, size: 14))
                                .foregroundStyle(.btn_red_nt)
                        }
                        .frame(height: 47)
                    }
                }
            
        }
        .background(
            Rectangle()
                .fill(.white)
                .shadow(color: .gray.opacity(0.3), radius: 2.0, y: -2)
        )
        .fullScreenCover(isPresented: $showPotUploadScreen, content: {
            PotUploadScreen { result in
                
                // TODO: 추후 수정
                DispatchQueue.main.async {
                    if result {
                        
                        mainScreenModel.showPotUploadSuccess()
                        
                    } else {
                        
                        mainScreenModel.showPotUploadFailed()
                    }
                }
            }
        })   
    }
}

#Preview {
    VStack(spacing: 0) {
        
        Spacer()
        
        TabScreenComponent(mainScreenModel: MainScreenModel())
            .frame(height: 64)
        
    }
}
