//
//  SelectMbtiView.swift
//
//
//  Created by 최준영 on 2023/11/24.
//

import SwiftUI
import GlobalUIComponents

enum MbtiType: String, CaseIterable {
    case notDetermined
    case E = "E",
         I = "I",
         S = "S",
         N = "N",
         T = "T",
         F = "F",
         J = "J",
         P = "P"
}

struct SelectMbtiView: View {
    
    let userNickName = "닉네임"
    
    @State private var type1: MbtiType = .notDetermined
    @State private var type2: MbtiType = .notDetermined
    @State private var type3: MbtiType = .notDetermined
    @State private var type4: MbtiType = .notDetermined
    
    /// notDetermined를 제외한 리스트 입니다.
    private var mbtiList: [MbtiType] { MbtiType.allCases.filter {  $0 != .notDetermined } }
    
    var columns: [GridItem] = [GridItem(spacing: 16.5), GridItem(.flexible())]
    
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
                    Text("MBTI을 알려주세요")
                }
                .font(.suite(type: .SUITE_Regular, size: 28))
                
                Spacer(minLength: 0)
            }
            .frame(height: 75)
            
            // Select Mbti
            LazyVGrid(columns: columns, spacing: 16.5) {
                ForEach(Array(mbtiList.enumerated()), id: \.element) { index, element in
                    
                    switch index {
                    case 0, 1:
                        SpotStateButton(text: element.rawValue, state: $type1, targetState: element, idleColor: .spotLightGray, activeColor: .spotRed) {
                            type1 = element
                        }
                    case 2, 3:
                        SpotStateButton(text: element.rawValue, state: $type2, targetState: element, idleColor: .spotLightGray, activeColor: .spotRed) {
                            type2 = element
                        }
                    case 4, 5:
                        SpotStateButton(text: element.rawValue, state: $type3, targetState: element, idleColor: .spotLightGray, activeColor: .spotRed) {
                            type3 = element
                        }
                    case 6, 7:
                        SpotStateButton(text: element.rawValue, state: $type4, targetState: element, idleColor: .spotLightGray, activeColor: .spotRed) {
                            type4 = element
                        }
                    default:
                        fatalError("잘못된 Mbti리스트 사용")
                    }
                }
            }
            .padding(.top, 42)
        
            
            Spacer(minLength: 0)
        }
    }
}

#Preview {
    PreviewForProcessView {
        SelectMbtiView()
    }
}
