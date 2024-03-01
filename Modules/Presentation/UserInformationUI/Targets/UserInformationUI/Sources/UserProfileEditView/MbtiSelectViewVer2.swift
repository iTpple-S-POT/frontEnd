//
//  MbtiSelectViewVer2.swift
//  UserInformationUI
//
//  Created by 최준영 on 2/26/24.
//

import SwiftUI
import DefaultExtensions
import OnBoardingUI

struct MbtiSelectViewVer2: View {
    
    @ObservedObject var configureModel: ConfigurationScreenModel
    
    @Environment(\.dismiss) private var dismiss
    
    private var prevMbti: UserMbti
    
    init(configureModel: ConfigurationScreenModel) {
        self.configureModel = configureModel
        
        self.prevMbti = configureModel.userMBTI
    }
    
    var body: some View {
        ZStack {
            
            Color.white.ignoresSafeArea(.all, edges: .top)
            
            EditViewNavBar(title: "MBTI") {
                
                // 수정전으로 초기화
                configureModel.userMBTI = prevMbti
                
                dismiss()
            } onComplete: {
                
                dismiss()
            }
            
            VStack {
                
                Spacer()
                
                MbtiSelectUI(configureModel: configureModel)
                
                Spacer()
            }
            .padding(.top, 56)
                
        }
    }
}

struct MbtiSelectUI: View {
    
    @ObservedObject var configureModel: ConfigurationScreenModel
    
    @State private var showGuide = false
    
    var body: some View {
        
        VStack(spacing: 32) {
            
            MBTISelectOne(selectedPart: $configureModel.userMBTI.type1, case1: .I, case2: .E)
            
            MBTISelectOne(selectedPart: $configureModel.userMBTI.type2, case1: .S, case2: .N)
            
            MBTISelectOne(selectedPart: $configureModel.userMBTI.type3, case1: .T, case2: .F)
            
            MBTISelectOne(selectedPart: $configureModel.userMBTI.type4, case1: .J, case2: .P)
            
            HStack {
                
                Image.makeImageFromBundle(bundle: .module, name: "info_icon", ext: .png)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                
                Text("MBTI가 무엇인가요?")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.red)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                
                showGuide = true
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 21)
        .transparentFullScreenCover(isPresented: $showGuide) {
            
            MbtiOnBoarding(present: $showGuide)
        }
    }
}

struct MBTISelectOne: View {
    
    @Binding var selectedPart: UserMbtiPartCase
    
    var case1: UserMbtiPartCase
    var case2: UserMbtiPartCase
    
    var body: some View {
        
        HStack {
            
            // Case1
            Button {
                
                selectedPart = case1
                
            } label: {
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(selectedPart == case1 ? .spotRed : .light_gray)
                    
                    Text(case1.rawValue)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(selectedPart == case1 ? .white : .spotRed)
                }
                .frame(width: 64, height: 64)
                .contentShape(RoundedRectangle(cornerRadius: 10))
            }
            
            HStack(spacing: 0) {
                
                Image(systemName: "arrowtriangle.left.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 5)
                    .foregroundStyle(.gray)
                
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                
                Image(systemName: "arrowtriangle.right.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 5)
                    .foregroundStyle(.gray)
                
            }
            .padding(.horizontal, 40)
            
            // Case2
            Button {
                
                selectedPart = case2
                
            } label: {
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(selectedPart == case2 ? .spotRed : .light_gray)
                    
                    Text(case2.rawValue)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(selectedPart == case2 ? .white : .spotRed)
                }
                .frame(width: 64, height: 64)
                .contentShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

extension View {
    func transparentFullScreenCover<Content: View>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
        fullScreenCover(isPresented: isPresented) {
            ZStack {
                content()
            }
            .background(TransparentBackground())
        }
    }
}

struct TransparentBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
