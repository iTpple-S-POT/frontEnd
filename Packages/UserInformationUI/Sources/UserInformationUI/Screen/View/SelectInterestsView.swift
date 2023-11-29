//
//  SwiftUIView.swift
//  
//
//  Created by 최준영 on 2023/11/24.
//

import SwiftUI
import GlobalUIComponents
import GlobalFonts

struct SelectInterestsView: View {
    
    let userNickName = "닉네임"
    
    @StateObject private var viewModel = SelectInterestsViewModel()
    
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
                    Text("취미&관심사를 알려주세요")
                }
                .font(.suite(type: .SUITE_Regular, size: 28))
                
                Spacer(minLength: 0)
            }
            .frame(height: 75)
            
            // Text2
            HStack {
                Text("최소 2개 이상 골라주세요 :)")
                    .font(.suite(type: .SUITE_Regular, size: 16))
                Spacer(minLength: 0)
            }
            .frame(height: 20)
            .padding(.top, 6)
            
            // 관심사 선택
            VStack(alignment: .leading, spacing: 9) {
                ForEach(viewModel.userInterestMatrix, id: \.self) { list1D in
                    
                    HStack(spacing: 9) {
                        
                        ForEach(list1D) { element in
                            
                            SpotStateButton(text: Text(element.rawValue).font(.suite(type: .SUITE_Regular, size: 16)), idleColor: .spotLightGray, activeColor: .spotRed, frame: viewModel.getViewSize(string: element.rawValue)) {
                                
                                if viewModel.isTypeExists(type: element) {
                                    viewModel.deSelectType(type: element)
                                    return
                                }
                                
                                viewModel.selectType(type: element)
                                
                            } activation: {
                                viewModel.isTypeExists(type: element)
                            }

                        }
                    }
                }
            }
            .padding(.top, 24)
            
            Spacer(minLength: 0)
        }
    }
}

#Preview {
    PreviewForProcessView {
        SelectInterestsView()
    }
}
