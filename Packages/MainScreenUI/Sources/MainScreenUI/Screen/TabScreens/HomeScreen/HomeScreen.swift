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
    
    @State private var presentSub: AnyCancellable?
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                
                TopMostScreenComponent()
                    .frame(height: 56)
                
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
                    if homeScreenModel.presentPotDetailView {
                        
                        PotDetailView(potObject: homeScreenModel.selectedPotObject!, dismissAction: {
                            
                            homeScreenModel.presentPotDetailView = false
                            mainScreenConfig.setMode(mode: .idleMode)
                            
                        })
                            .onAppear {
                                mainScreenConfig.setMode(mode: .blackMode)
                            }
                    }
                }
                .slideTransition(
                    from: CGPoint(x: 0, y: height/2),
                    to: CGPoint(x: 0, y: 0)
                )
                .animation(.easeIn(duration: 0.5), value: homeScreenModel.presentPotDetailView)
                
            }
            .zIndex(2)
        }
        .onAppear {
            self.presentSub = homeScreenModel.$presentPotDetailView.sink { mainScreenConfig.isPotDetailViewIsPresented = $0 }
        }
    }
}

extension View {
    
    func slideTransition(from: CGPoint, to: CGPoint) -> some View {
        self
            .transition(
                .customSlide(from: from, to: to).combined(with: .opacity)
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

@MainActor
class HomeScreenModel: ObservableObject {
    
    @Published private(set) var selectedPotObject: PotObject?
    @Published var presentPotDetailView = false
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(singlePotSelected(_:)), name: .singlePotSelection, object: nil)
    }
    
    @objc
    func singlePotSelected(_ notification: Notification) {
        
        let object = notification.object as! PotObject
        
        DispatchQueue.main.async(qos: .userInteractive) {
            self.selectedPotObject = object
            
            self.presentPotDetailView = true
        }
    }
}

#Preview {
    MainScreen()
}
