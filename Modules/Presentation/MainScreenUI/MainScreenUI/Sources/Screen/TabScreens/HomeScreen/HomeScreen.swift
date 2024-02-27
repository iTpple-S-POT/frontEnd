//
//  HomeScreen.swift
//
//
//  Created by 최준영 on 2023/12/23.
//

import SwiftUI
import GlobalObjects
import MapKit
import PotDetailUI
import Combine

struct HomeScreen: View {
    
    @Environment(\.mainScreenConfig) private var mainScreenConfig
    
    @EnvironmentObject private var mainScreenModel: MainScreenModel
    
    @StateObject private var homeScreenModel = HomeScreenModel()
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                
                TopMostScreenComponent()
                
                ZStack {
                    
                    VStack() {
                        
                        SelectMapTagScreenComponent()
                            .frame(height: 88)
                        
                        Spacer()
                        
                    }
                    .zIndex(1)
                    
                    MapScreenComponent()
                        .zIndex(0)
                }
            }
            .zIndex(0)
            
            // PotView
            GeometryReader { geo in
                
//                let width = geo.size.width
                let height = geo.size.height
                
                Group {
                    
                    if homeScreenModel.presentPotsListView {
                        
                        PotListView(present: $homeScreenModel.presentPotsListView, models: homeScreenModel.selectedClusterModels!)
                            .zIndex(1)
                    }
                    
                }
                .slideTransition(
                    from: CGPoint(x: 0, y: height/3),
                    to: CGPoint(x: 0, y: 0)
                )
                .animation(.easeIn(duration: 0.3), value: homeScreenModel.presentPotsListView)
            }
        }
    }
}

extension View {
    
    func slideTransition(from: CGPoint, to: CGPoint) -> some View {
        self
            .transition(
                .opacity.combined(with: .customSlide(from: from, to: to))
            )
    }
}

extension AnyTransition {
    static func customSlide(from: CGPoint, to: CGPoint) -> AnyTransition {
        return .modifier(active: CustomSilde(point: from), identity: CustomSilde(point: to))
    }
}

struct CustomSilde: ViewModifier {
    
    var point: CGPoint
    
    func body(content: Content) -> some View {
        content
            .offset(x: point.x, y: point.y)
    }
    
}
