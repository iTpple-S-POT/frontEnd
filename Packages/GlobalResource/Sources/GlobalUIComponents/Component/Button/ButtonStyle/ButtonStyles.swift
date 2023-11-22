//
//  SPCustomButton.swift
//
//
//  Created by 최준영 on 2023/11/22.
//

import SwiftUI

/// Click Effect Bumping : 버튼을 눌를시 스케일이 증가된 후 줄어듭니다.
public struct CEBumping: ButtonStyle {
    let orgScale: CGFloat = 1
    let clkScale: CGFloat = 1.1
    let duration: CGFloat = 0.1
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? orgScale : clkScale)
            .animation(.easeInOut(duration: duration), value: configuration.isPressed)
    }
}
