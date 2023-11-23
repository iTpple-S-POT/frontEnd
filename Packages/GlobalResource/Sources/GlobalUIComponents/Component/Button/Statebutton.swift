//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI

/// Equatable인스턴스를 전달받아 일치할 경우 active상태가 되는 버튼이다.
/// Button의 Height는 고정되어 있으니 Width를 지정해야 한다.
public struct SpotStateButton<Value: Equatable>: View {
    
    var text: String
    
    @Binding var state: Value
    
    var targetState: Value
    
    var idleColor: Color
    var activeColor: Color
    
    var action: () -> ()
    
    private var isActive: Bool { state == targetState }
    
    public init(text: String, state: Binding<Value>, targetState: Value, idleColor: Color, activeColor: Color, action: @escaping () -> Void) {
        self.text = text
        self._state = state
        self.targetState = targetState
        self.idleColor = idleColor
        self.activeColor = activeColor
        self.action = action
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            Text(text)
                .font(.suite(type: .SUITE_Regular, size: 18))
            Spacer(minLength: 0)
        }
        .foregroundStyle(isActive ? .white : .black)
        .frame(height: 56)
        .background(
            PerfectRoundedRectangle()
                .foregroundStyle(isActive ? activeColor : idleColor)
        )
        .onTapGesture(perform: action)
        .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}

fileprivate struct TestView: View {
    @State private var state = true
    
    var body: some View {
        VStack {
            HStack {
                SpotStateButton(text: "test1", state: $state, targetState: true, idleColor: .gray, activeColor: .green) {
                    state = true
                }
                SpotStateButton(text: "test2", state: $state, targetState: false, idleColor: .gray, activeColor: .green) {
                    state = false
                }
            }
        }
    }
}

#Preview {
    TestView()
}
