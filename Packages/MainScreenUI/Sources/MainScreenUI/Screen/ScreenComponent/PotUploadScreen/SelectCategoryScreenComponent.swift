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
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.id, order: .forward)])
    private var categories: FetchedResults<SpotCategory>
    
    @EnvironmentObject var screenModelWithNav: PotUploadScreenModel
    
    let test = [
        CategoryObject(id: 1, name: "테스트1", description: "지금의 동네는 어떤가요? 지금 이 순간의 소소한 일상을 공유해 주세요"),
        CategoryObject(id: 2, name: "테스트2", description: "지금의 동네는 어떤가요? 지금 이 순간의 소소한 일상을 공유해 주세요"),
        CategoryObject(id: 3, name: "테스트3", description: "지금의 동네는 어떤가요? 지금 이 순간의 소소한 일상을 공유해 주세요"),
        CategoryObject(id: 4, name: "테스트4", description: "지금의 동네는 어떤가요? 지금 이 순간의 소소한 일상을 공유해 주세요"),
    ]
    
    private var isButtonValid: Bool { screenModelWithNav.selectedCategoryId != nil }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 최상단
            SpotNavigationBarView(title: "업로드") {
                
                screenModelWithNav.dismiss?()
                
            }
            
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
                        
                        ForEach(categories, id: \.self) {
                            
                            let object = CategoryObject(id: $0.id, name: $0.name ?? "", description: $0.content ?? "")
                            
                            CategoryBox(selected: $screenModelWithNav.selectedCategoryId, object: object)
                            
                        }
                        
                    }
                    
                }
                .padding(.top, 28)
                
                Spacer(minLength: 0)
                
                // 다음
                SpotRoundedButton(text: "다음", color: .btn_red_nt.opacity(isButtonValid ? 1 : 0.3)) {
                    
                    // 업로드 화면으로 이동
                    screenModelWithNav.addToStack(destination: .uploadScreen)
                    
                }
                .disabled(!isButtonValid)
                .padding(.bottom, 24)
                
            }
            .padding(.horizontal, 21)
            .padding(.top, 40)
        }
    }
}

#Preview {
    SelectCategoryScreenComponent()
        .environmentObject(PotUploadScreenModel())
        .environmentObject(GlobalStateObject())
}
