//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/25.
//

import SwiftUI


// MARK: - make2DArray를 정의한 Extension입니다.
extension ConfigurationScreenModel {
    
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
    
    func make2DArray() -> [[UserInterestType]] {
        // horizontal padding: 24, 요소당 간격 9
        let containerWidth = Int(screenWidth - screenHorizontalPadding*2) + 1 + 9
        var items = UserInterestType.allCases
        var result: [[UserInterestType]] = []
        
        while !items.isEmpty {
            let itemCount = items.count
            var dp = Array(repeating: Array(repeating: 0, count: containerWidth + 1), count: itemCount+1)
            
            for itemNumebr in 1...itemCount {
                let itemIndex = itemNumebr-1
                let itemWidth = getViewSize(string: items[itemIndex].rawValue).width
                
                let itemValue = Int(itemWidth)
                let itemCost = Int(itemWidth) + 1 + 9 //오차로인한 1증가, 뷰간 간격 고려
                
                for width in 1...containerWidth {
                    if itemCost <= width {
                        dp[itemNumebr][width] = max(dp[itemNumebr-1][width], itemValue+dp[itemNumebr-1][width - itemCost])
                    } else {
                        dp[itemNumebr][width] = dp[itemNumebr-1][width]
                    }
                }
            }
            
            var selectedItemsIndice: [Int] = []
            var w = containerWidth
            
            for itemNumber in stride(from: itemCount, to: 0, by: -1) {
                let itemIndex = itemNumber-1
                let itemWidth = getViewSize(string: items[itemIndex].rawValue).width
                let itemCost = Int(itemWidth) + 1 + 9
                
                if dp[itemNumber][w] != dp[itemNumber - 1][w] {
                    selectedItemsIndice.append(itemIndex)
                    w -= itemCost
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




// MARK: - UserInterestType타입을 정의한 extension입니다.
extension ConfigurationScreenModel {
    enum UserInterestType: String, CaseIterable, Identifiable {
        var id: Self { self }
        
        case type1 = "영화",
        type2 = "자전거",
        type3 = "글쓰기",
        type4 = "갓생살기",
        type5 = "애니메이션",
        type6 = "산책",
        type7 = "다꾸",
        type8 = "독서",
        type9 = "뜨개질",
        type10 = "자동차",
        type11 = "와국어",
        type12 = "콘서트",
        type13 = "패션",
        type14 = "커리어",
        type15 = "식집자",
        type16 = "블로그",
        type17 = "미디어",
        type18 = "개발",
        type19 = "디자인",
        type20 = "기획",
        type21 = "베이킹",
        type22 = "피아노"
    }
}




// MARK: - 표시될 태그뷰들의 속성들 & 필요 매서드들을 저장한 extension입니다.
extension ConfigurationScreenModel {
    
    private var screenWidth: CGFloat { UIScreen.main.bounds.width }
    private var screenHorizontalPadding: CGFloat { 12 }
    private var viewHorizontalPadding: CGFloat { 20 }
    private var viewVerticalPadding: CGFloat { 12 }
    private var defaultTextHeight: CGFloat { 16 }
    private var maxTextWidth: CGFloat { screenWidth - screenHorizontalPadding*2 - viewHorizontalPadding*2 }
    
    // font
    var fontSize: CGFloat { 16 }
    var applyingFont: Font { .suite(type: .SUITE_Regular, size: fontSize) }
    var applyingUIFont: UIFont { .suite(type: .SUITE_Regular, size: fontSize) }

    
    /// Text라인에 상응하는 View의 높이를 반환합니다.
    func getViewSize(string: String) -> CGSize {
        
        // width
        let textWidth = string.getWidthWith(font: applyingUIFont)
        let viewWidth = (textWidth < maxTextWidth ? textWidth : maxTextWidth) + viewHorizontalPadding*2
        
        // height
        let lineCount = Int(textWidth / maxTextWidth) + 1
        
        let viewHeight = defaultTextHeight*CGFloat(lineCount) + viewVerticalPadding*2
        
        return CGSize(width: viewWidth, height: viewHeight)
    }
}
