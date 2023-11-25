//
//  SwiftUIView.swift
//  
//
//  Created by 최준영 on 2023/11/24.
//

import SwiftUI
import GlobalUIComponents
import GlobalFonts



class SelectInterestsViewModel: ObservableObject {
    enum UserInterestType: String, CaseIterable, Identifiable {
        var id: Self { self }
        
        case type1 = "영화",
        type2 = "자전거",
        type3 = "글쓰기",
        type4 = "갓생살기",
        type5 = "애니메이션",
        type6 = "산책",
        type7 = "등산",
        type8 = "영화감상하기",
        type9 = "음주",
        type10 = "갓생살기2",
        type11 = "애니메이션2",
        type12 = "산책2",
        type13 = "등산2",
        type14 = "영화감상하기2",
        type15 = "음주2"
        
        var viewWidth: Int {
            (self.rawValue.count * 14) + 40
        }
    }
    
    @Published private(set) var userInterestMatrix: [[UserInterestType]] = []
    @Published private(set) var userInterestTypes: [UserInterestType] = []
    
    init() {
        self.userInterestMatrix = make2DArray(horizontalPadding: 12, spacing: 9)
    }
    
    func isTypeExists(type: UserInterestType) -> Bool {
        userInterestTypes.contains([type])
    }
    
    func insertType(type: UserInterestType) {
        userInterestTypes.append(type)
    }
    
    func removeType(type: UserInterestType) {

        userInterestTypes.removeAll { $0 == type }
    }
}


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
                            
                            SpotStateButton(text: Text(element.rawValue).font(.suite(type: .SUITE_Regular, size: 16)), idleColor: .spotLightGray, activeColor: .spotRed, frame: CGSize(width: element.viewWidth, height: 40)) {
                                
                                if viewModel.isTypeExists(type: element) {
                                    viewModel.removeType(type: element)
                                    return
                                }
                                
                                viewModel.insertType(type: element)
                                
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

extension SelectInterestsViewModel {
    func make2DArray(horizontalPadding: Int, spacing: Int) -> [[UserInterestType]] {
        // horizontal padding: 24, 요소당 간격 9
        let screenWidth = Int(UIScreen.main.bounds.width) - horizontalPadding*2 + spacing
        var items = UserInterestType.allCases
        
        var result: [[UserInterestType]] = []
        
        while !items.isEmpty {
            let itemCount = items.count
            var dp = Array(repeating: Array(repeating: 0, count: screenWidth + 1), count: itemCount+1)
            
            for itemNumebr in 1...itemCount {
                let itemIndex = itemNumebr-1
                let itemWidth = items[itemIndex].viewWidth + spacing //뷰간 간격 고려
                
                for width in 1...screenWidth {
                    if itemWidth <= width {
                        dp[itemNumebr][width] = max(dp[itemNumebr-1][width], 1 + dp[itemNumebr-1][width - itemWidth])
                    } else {
                        dp[itemNumebr][width] = dp[itemNumebr-1][width]
                    }
                }
            }
            
            var selectedItems: [Int] = []
            var w = screenWidth
            
            for itemNumber in stride(from: itemCount, to: 0, by: -1) {
                let itemIndex = itemNumber-1
                
                if dp[itemNumber][w] != dp[itemNumber - 1][w] {
                    selectedItems.append(itemIndex)
                    w -= items[itemIndex].viewWidth
                }
            }
            
            let temp = selectedItems.map { items[$0] }
            
            items = items.filter { element in !temp.contains { $0 == element } }
            
            result.append(temp)
        }
        return result
    }
}

#Preview {
    PreviewForProcessView {
        SelectInterestsView()
    }
}
