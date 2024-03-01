//
//  BelowTexxtView.swift
//  OnBoardingUI
//
//  Created by 최준영 on 2/29/24.
//

import SwiftUI

struct BelowTextView: View {
    
    var innerTextView: AnyView
    
    @Binding var currentState: PotOnboardingStage
    
    var onStart: () -> Void
    
    var body: some View {
        VStack {
            
            innerTextView
            
            Spacer(minLength: 0)
            
            ZStack {
                
                HStack {
                    
                    if currentState.rawValue != 0 {
                        
                        Text("이전")
                            .font(.system(size: 14))
                            .onTapGesture {
                                
                                currentState = PotOnboardingStage(rawValue: currentState.rawValue-1)!
                            }
                    }
                    
                    
                    Spacer()
                    
                    if currentState.rawValue != 2 {
                        
                        Text("다음")
                            .font(.system(size: 14))
                            .onTapGesture {
                                
                                currentState = PotOnboardingStage(rawValue: currentState.rawValue+1)!
                            }
                        
                    } else {
                        
                        Text("시작하기")
                            .font(.system(size: 14))
                            .onTapGesture {
                                onStart()
                            }
                    }
                }
                
                HStack {
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        
                        ForEach(PotOnboardingStage.allCases, id: \.rawValue) { item in
                            
                            BallBar() {
                                return currentState == item
                            }
                        }
                        .animation(.easeInOut, value: currentState)
                    }
                    
                    Spacer()
                }
            }
        }
            .padding(24)
    }
}

struct BallBar: View {
    
    var width: CGFloat = 8
    
    var activeWidth: CGFloat = 20
    
    var activeCondition: () -> Bool
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: width/2)
            .fill(activeCondition() ? .red : .innerBackgroundColor)
            .frame(width: activeCondition() ? activeWidth : width, height: width)
        
    }
    
}

#Preview {
    
    BelowTextView(innerTextView: AnyView(Text("Hello world")), currentState: .constant(.AStage)) {
        
    }
        .padding(.horizontal, 24)
}
