//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/23.
//

import SwiftUI

internal struct MainScreenBarView: View {
    
    var state: Int
    
    var countOfState: Int
    
    var body: some View {
        
        GeometryReader { geo in
            let geoWidth = geo.size.width
            let barSizePerProcess = geoWidth / CGFloat(countOfState)
            let currentBarSize = barSizePerProcess * CGFloat(state)
            
            VStack(spacing: 0) {
                
                /// 숫자텍스트
                HStack(spacing: 0) {
                    Spacer()
                    Text("\(state)")
                        .animation(nil)
                    Text("/\(countOfState)")
                }
                .font(.suite(type: .SUITE_Regular, size: 17))
                .frame(height: 20)
                
                Spacer()
                
                /// 검정바
                ZStack {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.lightGeryForBar)
                        .frame(height: 4)
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(.black)
                            .frame(width: currentBarSize, height: 4)
                        Spacer(minLength: 0)
                    }
                }
            }
        }
        .frame(height: 28)
    }
}
