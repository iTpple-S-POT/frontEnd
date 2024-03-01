//
//  SelectSexView.swift
//
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI
import GlobalUIComponents

struct SelectGenderScreenComponent: View {
    
    @EnvironmentObject var screenModel: ConfigurationScreenModel
    
    
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
                    Text("성별을 알려주세요")
                }
                .font(.suite(type: .SUITE_Regular, size: 28))
                .frame(height: 75)
                
                Spacer(minLength: 0)
            }
            
            // Select Button
            HStack(spacing: 16.5) {
                
                ForEach(screenModel.genderCaseList, id: \.self) { element in
                    GeometryReader { geo in
                        
                        let innerView = AnyView(Text(element.rawValue).font(.suite(type: .SUITE_Regular, size: 18)))
                        
                        SpotStateButton(innerView: innerView, idleColor: .spotLightGray, activeColor: .spotRed, frame: geo.size, radius: 20) {
                            screenModel.userGenderState = element
                        } activation: {
                            screenModel.userGenderState == element
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
        SelectGenderScreenComponent()
            .environmentObject(ConfigurationScreenModel())
    }
}
