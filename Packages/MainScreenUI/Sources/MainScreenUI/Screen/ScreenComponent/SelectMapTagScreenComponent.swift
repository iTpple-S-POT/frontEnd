//
//  SelectMapTagScreenComponent.swift
//
//
//  Created by 최준영 on 2023/12/24.
//

import SwiftUI
import GlobalUIComponents
import GlobalFonts

struct SelectMapTagScreenComponent: View {
       
    // TODO: 현재 스크린 컴포넌트의 상태를 관리하는 타입생성후 이동
    
    // 이동예정
    @State private var selectedTags: [TagCases:Bool] = [:]
    
    // 이동예정
    @State private var nowSelectedTag: TagCases?
    
    var body: some View {
        ScrollViewReader { proxy in
            
            ScrollView(.horizontal) {
                
                LazyHStack(spacing: 8) {
                    
                    ForEach(TagCases.allCases) { tag in
                        
                        let innerView = AnyView(HStack(spacing: 6) {
                            if tag != .all {
                                tag.getIconImage()
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                            }
                            
                            Text(tag.getTextString())
                                .font(.suite(type: .SUITE_Regular, size: 16))
                        })
                        
                        let uiFont = UIFont.suite(type: .SUITE_Regular, size: 16)
                        
                        let itemWidth = tag.getTextString().getWidthWith(font: uiFont) + (tag == .all ? 0 : 34) + 32
                        
                        let btn_frame = CGSize(width: itemWidth, height: 40)
                        
                        SpotStateButton(
                            innerView: innerView,
                            idleColor: .btn_light_grey,
                            activeColor: .btn_red,
                            changeTextColor: false,
                            frame: btn_frame,
                            radius: 16) {
                            
                            nowSelectedTag = tag
                            
                            if selectedTags[tag] != nil {
                                
                                if selectedTags[tag]! {
                                    selectedTags[tag] = false
                                } else {
                                    selectedTags[tag] = true
                                }
                                
                                return
                            }
                            
                            selectedTags[tag] = true
                            
                        } activation: {
                            
                            return selectedTags[tag] ?? false
                            
                        }
                        .id(tag)
                    
                    }
                    
                }
                .padding(.leading, 12)
                
            }
            .scrollIndicators(.hidden)
            .onChange(of: nowSelectedTag) { tag in
                withAnimation(.easeInOut(duration: 0.5)) {
                    nowSelectedTag = nil
                    proxy.scrollTo(tag, anchor: .leading)
                }
            }
            
        }
        .padding(.vertical, 12)
        .shadow(color: .gray, radius: 1.0)
        .background(
            Rectangle()
                .fill(.white)
                .shadow(color: .gray.opacity(0.3), radius: 2.0, x: 0, y: 2.0)
        )
    }
    
}

extension SelectMapTagScreenComponent {
    
    enum TagCases: String, Identifiable, CaseIterable {
        case all = "all"
        case event = "event"
        case life = "life"
        case question = "question"
        case information = "information"
        case party = "party"
        
        var id: String { self.rawValue }
        
        func getIconImage() -> Image {
            
            if self == .all {
                preconditionFailure("all태그는 이미지가 없습니다.")
            }
            
            let imageName = self.rawValue + "_tag"
            
            return Image.makeImageFromBundle(bundle: Bundle.module, name: imageName, ext: .png)
        }
        
        func getTextString() -> String {
            
            var textStr = ""
            
            switch self {
            case .all:
                textStr = "모두 보기"
            case .event:
                textStr = "사건/사고"
            case .life:
                textStr = "일상"
            case .question:
                textStr = "질문"
            case .information:
                textStr = "정보"
            case .party:
                textStr = "모임"
            }
            
            return textStr
        }
    }
}

#Preview {
    SelectMapTagScreenComponent()
        .frame(height: 64)
}
