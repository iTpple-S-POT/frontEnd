//
//  SelectMbtiView.swift
//
//
//  Created by 최준영 on 2023/11/24.
//

import SwiftUI
import GlobalUIComponents

struct SelectMbtiScreenComponent: View {
    
    @EnvironmentObject var screenModel: ConfigurationScreenModel
    
    /// notDetermined를 제외한 리스트 입니다.
    private var mbtiList: [UserMbtiPartCase] { UserMbtiPartCase.allCases.filter {  $0 != .notDetermined } }
    
    private var columns: [GridItem] = [GridItem(spacing: 16.5), GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 0) {
            // Text1
            //  TODO: 추후 닉네임임 데이터 로드 후 수정
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    (
                        Text(screenModel.nickNameInputString)
                            .font(.suite(type: .SUITE_SemiBold, size: 28))
                    +
                        Text("님의")
                    )
                    Text("MBTI을 알려주세요")
                }
                .font(.suite(type: .SUITE_Regular, size: 28))
                .frame(height: 75)
                
                Spacer(minLength: 0)
            }
            
            // Select Mbti
            LazyVGrid(columns: columns, spacing: 16.5) {
                ForEach(mbtiList, id: \.self) { element in
                    
                    GeometryReader { geo in
                        
                        SpotStateButton(innerView: AnyView(Text(element.rawValue).font(.suite(type: .SUITE_Regular, size: 18))), idleColor: .spotLightGray, activeColor: .spotRed, frame: geo.size, radius: 20) {
                            
                            screenModel.userMBTI.setState(mbti: element)
                            
                        } activation: {
                            
                            return screenModel.userMBTI.isStateMatch(mbti: element)
                            
                        }
                        
                    }
                    .frame(height: 56)
                }
            }
            .padding(.top, 42)
        
            
            Spacer(minLength: 0)
        }
    }
}

#Preview {
    PreviewForProcessView {
        SelectMbtiScreenComponent()
            .environmentObject(ConfigurationScreenModel())
    }
}
