//
//  SelectSexView.swift
//
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI
import GlobalUIComponents

enum UserSexState {
    case notDetermined, male, female
}

struct SelectSexView: View {
    
    @State private var userSexState: UserSexState = .notDetermined
    
    let userNickName = "닉네임"
    
    var body: some View {
        VStack(spacing: 0) {
            // Text1
            //  TODO: 추후 닉네임임 데이터 로드 후 수정
            HStack {
                VStack(alignment: .leading) {
                    (
                        Text(userNickName)
                            .font(.suite(type: .SUITE_SemiBold, size: 28))
                    +
                        Text("님의")
                    )
                    Text("성별을 알려주세요")
                }
                .font(.suite(type: .SUITE_Regular, size: 28))
                
                Spacer(minLength: 0)
            }
            .frame(height: 75)
            
            // Select Button
            HStack(spacing: 16.5) {
                SpotStateButton(text: "남성", state: $userSexState, targetState: .male, idleColor: .spotLightGray, activeColor: .spotRed) {
                    userSexState = .male
                }
                SpotStateButton(text: "여성", state: $userSexState, targetState: .female, idleColor: .spotLightGray, activeColor: .spotRed) {
                    userSexState = .female
                }
            }
            .padding(.top, 42)
            
            Spacer(minLength: 0)
        }
    }
}

#Preview {
    PreviewForProcessView {
        SelectSexView()
    }
}
