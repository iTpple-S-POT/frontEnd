//
//  MapScreenComponent.swift
//
//
//  Created by 최준영 on 2023/12/24.
//

import SwiftUI
import CJMapkit

struct MapScreenComponent: View {
    
    @StateObject private var screenModel = MapScreenComponentModel()
    
    var body: some View {
        ZStack {
            
            MapkitViewRepresentable(userLocation: $screenModel.explicitUserLocation, annotations: [])
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        
                        screenModel.moveMapToCurrentLocation()
                        
                    } label: {
                        
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .foregroundStyle(.green)
                        
                    }
                    
                }
                
            }
            
        }
            .onAppear {
                
                do {
                    try screenModel.checkLocationAuthorization()
                }
                catch {
                    
                    print("권한이 없음")
                    
                }
                
            }
        
    }
}

#Preview {
    MapScreenComponent()
}
