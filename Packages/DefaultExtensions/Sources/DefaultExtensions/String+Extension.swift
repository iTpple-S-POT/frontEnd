//
//  String+Extension.swift
//
//
//  Created by 최준영 on 2023/11/29.
//

import SwiftUI

public extension String{
    /// 특정 폰트가 적용된 문자열의 너비를 구하는 Extension입니다.
    func getWidthWith(font: UIFont) -> CGFloat{
        
        let attributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        
        return size.width
    }
}
