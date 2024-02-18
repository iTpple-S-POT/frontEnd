//
//  ProfileShortCapView.swift
//  
//
//  Created by 최준영 on 2/18/24.
//

import SwiftUI

public struct ProfileShortCapView: View {
    
    var nickName: String
    var platformDescription: String
    
    private var screenWidth: CGFloat {
        
        UIScreen.main.bounds.width
    }
    
    public init(nickName: String, platformDescription: String) {
        self.nickName = nickName
        self.platformDescription = platformDescription
    }
    
    public var body: some View {
        ZStack {
            
            //background
            
            VStack(spacing: 0) {
                
                Image.makeImageFromBundle(bundle: .module, name: "profile_bg", ext: .png)
                    .resizable()
                    .scaledToFit()
                
                Spacer()
            }
            
            // Contents
            VStack(spacing: 0) {
                
                GeometryReader { geo in
                    
                    ZStack {
                        
                        Rectangle()
                            .fill(.white)
                            .padding(.top, geo.size.height/2)
                        
                        Ellipse()
                            .fill(.white)
                            .frame(width: 460)
                            .ignoresSafeArea(.container, edges: .horizontal)
                            .overlay {
                                ZStack {
                                    Text(nickName)
                                        .font(.system(size: 22, weight: .semibold))
                                    
                                    GeometryReader {
                                        Text(platformDescription)
                                            .font(.system(size: 16))
                                            .foregroundStyle(.gray)
                                            .position(x: $0.size.width/2, y: $0.size.height * 3/4)
                                        
                                        
                                        let profileHeight = screenWidth/3.9
                                        
                                        Image.makeImageFromBundle(bundle: .module, name: "profile_vec", ext: .png)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: profileHeight)
                                            .overlay {
                                                VStack {
                                                    
                                                    Circle()
                                                        .fill(.white)
                                                    
                                                    Spacer()
                                                }
                                                .padding(20)
                                            }
                                            .offset(y: -profileHeight/2)
                                            .position(x: $0.size.width/2, y: $0.size.height/4)
                                    }
                                }
                            }
                            .position(x: geo.size.width/2, y: geo.size.height/2)
                            
                        
                    }
                       
                }
                .frame(height: 120)
                .padding(.top, 90)
                    
                
                Spacer()
                
            }
        }
    }
}
