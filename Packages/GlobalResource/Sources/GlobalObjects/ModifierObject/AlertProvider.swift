//
//  AlertProvider.swift
//
//
//  Created by 최준영 on 1/18/24.
//

import SwiftUI

public struct AlertProvider: ViewModifier {
    
    @Binding var showAlert: Bool
    
    var title: String
    var message: String
    
    public init(showAlert: Binding<Bool>, title: String, message: String) {
        self._showAlert = showAlert
        self.title = title
        self.message = message
    }
    
    public func body(content: Content) -> some View {
        
        content
            .alert(isPresented: $showAlert) {
                Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("닫기")))
            }
        
    }
    
}
