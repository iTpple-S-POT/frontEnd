//
//  SwiftUIView.swift
//  
//
//  Created by 최유빈 on 1/27/24.
//

import SwiftUI

struct SearchDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Text("검색결과 6건")
                    .padding(.trailing, 250)
                SearchImageScreen()
                    .navigationBarTitle("해시태그 검색", displayMode: .inline)
                    .navigationBarItems(
                        leading: Button(action: {
                            // 백 버튼 액션
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                        })
            }
                
        }
    }
}

#Preview {
    SearchDetailView()
}
