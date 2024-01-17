//
//  LoginScreenModel.swift
//
//
//  Created by 최준영 on 1/17/24.
//

import SwiftUI
import Combine
import GlobalObjects

class LoginScreenModel: ObservableObject {
    
    @Published var isKakaoLoginCompleted = false
    
    // Alert
    @Published var showingAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""

}
