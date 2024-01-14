//
//  TextFieldStyle.swift
//  
//
//  Created by 최준영 on 1/14/24.
//

import SwiftUI

struct TappableTextFieldStyle: TextFieldStyle {
    
    @FocusState private var textFieldFocused: Bool
    
    var verPadding: CGFloat
    
    var horPadding: CGFloat
    
    init(verPadding: CGFloat, horPadding: CGFloat) {
        self.verPadding = verPadding
        self.horPadding = horPadding
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, verPadding)
            .padding(.horizontal, horPadding)
            .focused($textFieldFocused)
            .onTapGesture { textFieldFocused = true }
    }
    
}

struct FlexiblePaddingTextFieldStyle: TextFieldStyle {
    
    @FocusState private var textFieldFocused: Bool

    
    func _body(configuration: TextField<Self._Label>) -> some View {
        GeometryReader { geo in
            
            ZStack {
                
                configuration
                    .focused($textFieldFocused)
                
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .position(x: geo.size.width/2, y: geo.size.height/2)
            .contentShape(Rectangle())
            .onTapGesture { textFieldFocused = true }
            
        }
    }
    
}
