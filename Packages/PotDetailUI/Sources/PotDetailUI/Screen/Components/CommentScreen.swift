//
//  SwiftUIView.swift
//  
//
//  Created by 최유빈 on 1/24/24.
//

import SwiftUI

struct CommentScreen: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Text("Comment")
                .navigationBarTitle("댓글 | 5개", displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(action: {
                        // 닫기 버튼 액션
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                )
        }
    }
}

#Preview {
    CommentScreen()
}
