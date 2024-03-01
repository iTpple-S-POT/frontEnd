//
//  SwiftUIView.swift
//  
//
//  Created by 최준영 on 2/27/24.
//

import SwiftUI

public struct RowTextButtonLabel: View {
    
    var title: String
    
    public init(title: String) {
        self.title = title
    }
    
    public var body: some View {
        
        HStack {
            
            Text(title)
                .font(.system(size: 18))
                .padding(.leading, 21)
                .foregroundStyle(.black)
            
            Spacer()
            
        }
        .frame(height: 56)
        .contentShape(Rectangle())
        .background(Rectangle().fill(.white))
        
    }
}

public struct RowTextButton: View {
    
    var title: String
    var onTap: () -> Void
    
    public init(title: String, onTap: @escaping () -> Void) {
        self.title = title
        self.onTap = onTap
    }
    
    public var body: some View {
        
        Button {
            
            onTap()
            
        } label: {
            
            RowTextButtonLabel(title: title)
        }
        
    }
}
