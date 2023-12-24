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
       
    @StateObject private var viewModel = SelectMapTagViewModel()
    
    var body: some View {
        ScrollViewReader { proxy in
            
            ScrollView(.horizontal) {
                
                LazyHStack(spacing: 8) {
                    
                    ForEach(SelectMapTagViewModel.TagCases.allCases) { tag in
                        
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
                            
                                viewModel.selectTag(tag: tag)
                            
                            
                        } activation: {
                            
                            return viewModel.selectedTagDict[tag]!
                        
                        }
                        .id(tag)
                    
                    }
                    
                }
                .padding(.leading, 12)
                
            }
            .scrollIndicators(.hidden)
            .onChange(of: viewModel.selectedTag) { tag in
                withAnimation(.easeInOut(duration: 0.5)) {
                    viewModel.clearSelectedTag()
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

#Preview {
    SelectMapTagScreenComponent()
        .frame(height: 64)
}
