//
//  SwiftUIView.swift
//  
//
//  Created by 최유빈 on 1/24/24.
//

import SwiftUI

struct LikeCommentShare: View {
    
    @State private var isPresentingCommentScreen = false
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: {}) {
                VStack {
                    Image(systemName: "hand.thumbsup.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .padding(.vertical, 2)
                    Text("100")
                        .font(.custom("Pretendard-SemiBold", size: 12))
                        .foregroundColor(.white)
                }
            }
            
            Button(action: {
                self.isPresentingCommentScreen = true
            }) {
                VStack {
                    Image(systemName: "ellipsis.message.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .padding(.vertical, 2)
                    Text("53")
                        .font(.custom("Pretendard-SemiBold", size: 12))
                        .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $isPresentingCommentScreen) {
                CommentScreen()
            }
            
            Button(action: {}) {
                VStack {
                    Image(systemName: "arrowshape.turn.up.right.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .padding(.vertical, 2)
                    Text("공유")
                        .font(.custom("Pretendard-SemiBold", size: 12))
                        .foregroundColor(.white)
                }
            }
        }
        .frame(width: 32)
    }
}

#Preview {
    LikeCommentShare()
}
