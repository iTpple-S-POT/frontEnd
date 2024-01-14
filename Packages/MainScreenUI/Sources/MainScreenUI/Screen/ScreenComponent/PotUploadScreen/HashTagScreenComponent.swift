//
//  HashTagScreenComponent.swift
//
//
//  Created by 최준영 on 1/14/24.
//

import SwiftUI
import GlobalObjects
import GlobalUIComponents

struct HashTagScreenComponent: View {
    
    @EnvironmentObject var screenModelWithNav: PotUploadScreenModel
    @EnvironmentObject var globalObject: GlobalStateObject
    
    @FocusState var focusState
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 최상단
            ZStack {
                
                SpotNavigationBarView(title: "해시태그", dismissAction: screenModelWithNav.popTopView)
                
                HStack {
                    
                    Spacer()
                    
                    Button("완료", action: screenModelWithNav.popTopView)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.btn_red_nt)
                        .padding(.horizontal, 21)
                    
                }
                
            }
            
            VStack(spacing: 0) {
                
                HStack(spacing: 0) {
                    
                    Text("#")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 10)
                    
                    TextField("", text: $screenModelWithNav.temporalHashTagString)
                        .textFieldStyle(FlexiblePaddingTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .placeholder(when: screenModelWithNav.temporalHashTagString.isEmpty, placeholder: {
                            Text("해시태그를 입력해 주세요")
                                .foregroundStyle(.midium_gray)
                        })
                        .font(.system(size: 16, weight: .semibold))
                        .focused($focusState)
                        .toolbar {
                            ToolbarItem(placement: .keyboard) {
                                HStack {
                                    
                                    Spacer()
                                    
                                    Button("해시 태그 생성") {
                                        
                                        screenModelWithNav.submitHashTag()
                                    }
                                    .disabled(screenModelWithNav.temporalHashTagString.isEmpty)
                                    .padding(.trailing, 10)
                                }
                            }
                        }
                        .padding(.leading, 4)
                        .submitLabel(.done)
                    
                }
                .frame(height: 56)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.btn_light_grey)
                )
                .padding(.top, 40)
                .padding(.horizontal, 21)
                
                
                // 해쉬 태그
                ScrollViewReader { proxy in
                    
                    ScrollView(.horizontal) {
                        
                        LazyHStack {
                            
                            ForEach(Array(screenModelWithNav.potHashTags.enumerated()), id: \.element) { index, tag in
                                
                                HashTagBox(name: tag) {
                                    screenModelWithNav.removeHashTag(index: index)
                                }
                                .id(tag)
                               
                            }
                        }
                        .scrollIndicators(.hidden)
                        .padding(.leading, 21)
                        
                    }
                    .onChange(of: screenModelWithNav.potHashTags, perform: { strs in
                        
                        let lastStr = strs.last;
                        
                        withAnimation(.linear) {
                            proxy.scrollTo(lastStr)
                        }
                        
                    })
                    
                }
                .frame(height: 40)
                .padding(.top, 20)
                
                
            }
            
            
            Spacer(minLength: 0)
            
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            
            screenModelWithNav.temporalHashTagString = ""
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                
                Task { @MainActor in focusState = true }
            }
        }
        .alert(isPresented: $screenModelWithNav.showAlert, content: {
            Alert(title: Text(screenModelWithNav.alertTitle), message: Text(screenModelWithNav.alertMessage), dismissButton: .default(Text("닫기"), action: {
                
                screenModelWithNav.temporalHashTagString = ""
                
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    
                    Task { @MainActor in focusState = true }
                }
                
            }))
        })
    }
}


#Preview {
    HashTagScreenComponent()
        .environmentObject(PotUploadScreenModel())
        .environmentObject(GlobalStateObject())
}
