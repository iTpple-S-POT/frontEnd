//
//  MainScreen.swift
//
//
//  Created by 최준영 on 2023/12/23.
//

import SwiftUI
import CJMapkit
import CoreLocation

struct MainScreen: View {
    var body: some View {
        ZStack {
            
            // 상단
            VStack(spacing: 0) {
                TopMostScreenComponent()
                    .frame(height: 56)
                SelectMapTagScreenComponent()
                    .frame(height: 64)
                
                Spacer(minLength: 0)
                
            }
            .zIndex(1)
            
            
            ZStack {
                CJMapkitView(userLocation: CLLocation(latitude: 37.550756, longitude: 126.9254901), annotations: [
                    CIAnnotationWithSwiftUI(coordinate: CLLocationCoordinate2D(latitude: 37.550756, longitude: 126.9254901), title: "홍익대학교", subtitle: "대학교", uiImage: UIImage(systemName: "person")!)
                
                ])
            }
            .padding(.top, 110)
            .padding(.bottom, 64)
            .zIndex(0)
            
            // 하단
            VStack(spacing: 0) {
                
                Spacer(minLength: 0)
                
                TabScreenComponent()
                    .frame(height: 64)
            }
            .zIndex(1)
            
        }
    }
}

#Preview {
    MainScreen()
}
