////
////  SwiftUIView.swift
////  
////
////  Created by 최유빈 on 1/26/24.
////
//
//import SwiftUI
//import DefaultExtensions
//
//struct SelectEmoji: View {
//    let emojis = [["Fun", "Sad", "Angry"], ["Like", "Good"]]
//    
//    @State private var showingPopup = false
//    
//    var body: some View {
//        VStack(spacing: 40) {
//            HStack(spacing: 36) {
//                Button(action: {
//                }) {
//                    Text("🙂")
//                        .font(.system(size: 48))
//                }
//                
//                Button(action: {
//                }) {
//                    Text("😢")
//                        .font(.system(size: 48))
//                }
//                
//                Button(action: {
//                }) {
//                    Text("😡")
//                        .font(.system(size: 48))
//                }
//            }
//            
//            HStack(spacing: 36) {
//                Button(action: {
//                }) {
//                    Text("❤️")
//                        .font(.system(size: 48))
//                }
//                
//                Button(action: {
//                    self.showingPopup = true
//                }) {
//                    Text("👍")
//                        .font(.system(size: 48))
//                }
//                
//                if showingPopup {
//                    GoodPopUp(showingPopup: $showingPopup)
//                }
//            }
//        }
//        .background(Color.clear) // 이모지 선택기 배경색
//        .cornerRadius(20)
//    }
//}
//
//#Preview {
//    SelectEmoji()
//}
