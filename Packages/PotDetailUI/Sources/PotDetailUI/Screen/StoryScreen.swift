//
//  SwiftUIView.swift
//  
//
//  Created by 최유빈 on 1/24/24.
//

import SwiftUI
import DefaultExtensions

public struct StoryScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingEmojiPicker = false 
    
    @State private var isPresentingCommentScreen = false
    @State private var isPresentingEmojiPicker = false
    
    @State private var showingPopup = false
    
    public init() {
        
    }
    public var body: some View {
        ZStack {
            
            Image.makeImageFromBundle(bundle: .module, name: "basketball", ext: .png)
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack() {
                HStack() {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Image.makeImageFromBundle(bundle: .module, name: "Label_party", ext: .png)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .frame(width: 20, height: 3)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                
                
                Spacer()
                
                VStack {
                    HStack(spacing: 8) {
                        Image.makeImageFromBundle(bundle: .module, name: "Clock", ext: .png)
                            .resizable()
                            .frame(width:20, height: 20)
                            .foregroundColor(.white)
                            .padding(.leading, 21)
                        Text("10시간 전")
                            .font(.custom("Pretendard-SemiBold", size: 16))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    HStack {
                        Image.makeImageFromBundle(bundle: .module, name: "Eye", ext: .png)
                            .resizable()
                            .frame(width:20, height: 20)
                            .foregroundColor(.white)
                            .padding(.leading, 21)
                        Text("20")
                            .font(.custom("Pretendard-SemiBold", size: 16))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Image.makeImageFromBundle(bundle: .module, name: "Profile", ext: .png)
                            .resizable()
                            .frame(width: 40, height: 40)
                        
                        Text("Mini12")
                            .foregroundColor(.white)
                            .font(.custom("Pretendard-SemiBold", size: 20))
                    }
                    
                    Text("농구 같이 하실 분 모집 받아요! 양천구 서서울 호수공원에서 할 예정입니다.")
                        .padding(.trailing)
                        .frame(width: 320)
                        .foregroundColor(.white)
                    
                    Button(action: {}) {
                        Text("더보기")
                            .font(.custom("Pretendard-SemiBold", size: 16))
                            .foregroundColor(.white)
                            .underline()
                    }
                    
                    HStack {
                        HashTag()
                    }.frame(width:320)
                }
                .padding(.trailing, 21)
                .padding(.bottom, 92)
            
            }
            HStack(){
                VStack(spacing: 16) {
                    Button(action: {
                        self.isPresentingEmojiPicker = true
                    }) {
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
                .animation(.easeInOut)
                .transition(.opacity)
                .frame(width: 32)
                    .padding(.top, 150)
                    .padding(.leading, 337)
            }
            if isPresentingEmojiPicker {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPresentingEmojiPicker = false
                    }
                VStack(spacing: 40) {
                    HStack(spacing: 36) {
                        Button(action: {
                        }) {
                            Text("🙂")
                                .font(.system(size: 48))
                        }
                        
                        Button(action: {
                        }) {
                            Text("😢")
                                .font(.system(size: 48))
                        }
                        
                        Button(action: {
                        }) {
                            Text("😡")
                                .font(.system(size: 48))
                        }
                    }
                    
                    HStack(spacing: 36) {
                        Button(action: {
                        }) {
                            Text("❤️")
                                .font(.system(size: 48))
                        }
                        
                        Button(action: {
                            self.showingPopup = true
                        }) {
                            Text("👍")
                                .font(.system(size: 48))
                        }
                        
                    }
                }
                .background(Color.clear) // 이모지 선택기 배경색
                .cornerRadius(20)
                    .frame(width: 300, height: 300)// 원하는 크기로 조절
                    .background(Color.clear) // 이모지 선택기의 배경색
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding(.horizontal, 20)
        }
            if showingPopup {
                GoodPopUp(showingPopup: $showingPopup, isPresentingEmojiPicker: $isPresentingEmojiPicker)
            }
        }
    }
}

#Preview {
    StoryScreen()
}
