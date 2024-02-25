//
//  SwiftUIView.swift
//  
//
//  Created by 최준영 on 2024/01/13.
//

import SwiftUI

struct SpotNavigationBarView: View {
    
    var title: String
    
    var dismissAction: (() -> Void)?
    
    var body: some View {
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
                
        )
    }
}
