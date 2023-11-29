//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/25.
//

import SwiftUI


class SelectInterestsViewModel: ObservableObject {
    
    @Published private(set) var userInterestMatrix: [[UserInterestType]] = []
    @Published private(set) var userInterestTypes: [UserInterestType:Bool] = [:]
    
    init() {
        self.userInterestMatrix = make2DArray(horizontalPadding: 12, spacing: 9)
        
        UserInterestType.allCases.forEach { type in
            userInterestTypes[type] = false
        }
    }
    
    func isTypeExists(type: UserInterestType) -> Bool {
        guard let result = userInterestTypes[type] else {
            fatalError("userInterestTypes에 등록되지 않은 관심사 입니다")
        }
        return result
    }
    
    func selectType(type: UserInterestType) {
        userInterestTypes[type]? = true
    }
    
    func deSelectType(type: UserInterestType) {
        userInterestTypes[type]? = false
    }
}

/// make2DArray를 정의한 Extension입니다.
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
                let itemWidth = Int(items[itemIndex].viewWidth) + spacing //뷰간 간격 고려
                
                for width in 1...screenWidth {
                    if itemWidth <= width {
                        dp[itemNumebr][width] = max(dp[itemNumebr-1][width], 1 + dp[itemNumebr-1][width - itemWidth])
                    } else {
                        dp[itemNumebr][width] = dp[itemNumebr-1][width]
                    }
                }
            }
            
            var selectedItemsIndice: [Int] = []
            var w = screenWidth
            
            for itemNumber in stride(from: itemCount, to: 0, by: -1) {
                let itemIndex = itemNumber-1
                
                if dp[itemNumber][w] != dp[itemNumber - 1][w] {
                    selectedItemsIndice.append(itemIndex)
                    w -= Int(items[itemIndex].viewWidth)
                }
            }
            
            // 뷰들의 크기는 스크린 사이즈를 넘을 수 없지만 오류의 여지가 있을 수 있음으로 해당코드를 추가했다.
            if selectedItemsIndice.isEmpty {
                items.forEach { result.append([$0]) }
                break
            }
            
            // selectedItemsIndice는 역순으로 추출되었음으로 배열을 reverse해줍니다.
            selectedItemsIndice.reverse()
            
            // result배열에 선택된 아이템들을 추가합니다.
            result.append(selectedItemsIndice.map { items[$0] })
            
            var itemsIndex = 0                      // items배열에 사용될 인덱스 입니다.
            var selectedItemsIndex = 0              // selectedItemsIndice배열에 사용될 인덱스 입니다.
            
            // selectedItemsIndice에 존재하지 않는 index를 저장하는 배열입니다.
            // 이배열에 저장될 index는 items배열의 요소와 매칭됩니다.
            // 현재 추출범위는 items배열의 크기와 일치합니다.
            var restItems: [UserInterestType] = []
            
            
            while itemsIndex < items.count {
                
                // 배제할 아이템(선택된 아이템)이 존재하는 경우 && 탐색중인 요소가 배체할 아이템인 경우
                if selectedItemsIndex < selectedItemsIndice.count && itemsIndex == selectedItemsIndice[selectedItemsIndex] {
                    selectedItemsIndex+=1
                } else {
                    restItems.append(items[itemsIndex])
                }
                itemsIndex+=1;
            }
            
            // items배열을 선택되지 못한 아이템들로 구성합니다.
            items = restItems
        }
        return result
    }
}

/// UserInterestType타입을 정의한 extension입니다.
extension SelectInterestsViewModel {
    enum UserInterestType: String, CaseIterable, Identifiable {
        var id: Self { self }
        
        private var screenWdith: CGFloat { UIScreen.main.bounds.width }
        private var screenHorizontalPadding: CGFloat { 12 }
        private var viewHorizontalPadding: CGFloat { 20 }
        private var defaultViewHeight: CGFloat { 40 }
        private var maxTextWidth: CGFloat { screenWdith - screenHorizontalPadding*2 - viewHorizontalPadding*2 }
        
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
        type15 = "음주2",
        type16 = "메우긴 텍스트 입니다. 이것은 메우긴 텍스트 입니다. 메우긴 텍스트 입니다. 메우긴 텍스트 입니다. 메우긴 텍스트 입니다.1",
        type17 = "메우긴 텍스트 입니다. 이것은 메우긴 텍스트 입니다. 메우긴 텍스트 입니다. 메우긴 텍스트 입니다. 메우긴 텍스트 입니다.2"
        
        
        /// 특정 font가 적용된 문자열의 너비를 반환합니다.
        private func getTextWidthWith() -> CGFloat {
            let width = self.rawValue.getWidthWith(font: applyingUIFont)
            print(self.rawValue, width)
            return width > maxTextWidth ? maxTextWidth : width
        }
        
        // font
        var fontSize: CGFloat { 16 }
        var applyingFont: Font { .suite(type: .SUITE_Regular, size: fontSize) }
        var applyingUIFont: UIFont { .suite(type: .SUITE_Regular, size: fontSize) }
        
        /// View의 Width를 반환합니다.
        var viewWidth: CGFloat { getTextWidthWith() + viewHorizontalPadding*2 }
        
        /// Text라인에 상응하는 View의 높이를 반환합니다.
        var viewHeight: CGFloat {
            
            let verticalPadding = (defaultViewHeight - fontSize) / 2
            
            let textWidth = getTextWidthWith()
            
            let lineCount = Int(textWidth / maxTextWidth) + 1
            
            print(self.rawValue, lineCount)
            
            return fontSize * CGFloat(lineCount) + verticalPadding*2
        }
        
        /// UserInterestType 아이템이 사용될 View의 크기를 반환합니다.
        var viewSize: CGSize { CGSize(width: viewWidth, height: viewHeight) }
    }
}
