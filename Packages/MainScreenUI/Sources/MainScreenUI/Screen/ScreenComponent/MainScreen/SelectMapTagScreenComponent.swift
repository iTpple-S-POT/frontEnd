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
                
                LazyHStack(spacing: 12) {
                    
                    ForEach(TagCases.allCases) { tag in
                        
                        TagBox(selectedTag: viewModel.selectedTag, tag: tag, isSelected: viewModel.checkSelected(tag), action: {
                            
                            viewModel.selectTag(tag: tag)
                            
                        })
                        .id(tag)
                    
                    }
                    
                }
                .padding(.leading, 21)
            }
            .scrollIndicators(.hidden)
            .onChange(of: viewModel.selectedTag) { tag in
                withAnimation(.easeInOut(duration: 0.5)) {
                    proxy.scrollTo(tag, anchor: .center)
                }
            }
        }
    }
}

#Preview {
    SelectMapTagScreenComponent()
        .frame(height: 64)
}
