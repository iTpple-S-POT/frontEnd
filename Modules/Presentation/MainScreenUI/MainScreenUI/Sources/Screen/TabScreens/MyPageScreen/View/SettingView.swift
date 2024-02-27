//
//  SettingView.swift
//  MainScreenUI
//
//  Created by 최준영 on 2/27/24.
//

import SwiftUI
import GlobalUIComponents
import GlobalObjects

enum SettingFailed: Error {
    
    case logoutFailed
    case deleteFailed
}

class SettingViewModel: ObservableObject {
    
    @Published var showErrorAlert = false
    
    @Published var showComfirmAlert = false
    private(set) var alertTitle = ""
    private(set) var alertContent = ""
    private(set) var alertAction: (() async throws -> Void)?
    
    func showLogoutComfirmation() {
        
        showComfirmAlert = true
        alertTitle = "로그아웃"
        alertContent = "로그아웃 하시겠습니까?"
        alertAction = { }
    }
    
    func showDeleteAccountComfirmation() {
        
        showComfirmAlert = true
        alertTitle = "회원틸퇴"
        alertContent = "회원틸퇴 하시겠습니까?"
        alertAction = {
            
            do {
                
                try await APIRequestGlobalObject.shared.deleteUserInfo()
            } catch {
                
                self.alertTitle = "회원탈퇴 실패"
                
                throw SettingFailed.deleteFailed
            }
        }
    }
    
    func removeCurrentToken() {
        
        UserDefaultsManager.deleteTokenInLocal()
    }
}

struct SettingView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var mainNavigation: MainNavigation
    
    @StateObject private var viewModel = SettingViewModel()
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                SpotNavigationBarView(title: "설정") {
                    
                    dismiss()
                }
                
                Spacer()
                
            }
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text("계정")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(height: 56)
                    .padding(.leading, 21)
                
                RowTextButton(title: "로그아웃") {
                    
                    viewModel.showLogoutComfirmation()
                }
                
                RowTextButton(title: "회원 탈퇴") {
                    
                    viewModel.showDeleteAccountComfirmation()
                }
                
                Spacer()
                
            }
            .padding(.top, 56)
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showComfirmAlert) {
            
            Button("취소") { }
            
            Button("확인") {
                
                Task {
                    
                    do {
                        try await viewModel.alertAction!()
                        
                        DispatchQueue.main.async {
                            
                            viewModel.removeCurrentToken()
                            mainNavigation.presentScreen(destination: .loginScreen)
                        }
                    } catch {
                        
                        viewModel.showErrorAlert = true
                    }
                }
            }
            
        } message: {
            
            Text(viewModel.alertContent)
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showErrorAlert) {
            
            Button("확인") { }
        }

    }
}

#Preview {
    SettingView()
}
