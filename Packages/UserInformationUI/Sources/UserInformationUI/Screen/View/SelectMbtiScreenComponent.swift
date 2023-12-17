//
//  SelectMbtiView.swift
//
//
//  Created by 최준영 on 2023/11/24.
//

import SwiftUI
import GlobalUIComponents

enum UserMbtiPartCase: String, CaseIterable {
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

struct UserMbti: Equatable {
    var type1: UserMbtiPartCase = .notDetermined
    var type2: UserMbtiPartCase = .notDetermined
    var type3: UserMbtiPartCase = .notDetermined
    var type4: UserMbtiPartCase = .notDetermined
    
    mutating func setState(mbti: UserMbtiPartCase) {
        switch mbti {
        case .notDetermined:
            return
        case .E, .I:
            type1 = mbti
        case .S, .N:
            type2 = mbti
        case .T, .F:
            type3 = mbti
        case .J, .P:
            type4 = mbti
        }
    }
    
    func isStateMatch(mbti: UserMbtiPartCase) -> Bool {
        switch mbti {
        case .notDetermined:
            return false
        case .E, .I:
            return type1 == mbti
        case .S, .N:
            return type2 == mbti
        case .T, .F:
            return type3 == mbti
        case .J, .P:
            return type4 == mbti
        }
    }
}

struct SelectMbtiScreenComponent: View {
    
    let userNickName = "닉네임"
    
    @State private var userMbti = UserMbti()
    
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
                        Text(userNickName)
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
                        SpotStateButton(text: Text(element.rawValue).font(.suite(type: .SUITE_Regular, size: 18)), idleColor: .spotLightGray, activeColor: .spotRed, frame: geo.size) {
                            userMbti.setState(mbti: element)
                        } activation: {
                            userMbti.isStateMatch(mbti: element)
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
    }
}
