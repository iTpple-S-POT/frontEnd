//
//  FinalPotScreenComponent.swift
//
//
//  Created by 최준영 on 1/14/24.
//

import SwiftUI
import GlobalObjects
import GlobalUIComponents

struct FinalPotScreenComponent: View {
    
    @FetchRequest(sortDescriptors: [])
    private var userInfo: FetchedResults<SpotUser>
    
    @EnvironmentObject var screenModelWithNav: PotUploadScreenModel
    
    var tagObject: TagCases { TagCases[screenModelWithNav.selectedCategoryId ?? 1] }
    
    var body: some View {
        ZStack {
            
            Color.black
                .ignoresSafeArea(.container)
            
            
            GeometryReader { geo in
                // 선택한 사진
                if let uiImage = UIImage(data: screenModelWithNav.imageInfo!.data) {
                    
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height/3)
                        .allowsTightening(false)
                        .position(x: geo.size.width/2, y: geo.size.height/2)
                    
                }
            }
            
            
            // 기타 데이터
            VStack {
                
                ZStack {
                    
                    HStack(spacing: 8) {
                        
                        Spacer(minLength: 28)
                        
                        tagObject.getIcon(type: .point)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28)
                        
                        Text(tagObject.getKorString())
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                    }
                    
                    HStack(spacing: 0) {
                        
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white)
                            .frame(width: 28, height: 28)
                            .padding(10)
                            .onTapGesture {
                                
                                screenModelWithNav.popTopView()
                            }
                        
                        Spacer(minLength: 0)
                        
                    }
                    
                }
                .padding(.horizontal, 21)
                .frame(height: 56)
                
                Spacer()
                
                // 유저정보, 팟 텍스트, 해쉬테그
                VStack(alignment: .leading, spacing: 0) {
                    
                    // 유저 정보
                    HStack(spacing: 12) {

                        if let imageUrl = userInfo.first?.profileImageUrl, let url = URL(string: imageUrl), let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                            
                        } else {
                           Image(systemName: "person.crop.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white)
                                .frame(width: 40)
                        }
                        
                        // TODO: 유저 닉네임
                        Text(userInfo.first?.nickName ?? "비지정 닉네임")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    
                    // 팟 텍스트
                    VStack(alignment: .leading) {
                        
                        Text(screenModelWithNav.potText)
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                        
                        Spacer(minLength: 0)
                        
                    }
                    .frame(height: 40)
                    .padding(.top, 12)
                    
                    ScrollView(.horizontal) {
                        
                        LazyHStack(spacing: 8) {
                            
                            ForEach(screenModelWithNav.potHashTags, id: \.self) { tag in
                                
                                Text("#\(tag)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(height: 32)
                                    .padding(.horizontal, 15)
                                    .background(
                                        RoundedRectangle(cornerRadius: 30)
                                            .strokeBorder(.white, lineWidth: 1)
                                    )
                                
                            }
                            
                        }
                        
                    }
                    .scrollIndicators(.hidden)
                    .frame(height: 32)
                    
                }
                .padding(.horizontal, 21)
                
                SpotRoundedButton(text: "업로드", color: .btn_red_nt) {
                    
                    // 화면 끔
                    screenModelWithNav.dismiss?()
                    
                    // 팟 업로드
                    screenModelWithNav.uploadPot()
                }
                .padding(.horizontal, 21)
                .padding(.vertical, 24)
            }
        }
    }
}

#Preview {
    FinalPotScreenComponent()
        .environmentObject(PotUploadScreenModel())
}
