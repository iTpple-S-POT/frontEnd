//
//  MyPageScreen.swift
//
//
//  Created by 최준영 on 2/18/24.
//

import SwiftUI
import GlobalObjects

struct TestSpotUserInfo {
    
    var id: Int64
    var nickName: String
    var profileIamgeUrl: String
    
}

struct MyPageScreen: View {
//    @FetchRequest(sortDescriptors: [])
//    private var userInfo: FetchedResults<SpotUser>
    
    var userInfo: TestSpotUserInfo
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    MyPageScreen(userInfo: TestSpotUserInfo(id: 0, nickName: "", profileIamgeUrl: ""))
}
