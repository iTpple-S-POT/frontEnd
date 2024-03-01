//
//  View+Extension.swift
//
//
//  Created by 최준영 on 1/14/24.
//

import SwiftUI

// 플레이스 홀더 생성
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
