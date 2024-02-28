//
//  HashTagScreenComponent.swift
//
//
//  Created by 최준영 on 1/14/24.
//

import SwiftUI
import GlobalObjects
import GlobalUIComponents
import Combine

struct HashTagScreenComponent: View {
    
    @EnvironmentObject var screenModelWithNav: PotUploadScreenModel
    
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
                                .foregroundStyle(.medium_gray)
                        })
                        .font(.system(size: 16, weight: .semibold))
                        .focused($focusState)
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
                            
                            ForEach(Array(screenModelWithNav.potHashTags), id: \.hashtagId) { hashTag in
                                
                                HashTagBox(name: hashTag.hashtag) {
                                    
                                    screenModelWithNav.deleteHashTag(hashTag: hashTag)
                                }
                                .id(hashTag.hashtagId)
                               
                            }
                        }
                        .padding(.leading, 21)
                        
                    }
                    .scrollIndicators(.hidden)
                }
                .frame(height: 40)
                .padding(.top, 20)
                
                // 자동완성
                HashTagAutoCompletionView(
                    inputString: $screenModelWithNav.temporalHashTagString,
                    pub: screenModelWithNav.hashTagInsertPublisher
                )
                .padding(.horizontal, 21)
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

struct HashTagAutoCompletionView: View {
    
    @Binding var inputString: String
    
    let pub: PassthroughSubject<HashTagDTO, Never>
    
    @State private var showingList: [HashTagDTO] = []
    
    var body: some View {
        
        Group {
            
            if !showingList.isEmpty {
                
                ScrollView {
                    
                    VStack(spacing: 0) {
                        
                        ForEach(showingList, id: \.hashtagId) { element in
                            
                            VStack(spacing: 0) {
                                
                                HStack {
                                    
                                    Text(element.hashtag)
                                        .font(.system(size: 16))
                                        .padding(.leading, 16)
                                    
                                    Spacer()
                                    
                                    Text("선택")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.gray)
                                        .padding(.trailing, 16)
                                }
                                .frame(height: 56)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    
                                    pub.send(element)
                                }
                                
                                Rectangle()
                                    .fill(.light_gray)
                                    .frame(height: 1)
                            }
                        }
                    }
                }
            }
            
            if showingList.isEmpty, !inputString.isEmpty {
                    
                HStack {
                    
                    Text(inputString)
                        .font(.system(size: 16))
                        .padding(.leading, 16)
                    
                    Spacer()
                    
                    Text("선택")
                        .font(.system(size: 16))
                        .foregroundStyle(.light_gray)
                        .padding(.trailing, 16)
                }
                .frame(height: 56)
                .contentShape(Rectangle())
                .onTapGesture {
                    
                    Task {
                        
                        do {
                            
                            if let newHashTag = try await APIRequestGlobalObject.shared.postHashtags(hashtags: [inputString]).first {
                                
                                pub.send(newHashTag)
                            }
                        } catch {
                            
                            print("새로운 해쉬태그 생성 실패")
                        }
                    }
                }
            }
        }
        .onChange(of: inputString) { newStr in
            
            Task {
                
                do {
                    
                    let newList = try await APIRequestGlobalObject.shared.getHashTagFrom(string: newStr)
                    
                    DispatchQueue.main.async {
                        
                        self.showingList = newList
                    }
                    
                } catch {
                    
                    print("해시태그 검색결과 불러오기 실패")
                }
            }
        }
    }
}

#Preview {
    HashTagScreenComponent()
        .environmentObject(PotUploadScreenModel())
}
