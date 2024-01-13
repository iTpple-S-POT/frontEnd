//
//  SwiftUIView.swift
//  
//
//  Created by 최준영 on 2024/01/13.
//

import SwiftUI
import GlobalObjects
import GlobalUIComponents

struct SelectCategoryScreenComponent: View {
    
    @EnvironmentObject var screenModelWithNav: PotUploadScreenModel
    
    let test = [
        CategoryObject(id: 1, name: "테스트1", description: "지금의 동네는 어떤가요? 지금 이 순간의 소소한 일상을 공유해 주세요"),
        CategoryObject(id: 2, name: "테스트2", description: "지금의 동네는 어떤가요? 지금 이 순간의 소소한 일상을 공유해 주세요"),
        CategoryObject(id: 3, name: "테스트3", description: "지금의 동네는 어떤가요? 지금 이 순간의 소소한 일상을 공유해 주세요"),
        CategoryObject(id: 4, name: "테스트4", description: "지금의 동네는 어떤가요? 지금 이 순간의 소소한 일상을 공유해 주세요"),
    ]
    
    private var isButtonValid: Bool { screenModelWithNav.selectedCategoryId != nil }
    
    var body: some View {
        VStack {
            
            // 최상단
            ZStack {
                
                HStack(spacing: 0) {
                    
                    Spacer(minLength: 28)
                    
                    Text("업로드")
                        .font(.system(size: 20, weight: .semibold))
                    
                    Spacer()
                    
                }
                
                HStack(spacing: 0) {
                    
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .onTapGesture {
                            
                            screenModelWithNav.dismiss?()
                            
                        }
                    
                    Spacer(minLength: 0)
                    
                }
                
            }
            .padding(.horizontal, 21)
            .frame(height: 56)
            .background(
                Rectangle().fill(.white)
            )
            .shadow(color: .gray.opacity(0.3), radius: 2.0, y: 2)
            
            // 카테리들 + 버튼
            VStack {
                
                // 타이틀
                
                HStack {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text("POT의 카테고리를")
                        
                        Text("선택해 주세요")
                        
                    }
                    .font(.system(size: 28, weight: .semibold))
                    .frame(height: 71)
                    
                    Spacer()
                    
                }
                
                // 카테고리들
                ScrollView {
                    
                    VStack(spacing: 16) {
                        
                        ForEach(test, id: \.self) {
                            
                            CategoryBox(selected: $screenModelWithNav.selectedCategoryId, object: $0)
                            
                        }
                        
                    }
                    
                }
                .padding(.top, 28)
                
                Spacer()
                
                // 다음
                SpotRoundedButton(text: "다음", color: .btn_red_nt.opacity(isButtonValid ? 1 : 0.3)) {
                    
                    // 네비게이션 이동
                    
                    
                }
                .disabled(!isButtonValid)
                .padding(.bottom, 24)
                
            }
            .padding(.horizontal, 21)
            .padding(.top, 40)
            
            Spacer()
        }
    }
}

// TODO: 이주 예정

struct CategoryBox: View {
    
    @Binding var selected: Int64?
    
    var object: CategoryObject
    
    private var isSelected: Bool { selected == object.id }
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            Circle()
                .fill(.white)
                .frame(width: 80, height: 80)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(object.name)
                    .font(.system(size: 20, weight: .semibold))
                
                Text(object.description)
                    .font(.system(size: 12))
                    .lineSpacing(5)
            }
            .padding(.leading, 16)
            
        }
        .padding(10)
        .background{
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? .mainScreenRed.opacity(0.2) : .btn_light_grey)
                
                if isSelected {
                        
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.red, lineWidth: 1)
                    
                }
                
            }
        }
        .frame(height: 100)
        .onTapGesture {
            selected = object.id
        }
        
    }
    
}

#Preview {
    SelectCategoryScreenComponent()
        .environmentObject(PotUploadScreenModel())
}
