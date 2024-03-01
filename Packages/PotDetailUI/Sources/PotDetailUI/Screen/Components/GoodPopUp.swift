//
//  SwiftUIView.swift
//  
//
//  Created by 최유빈 on 1/26/24.
//

import SwiftUI
import DefaultExtensions

struct GoodPopUp: View {
    @Binding var showingPopup: Bool
    @Binding var isPresentingEmojiPicker: Bool
    
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text("👍")
                    .font(.system(size: 80))

                Text("멋져요!")
                    .font(.title)
                    .fontWeight(.bold)

                Text("멋진 POT을 공유해 줬어요")
                    .font(.body)
                    .padding(.top, 12)

                Button(action: {
                    self.showingPopup = false
                    self.isPresentingEmojiPicker = false
                }) {
                    Text("확인")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.top, 31)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4))
        .edgesIgnoringSafeArea(.all)
    }
}

//#Preview {
//    GoodPopUp()
//}
