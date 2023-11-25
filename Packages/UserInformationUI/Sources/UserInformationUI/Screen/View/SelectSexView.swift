//
//  SelectSexView.swift
//
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI
import GlobalUIComponents

enum UserSexState: String {
    case notDetermined = "notDetermined", male = "남성", female = "여성"
}

struct SelectSexView: View {
    
    @State private var userSexState: UserSexState = .notDetermined
    
    let userNickName = "닉네임"
    
    private let sexList: [UserSexState] = [ .male, .female ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Text1
            //  TODO: 추후 닉네임임 데이터 로드 후 수정
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    (
                        Text(userNickName)
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
                
                ForEach(sexList, id: \.self) { element in
                    GeometryReader { geo in
                        SpotStateButton(text: Text(element.rawValue).font(.suite(type: .SUITE_Regular, size: 18)), idleColor: .spotLightGray, activeColor: .spotRed, frame: geo.size) {
                            userSexState = element
                        } activation: {
                            userSexState == element
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
        SelectSexView()
    }
}
