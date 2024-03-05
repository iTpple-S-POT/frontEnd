//
//  UploaderProfileView.swift
//
//
//  Created by 최준영 on 2/27/24.
//

import SwiftUI
import GlobalUIComponents
import GlobalObjects

struct UploaderProfileView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let userInfo: UserInfoObject
    
    var body: some View {
        ZStack {
            
            VStack {
                
                SpotNavigationBarView(title: "프로필") {
                    
                    dismiss()
                }
                
                Spacer()
            }
            .zIndex(1)
            
            VStack(spacing: 0) {
                
                SpotProfileDetailView(userInfo: userInfo)
                    .padding(.top, 56)
                
                Spacer()
            }
            .zIndex(0)
        }
    }
}

//#Preview {
//    UploaderProfileView()
//}
