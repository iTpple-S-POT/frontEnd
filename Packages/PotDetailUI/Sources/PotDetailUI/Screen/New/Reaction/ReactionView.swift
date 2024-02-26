//
//  ReactionView.swift
//
//
//  Created by 최준영 on 2/26/24.
//

import SwiftUI
import DefaultExtensions

struct ReactionView: View {
    
    @EnvironmentObject private var viewModel: PotDetailViewModel
    
    private let iconWidth: CGFloat = 56
    
    var body: some View {
        ZStack {
            
            Color(hex: "221E1D", alpha: 0.7)
                .ignoresSafeArea(.all)
            
            if let reactionModel = viewModel.selectedReactionModel {
                
                ReactionComfirmView(reactionModel: reactionModel)
            } else {
                
                VStack(spacing: 50) {
                    
                    HStack {
                        
                        Spacer()
                        Spacer()
                        
                        Button {
                            
                            viewModel.selectedReactionModel = SpotReaction.smile
                        } label: {
                            
                            SpotReaction.smile.image
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconWidth)
                        }
                        .disabled(viewModel.selectedReactionModel != nil)
                        
                        Spacer()
                        
                        
                        Button {
                            
                            viewModel.selectedReactionModel = SpotReaction.sad
                        } label: {
                            
                            SpotReaction.sad.image
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconWidth)
                        }
                        .disabled(viewModel.selectedReactionModel != nil)
                        
                        Spacer()
                        
                        Button {
                            
                            viewModel.selectedReactionModel = SpotReaction.anger
                        } label: {
                            
                            SpotReaction.anger.image
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconWidth)
                        }
                        .disabled(viewModel.selectedReactionModel != nil)
                        
                        Spacer()
                        Spacer()
                        
                    }
                    
                    HStack {
                        
                        Spacer()
                        Spacer()
                        Spacer()
                        
                        Button {
                            
                            viewModel.selectedReactionModel = SpotReaction.like
                        } label: {
                            
                            SpotReaction.like.image
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconWidth)
                        }
                        .disabled(viewModel.selectedReactionModel != nil)
                        
                        Spacer()
          
                        Button {
                            
                            viewModel.selectedReactionModel = SpotReaction.heart
                        } label: {
                            
                            SpotReaction.heart.image
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconWidth)
                        }
                        .disabled(viewModel.selectedReactionModel != nil)

                        Spacer()
                        Spacer()
                        Spacer()
                        
                    }
                }
            }
            
        }
        .animation(.easeInOut(duration: viewModel.animTime), value: viewModel.selectedReactionModel)
    }
}

#Preview {
    ReactionView()
}
