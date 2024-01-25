//
//  SwiftUIView.swift
//  
//
//  Created by 최유빈 on 1/24/24.
//

import SwiftUI

struct Comment: Identifiable {
    let id = UUID()
    let username: String
    let timeAgo: String
    let commentText: String
    let imageName: String
}

struct CommentRow: View {
    var comment: Comment
    
    var body: some View {
        HStack (alignment: .top, spacing: 8) {
            VStack {
                Image.makeImageFromBundle(bundle: .module, name: comment.imageName, ext: .png)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                    .padding(.top, 10)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack (spacing: 8){
                    Text(comment.username)
                        .font(.custom("Pretendard-SemiBold", size: 16))
                    
                    Text("|")
                        .font(.custom("Pretendard-Regular", size: 16))
                        .foregroundColor(.gray)
                    
                    Text(comment.timeAgo)
                        .font(.custom("Pretendard-Regular", size: 16))
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                
                Text(comment.commentText)
                    .font(.custom("Pretendard-Regular", size: 16))
                    .foregroundColor(.secondary)
                
                Button(action: {
                }) {
                    HStack (spacing: 4){
                        Image(systemName: "ellipsis.message")
                            .resizable()
                            .frame(width:20, height:20)
                        
                        Text("답글 3개")
                            .font(.custom("Pretendard-Regular", size: 16))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 16)
                
            }
        }
    }
}

struct CommentScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var comments = [
        Comment(username: "KIM2", timeAgo: "3시간", commentText: "농구를 이번에 처음하는 것인데 참여할 수 있을까요?", imageName: "Profile"),
        Comment(username: "인터파크", timeAgo: "3시간", commentText: "서서울호수공원 농구장 좋죠~", imageName: "Profile2")
    ]


    
    var body: some View {
        NavigationView {
            VStack {
                List(comments) { comment in
                CommentRow(comment: comment)
                }
                .listStyle(PlainListStyle())
                
                Divider()

                HStack {
                    TextField("댓글 추가하기", text: .constant(""))
                        .textFieldStyle(PlainTextFieldStyle())
                    Button(action: {
                    // 댓글 추가 로직
                    }) {
                        Image(systemName: "paperplane")
                            .foregroundColor(.gray)
                        }
                    }.padding()
                }
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
