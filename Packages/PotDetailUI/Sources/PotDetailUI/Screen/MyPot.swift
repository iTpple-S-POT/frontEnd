//
//  SwiftUIView.swift
//  
//
//  Created by 최유빈 on 1/26/24.
//

import SwiftUI
import GlobalFonts
import DefaultExtensions

struct MyPot: View {
    let images = ["detail1", "detail2", "detail3", "detail4", "detail5"]

    @State private var isPresentingStoryScreen = false
    @State private var selectedImage: String?
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView {
                let width = (geometry.size.width - 6) / 2
                let columns = [
                    GridItem(.flexible(), spacing: 6),
                    images.count > 1 ? GridItem(.flexible(), spacing: 6) : nil
                ].compactMap { $0 }

                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(images, id: \.self) { imageName in
                        Button(action: {
                            self.selectedImage = imageName
                            self.isPresentingStoryScreen = true
                        })  {
                        ZStack(alignment: .topLeading) { // 상단 좌측 정렬
                            Image.makeImageFromBundle(bundle: .module, name: imageName, ext: .png)
                                .resizable()
                                .frame(width: images.count > 1 ? width : geometry.size.width, height: 256)
                                .cornerRadius(10)
                            
                            // TODO: 폰트수정
                            VStack(alignment: .leading, spacing: 4) { // 텍스트들을 VStack에 넣고 leading 정렬
                                Text("10분 전")
                                    .font(.suite(type: .SUITE_Regular, size: 14))
                                    .foregroundColor(.white)
                                    .padding(.leading, 16) // 왼쪽 여백
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MyPot()
}
