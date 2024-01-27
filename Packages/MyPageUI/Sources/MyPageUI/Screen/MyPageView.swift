//
//  SwiftUIView.swift
//  
//
//  Created by 최유빈 on 1/27/24.
//

import SwiftUI
import DefaultExtensions

struct MyPageView: View {
    let myPots = ["pot1", "pot2", "pot3", "pot4"] // 이미지 이름 배열
    let recentPots = ["pot5", "pot6", "pot1", "pot2"] // 이미지 이름 배열

       var body: some View {
           VStack {
               HStack {
                   Text("마이페이지")
                       .font(.system(size: 20))
                       .bold()
                       .padding(.leading, 21)
                   
                   Spacer()
                   
                   Image(systemName: "gearshape")
                       .resizable()
                       .frame(width: 32, height: 32)
                       .padding(.trailing, 21)
                   
               }
               GradientBackgroundView()
                   .frame(height: 274)
               Divider()
               ScrollView {
                   VStack {
                       VStack(alignment: .leading) {
                           HStack {
                               Text("내가 작성한 POT")
                                   .bold()
                                   .font(.system(size: 18))
                                   .padding(.leading, 21)
                                   .padding(.top, 24)
                               
                               Spacer()
                               
                               Button(action: {
                                   
                               }) {
                                   Text("모두보기")
                                       .font(.system(size: 16))
                                       .foregroundColor(.black)
                                       .padding(.trailing, 21)
                                       .padding(.top, 24)
                                       
                               }
                               
                           }
                           
                           ScrollView(.horizontal, showsIndicators: false) {
                               HStack(spacing: 8) {
                                   ForEach(myPots, id: \.self) { potName in
//                                       Image(potName)
                                       Image.makeImageFromBundle(bundle: .module, name: potName, ext: .png)
                                           .resizable()
                                           .frame(width: 134, height: 179)
                                           .cornerRadius(10)
                                           .padding(.leading)
                                   }
                               }
                           }
                       }
                       
                       // 최근 본 POT
                       VStack(alignment: .leading) {
                           HStack {
                               Text("최근 본 POT")
                                   .bold()
                                   .font(.system(size: 18))
                                   .padding(.leading, 21)
                                   .padding(.top, 24)
                               
                               Spacer()
                               
                               Button(action: {
                                   
                               }) {
                                   Text("모두보기")
                                       .font(.system(size: 16))
                                       .foregroundColor(.black)
                                       .padding(.trailing, 21)
                                       .padding(.top, 24)
                                       
                               }
                               
                           }
                           
                           ScrollView(.horizontal, showsIndicators: false) {
                               HStack {
                                   ForEach(recentPots, id: \.self) { potName in
                                       Image.makeImageFromBundle(bundle: .module, name: potName, ext: .png)
                                           .resizable()
                                           .frame(width: 134, height: 179)
                                           .cornerRadius(10)
                                           .padding(.leading)
                                   }
                               }
                           }
                       }
                   }
               }
           }
       }
}

struct ProfileView: View {
    @State private var isShowingProfile = true
    
    var body: some View {
        VStack(spacing: 8){
            Image.makeImageFromBundle(bundle: .module, name: "MyProfile", ext: .png)
                .resizable()
                .frame(width: 84, height: 100)
            
            Text("잇플")
                .font(.headline)
                .padding(.top, 4)
            
            Text("카카오톡 회원")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Button(action: {
                self.isShowingProfile.toggle()
            }) {
                Text("내 프로필 보기")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .cornerRadius(20)
            }
            .frame(width: 140, height:40)
            .padding(.top, 16)
            .fullScreenCover(isPresented: $isShowingProfile) {
                MyProfileView()
            }
        }
    }
}

struct GradientBackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // 원형 모양을 그라데이션 뷰 아래에 위치시켜서 마스크 효과를 줍니다.
                ZStack {
                    Image.makeImageFromBundle(bundle: .module, name: "rectangle", ext: .png)
                        .resizable()
                        .frame(width:430, height: 200)
                        .offset(y: geometry.size.height * 0.2)
                    
                    ProfileView()
                }
            }
            .frame(width: geometry.size.width, height: 250)
            .background(
                // 원하는 그라데이션을 여기에 적용합니다.
                LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.5), Color.orange]), startPoint: .top, endPoint: .bottom)
            )
        }
    }
}
#Preview {
    MyPageView()
}
