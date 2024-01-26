//
//  SwiftUIView.swift
//  
//
//  Created by 최유빈 on 1/27/24.
//

import SwiftUI

struct MyProfileView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 16, height: 20)
                    .foregroundColor(.black)
                    .padding(.leading, 21)
            })
            
            Spacer()
            
            Text("내 프로필")
                .font(.system(size: 20))
                .bold()
            
            Spacer()
            
            Image(systemName: "pencil")
                .resizable()
                .frame(width: 20, height: 20)
                .padding(.trailing, 21)
            
        }
        .frame(height: 56)
        
        MyGradientBackgroundView()
            .frame(height: 220)
        
        Divider()
        
        VStack(spacing: 12) {
            VStack(spacing: 8){
                HStack {
                    Text("생년월일")
                        .font(.system(size: 18))
                        .padding(.top, 24)
                        .padding(.leading, 21)
                    
                    
                    Spacer()
                }
                HStack {
                    Text("2001년 1월 16일")
                        .font(.system(size: 16)) // 글자 크기 설정
                        .padding(.vertical, 10) // 세로 패딩
                        .padding(.horizontal, 20) // 가로 패딩
                        .foregroundColor(Color.red) // 글자 색상 설정
                        .overlay(
                            RoundedRectangle(cornerRadius: 25) // 둥근 모서리의 사각형
                            .stroke(Color.red, lineWidth: 2) // 테두리 색상과 두께 설정
                        )
                        .padding(.leading, 21)
                    Spacer()
                }
            }
            
            VStack(spacing: 8){
                HStack {
                    Text("성별")
                        .font(.system(size: 18))
                        .padding(.top, 24)
                        .padding(.leading, 21)
                    
                    
                    Spacer()
                }
                HStack {
                    Text("여성")
                        .font(.system(size: 16)) // 글자 크기 설정
                        .padding(.vertical, 10) // 세로 패딩
                        .padding(.horizontal, 20) // 가로 패딩
                        .foregroundColor(Color.red) // 글자 색상 설정
                        .overlay(
                            RoundedRectangle(cornerRadius: 25) // 둥근 모서리의 사각형
                            .stroke(Color.red, lineWidth: 2) // 테두리 색상과 두께 설정
                        )
                        .padding(.leading, 21)
                    Spacer()
                }
            }
            
            VStack(spacing: 8){
                HStack {
                    Text("MBTI")
                        .font(.system(size: 18))
                        .padding(.top, 24)
                        .padding(.leading, 21)
                    
                    
                    Spacer()
                }
                HStack(spacing: 12) {
                    Text("ENFP")
                        .font(.system(size: 16)) // 글자 크기 설정
                        .padding(.vertical, 10) // 세로 패딩
                        .padding(.horizontal, 20) // 가로 패딩
                        .foregroundColor(Color.red) // 글자 색상 설정
                        .overlay(
                            RoundedRectangle(cornerRadius: 25) // 둥근 모서리의 사각형
                            .stroke(Color.red, lineWidth: 2) // 테두리 색상과 두께 설정
                        )
                        .padding(.leading, 21)
                    
                    Text("재기발랄한 활동가")
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                    Spacer()
                }
            }
            
            VStack(spacing: 8){
                HStack {
                    Text("취미와 관심사")
                        .font(.system(size: 18))
                        .padding(.top, 24)
                        .padding(.leading, 21)
                    
                    
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        Text("뜨개질")
                            .font(.system(size: 14)) // 글자 크기 설정
                            .padding(.vertical, 8) // 세로 패딩
                            .padding(.horizontal, 20) // 가로 패딩
                            .foregroundColor(Color.red) // 글자 색상 설정
                            .overlay(
                                RoundedRectangle(cornerRadius: 15) // 둥근 모서리의 사각형
                                    .stroke(Color.red, lineWidth: 2) // 테두리 색상과 두께 설정
                            )
                            .padding(.leading, 21)
                        
                        Text("식집사")
                            .font(.system(size: 14)) // 글자 크기 설정
                            .padding(.vertical, 8) // 세로 패딩
                            .padding(.horizontal, 20) // 가로 패딩
                            .foregroundColor(Color.red) // 글자 색상 설정
                            .overlay(
                                RoundedRectangle(cornerRadius: 25) // 둥근 모서리의 사각형
                                    .stroke(Color.red, lineWidth: 2) // 테두리 색상과 두께 설정
                            )
                        
                        Text("글쓰기")
                            .font(.system(size: 14)) // 글자 크기 설정
                            .padding(.vertical, 8) // 세로 패딩
                            .padding(.horizontal, 20) // 가로 패딩
                            .foregroundColor(Color.red) // 글자 색상 설정
                            .overlay(
                                RoundedRectangle(cornerRadius: 25) // 둥근 모서리의 사각형
                                    .stroke(Color.red, lineWidth: 2) // 테두리 색상과 두께 설정
                            )
                        
                        Text("기획")
                            .font(.system(size: 14)) // 글자 크기 설정
                            .padding(.vertical, 8) // 세로 패딩
                            .padding(.horizontal, 20) // 가로 패딩
                            .foregroundColor(Color.red) // 글자 색상 설정
                            .overlay(
                                RoundedRectangle(cornerRadius: 25) // 둥근 모서리의 사각형
                                    .stroke(Color.red, lineWidth: 2) // 테두리 색상과 두께 설정
                            )
                    }
                }
            }

            
        }
        Spacer()
    }
}

struct MyProfile: View {
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

        }
    }
}

struct MyGradientBackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // 원형 모양을 그라데이션 뷰 아래에 위치시켜서 마스크 효과를 줍니다.
                ZStack {
                    Image.makeImageFromBundle(bundle: .module, name: "rectangle", ext: .png)
                        .resizable()
                        .frame(width:430, height: 200)
                        .offset(y: geometry.size.height * 0.2)
                    
                    MyProfile()
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
    MyProfileView()
}
