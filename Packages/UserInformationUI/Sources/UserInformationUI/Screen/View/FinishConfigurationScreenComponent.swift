//
//  FinalView.swift
//
//
//  Created by 최준영 on 2023/11/27.
//

import SwiftUI
import DefaultExtensions

struct FinishConfigurationScreenComponent: View {
    
    @State private var safeAreaInsets: EdgeInsets = .init()
    
    private var imageGradient: LinearGradient {
        
        let colors: [Color] = [
            Color(hex: "463636", alpha: 0.57),
            Color(hex: "72614D", alpha: 0.45),
            Color(hex: "201C1C", alpha: 0.29)
        ]
        
        let stops: [Gradient.Stop] = [
            .init(color: colors[0], location: 0.0),
            .init(color: colors[1], location: 0.5),
            .init(color: colors[2], location: 1.0)
        ]
        
        return LinearGradient(stops: stops, startPoint: .topLeading, endPoint: UnitPoint.bottom)
    }
    
    var body: some View {
        ZStack {
            
            // Background
            Color.clear
                .background(
                    Image.makeImageFromBundle(name: "FinalViewBackground", ext: .png)
                        .resizable()
                        .scaledToFill()
                        .overlay { imageGradient }
                        .overlay { Rectangle().fill(Color(hex: "201C1C", alpha: 0.08)) }
                )
                .ignoresSafeArea()
            
            
            // Title
            VStack {
                VStack {
                    Text("소소한 일상을")
                    (
                        Text("나만의 POT")
                            .font(.suite(type: .SUITE_ExtraBold, size: 36))
                        +
                        Text("을 통해")
                    )
                    Text("공유해 보세요!")
                }
                .font(.suite(type: .SUITE_Regular, size: 36))
                .foregroundStyle(.white)
                .frame(height: 160)
                .padding(.top, 48)
                
                Spacer(minLength: 0)
            }
            .padding(.top, safeAreaInsets.top)
        }
    }
}



#Preview {
    FinishConfigurationScreenComponent()
}
