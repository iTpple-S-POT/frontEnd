//
//  NickNameEditView.swift
//  UserInformationUI
//
//  Created by 최준영 on 2/26/24.
//

import SwiftUI
import GlobalObjects

fileprivate enum SomeError: Error {
    
    case nicknNameCheckError
}

struct NickNameEditView: View {
    
    @ObservedObject var configureModel: ConfigurationScreenModel
    
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focusState
    
    private let prevNickName: String
    
    @State private var showAlert = false
    private var alertTitle = "닉네임 변경 실패"
    @State private var alertContent = "사용할 수 없는 닉네임 입니다."
    
    init(configureModel: ConfigurationScreenModel) {
        
        self.configureModel = configureModel
        self.prevNickName = configureModel.nickNameInputString
    }
    
    var body: some View {
        ZStack {
            
            Color.white.ignoresSafeArea(.all, edges: .top)
            
            EditViewNavBar(title: "닉네임") {
                
                // 수정전으로 초기화
                configureModel.nickNameInputString = prevNickName
                
                dismiss()
            } onComplete: {
                
                Task {
                    
                    do {
                        
                        let (isSuccess, reason) = try await APIRequestGlobalObject.shared.checkIsNickNameAvailable(nickName: configureModel.nickNameInputString)
                        
                        if !isSuccess {
                            
                            self.alertContent = reason
                            
                            throw SomeError.nicknNameCheckError
                        }
                        
                        self.dismiss()
                        
                    } catch {
                        
                        DispatchQueue.main.async {
                               
                            self.configureModel.nickNameInputString = self.prevNickName
                            self.showAlert = true
                        }
                    }
                }
                
                dismiss()
            }
            
            VStack(alignment: .leading) {
                    
                VStack(alignment: .leading, spacing: 5) {
                    Text("공백없이 15자 이하로 작성해주세요.")
                        .padding(.top, 56)
                    
                    Text("특수문자는 _만 사용 가능해요:)")
                }
                .font(.system(size: 16))
                
                TextField("닉네임", text: $configureModel.nickNameInputString)
                    .font(.system(size: 18))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .frame(height: 56)
                    .padding(.top, 30)
                    .padding(.leading, 8)
                    .ignoresSafeArea(.keyboard)
                    .focused($focusState)
                
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                
                Spacer()
            }
            .padding(.horizontal, 21)
            .padding(.top, 56)
        }
        .onAppear(perform: { focusState = true })
        .alert(alertTitle, isPresented: $showAlert) {
            Button("닫기") { }
        } message: {
            Text(alertContent)
        }
    }
}
