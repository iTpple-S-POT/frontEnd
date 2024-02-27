//
//  SettingView.swift
//  MainScreenUI
//
//  Created by 최준영 on 2/27/24.
//

import SwiftUI
import GlobalUIComponents
import GlobalObjects

class SettingViewModel: ObservableObject {
    
    @Published var showAlert = false
    private(set) var alertTitle = ""
    private(set) var alertContent = ""
    private(set) var alertAction: (() -> Void)?
    
    func showLogoutComfirmation() {
        
        showAlert = true
        alertTitle = "로그아웃"
        alertContent = "로그아웃 하시겠습니까?"
        alertAction = {
            
            self.removeCurrentToken()
        }
    }
    
    func showDeleteAccountComfirmation() {
        
        showAlert = true
        alertTitle = "회원틸퇴"
        alertContent = "회원틸퇴 하시겠습니까?"
        alertAction = {
            
            self.removeCurrentToken()
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
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            
            Button("취소") { }
            
            Button("확인") {
                
                viewModel.alertAction?()
                
                mainNavigation.presentScreen(destination: .loginScreen)
            }
            
        } message: {
            
            Text(viewModel.alertContent)
        }

    }
}

#Preview {
    SettingView()
}
