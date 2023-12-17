//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI
import GlobalFonts

/// RoundedRectagle모양의 버튼입니다. SUITE_SemiBold 폰트가 적용됩니다.
public struct SpotRoundedButton: View {
    
    var text: String
    var color: Color
    var action: () -> ()
    
    public init(text: String, color: Color, action: @escaping () -> Void) {
        self.text = text
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(text)
                    .font(.suite(type: .SUITE_SemiBold, size: 20))
                    .foregroundStyle(.white)
                    .frame(height: 25)
                Spacer()
            }
            .frame(height: 56)
        }
        .buttonStyle(.spotDefault(backgroundColor: color))
    }
}

/// Text 버튼으로 SUITE_Light 폰트가 적용됩니다.
public struct SpotTextButton: View {
    
    var text: String
    var color: Color
    var action: () -> ()
    
    public init(text: String, color: Color, action: @escaping () -> Void) {
        self.text = text
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(text)
                .font(.suite(type: .SUITE_Light, size: 18))
                .foregroundStyle(color)
                .frame(height: 22)
        }
    }
}
