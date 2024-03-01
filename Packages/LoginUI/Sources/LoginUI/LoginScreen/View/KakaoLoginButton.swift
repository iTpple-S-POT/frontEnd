//
//  KakaoLoginButton.swift
//
//
//  Created by 최준영 on 1/17/24.
//

import SwiftUI
import GlobalObjects
import DefaultExtensions
import Combine

struct KakaoLoginButton: View {
    
    let pub = PassthroughSubject<TokenObject?, Never>()
    
    let sub: AnyCancellable?
    
    init(completion: @escaping (TokenObject?) -> Void) {
        self.sub = pub.sink(receiveValue: completion)
    }
    
    var body: some View {
        
        Button {
            
            KakaoLoginManager.shared.executeLogin { result in
                
                switch result {
                case .success(let tokens):
                    
                    pub.send(tokens)
                    
                case .failure(let failure):
                    print(failure.localizedDescription)
                    
                    pub.send(nil)
                }
                
            }
            
        } label: {
            
            Image.makeImageFromBundle(bundle: .module, name: "kakao_button_image", ext: .png)
                .resizable()
                .scaledToFit()
                .frame(minWidth: 140, minHeight: 30, maxHeight: 56)
            
        }
    }
}

