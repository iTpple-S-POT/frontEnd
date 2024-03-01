//
//  EditViewNavBar.swift
//  UserInformationUI
//
//  Created by 최준영 on 2/26/24.
//

import SwiftUI

struct EditViewNavBar : View {
    
    var title: String
    
    var dismiss: () -> Void
    
    var onComplete: () -> Void
    
    var body: some View {
        
        VStack {
            
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
                        .onTapGesture(perform: { dismiss() })
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        
                        onComplete()
                        
                        dismiss()
                        
                    } label: {
                        Text("완료")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.spotRed)
                    }
                }
            }
            .padding(.horizontal, 21)
            .frame(height: 56)
            .background(
                Rectangle().fill(.white)
                    .shadow(color: .gray.opacity(0.3), radius: 2.0, y: 2)
            )
            
            Spacer()
        }
    }
}

