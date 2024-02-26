//
//  ReactionComfirmView.swift
//
//
//  Created by 최준영 on 2/26/24.
//

import SwiftUI
import GlobalObjects

struct ReactionComfirmView: View {
    
    @EnvironmentObject private var potModel: PotModel
    @EnvironmentObject private var viewModel: PotDetailViewModel
    
    var reactionModel: ReactionModel
    
    var body: some View {
        ZStack {
            
            GeometryReader { geo in
                
                reactionModel.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                    .position(x: geo.size.width/2, y: 0)
                
            }
            .zIndex(1.0)
            
            
            VStack(spacing: 0) {
                
                Spacer()
                Spacer()
                
                Text(reactionModel.title)
                    .font(.system(size: 24, weight: .semibold))
                
                Spacer()
                
                Text(reactionModel.content)
                    .font(.system(size: 16))
                
                Spacer()
                
                Button {
                    
                    viewModel.onDissmissReaction()
                    
                    Task {
                        
                        do {
                            
                            try await potModel.sendReaction(reactionType: reactionModel.reactionType)
                        } catch {

                            DispatchQueue.main.async {
                                
                                if let reactioError = error as? SpotNetworkError {
                                    
                                    if reactioError == .duplicatedReaction {
                                        
                                        return viewModel.showDuplicationFailed()
                                    }
                                }
                                
                                return viewModel.showSendingReactionFailed()
                            }
                        }
                    }
                    
                } label: {
                    
                    ZStack {
                        
                        Rectangle()
                            .fill(.red)
                            .frame(height: 48)
                        
                        Text("확인!")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .contentShape(Rectangle())
                }
            }
            .background(Rectangle().fill(.white))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
        }
        .frame(width: 240, height: 180)
    }
}

#Preview {
    ZStack {
        
        Color.black.opacity(0.5)
        
        
        
    }
}
