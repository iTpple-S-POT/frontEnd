//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI

/// Equatable인스턴스를 전달받아 일치할 경우 active상태가 되는 버튼이다.
/// Button의 Height는 고정되어 있으니 Width를 지정해야 한다.
public struct SpotStateButton: View {
    
    var innerView: AnyView
    
    var frame: CGSize
    
    var radius: CGFloat
    
    var idleColor: Color
    var activeColor: Color
    
    var changeTextColor: Bool
    
    var action: () -> ()
    
    var activation: () -> Bool
    
    public init(innerView: AnyView, idleColor: Color, activeColor: Color, changeTextColor: Bool = true, frame: CGSize, radius: CGFloat, action: @escaping () -> Void, activation: @escaping () -> Bool) {
        self.innerView = innerView
        self.idleColor = idleColor
        self.activeColor = activeColor
        self.changeTextColor = changeTextColor
        self.frame = frame
        self.radius = radius
        self.action = action
        self.activation = activation
    }
    
    
    public var body: some View {
        HStack(spacing: 0) {
            Spacer(minLength: radius)
            innerView
            Spacer(minLength: radius)
        }
        .frame(width: frame.width, height: frame.height)
        .foregroundStyle((activation() && changeTextColor) ? .white : .black)
        .background(
            PerfectRoundedRectangle()
                .foregroundStyle(activation() ? activeColor : idleColor)
        )
        .onTapGesture(perform: action)
        .animation(.easeInOut(duration: 0.1), value: activation())
    }
}

fileprivate struct TestView: View {
    @State private var state = true
    
    var body: some View {
        VStack {
            HStack {
                SpotStateButton(innerView: AnyView(Text("test1")), idleColor: .gray, activeColor: .green, frame: CGSize(width: CGFloat.infinity, height: 56), radius: 20) {
                    state = true
                } activation: {
                    state == true
                }
                SpotStateButton(innerView: AnyView(Text("test2")), idleColor: .gray, activeColor: .green, frame: CGSize(width: CGFloat.infinity, height: 56), radius: 20) {
                    state = false
                } activation: {
                    state == false
                }
            }
        }
    }
}

#Preview {
    TestView()
}
