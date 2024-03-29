//
//  SpotNavigationBarView.swift
//
//
//  Created by 최준영 on 2/26/24.
//

import SwiftUI

public struct SpotNavigationBarView: View {
    
    var title: String
    
    var dismissAction: (() -> Void)?
    
    public init(title: String, dismissAction: (() -> Void)? = nil) {
        self.title = title
        self.dismissAction = dismissAction
    }
    
    public var body: some View {
        ZStack {
            
            HStack(spacing: 0) {
                
                Spacer(minLength: 28)
                
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                
                Spacer()
                
            }
            
            HStack(spacing: 0) {
                
                Image(systemName: "chevron.backward")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 22)
                    .padding(.horizontal, 10)
                    .onTapGesture(perform: { dismissAction?() })
                
                Spacer(minLength: 0)
                
            }
            
        }
        .padding(.horizontal, 21)
        .frame(height: 56)
        .background(
            Rectangle().fill(.white)
                .shadow(color: .gray.opacity(0.3), radius: 2.0, y: 2)
        )
    }
}
