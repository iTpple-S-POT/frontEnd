//
//  PotOnboardingView.swift
//  OnBoardingUI
//
//  Created by 최준영 on 2/29/24.
//

import SwiftUI
import DefaultExtensions
import GlobalUIComponents

extension Color {
    
    static let backgroundColor = Color.init(hex: "221E1D", alpha: 0.7)
    
    static let innerBackgroundColor = Color.init(hex: "3B3B3B")
}

enum PotOnboardingStage: Int, CaseIterable {
    
    case AStage, BStage, CStage
    
    func getImage() -> AnyView {
        switch self {
        case .AStage:
            return AnyView(POAImage())
        case .BStage:
            return AnyView(POBImage())
        case .CStage:
            return AnyView(POCImage())
        }
    }
    
    func getView() -> AnyView {
        
        switch self {
        case .AStage:
            return AnyView(VStack {
                
                DynamicText("POT의 카테고리를 선택해 주세요", weight: .semibold, textAlignment: .center)
                    .frame(height: 21)
                
            })
            
        case .BStage:
            return AnyView(VStack {
                
                DynamicText("POT의 내용을 자유롭게 작성해 주세요", weight: .semibold, textAlignment: .center)
                    .frame(height: 21)
                
                Text("*사진과 글은 필수입니다.")
                    .frame(height: 21)
                    .font(.system(size: 14))
                    .foregroundStyle(.red)
                
            })
        case .CStage:
            return AnyView(VStack {
                
                DynamicText("업로드 전, 미리보기를 통해 Pot을", weight: .semibold, textAlignment: .center)
                    .frame(height: 21)
                
                DynamicText("확인하고 업로드 해봐요", weight: .semibold, textAlignment: .center)
                    .frame(height: 21)
            })
        }
    }
}

public struct PotOnboardingView: View {
    
    @Binding var present: Bool
    
    @State private var currentStage: PotOnboardingStage = .AStage
    
    public init(present: Binding<Bool>) {
        self._present = present
    }
    
    public var body: some View {
        ZStack {
            
            Color.backgroundColor
                .ignoresSafeArea(.all)
            
            GeometryReader { geo in
                
                VStack(spacing: 0) {
                    
                    ZStack {
                        
                        Color.clear
                        
                        VStack {
                            
                            Spacer()
                            
                            currentStage.getImage()
                                .padding(.top, 48)
                            
                        }
                    }
                    .background(
                        Color.innerBackgroundColor
                    )
                    .overlay {
                        VStack {
                            
                            HStack {
                                
                                Spacer()
                                
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                    .foregroundStyle(.white)
                                    .onTapGesture {
                                        
                                        present = true
                                    }
                                    .padding(16)
                                
                            }
                            
                            Spacer()
                        }
                    }
                    
                    BelowTextView(
                        innerTextView: currentStage.getView(),
                        currentState: $currentStage
                    ) {
                        
                        present = false
                    }
                    .frame(width: geo.size.width, height: 149)
                    .background(
                        Color.white
                            .shadow(radius: 10)
                    )
                }
                .frame(height: geo.size.height*0.7)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .position(x: geo.size.width/2, y: geo.size.height/2)
                
            }
            .padding(.horizontal, 21)
            .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    PotOnboardingView(present: .constant(true))
}
