//
//  PotListView.swift
//  MainScreenUI
//
//  Created by 최준영 on 2/23/24.
//

import SwiftUI
import GlobalObjects
import Kingfisher

struct PotListView: View {
    @Binding var present: Bool
    
    var models: [PotModel]
    
    var body: some View {
        
        ZStack {
            
            Color.white.ignoresSafeArea(.all, edges: .top)
            
            VStack(spacing: 0) {
                
                SpotNavigationBarView(title: "주변 팟") {
                    
                    withAnimation {
                        present = false;
                    }
                }
                
                PotCollectionView(models: models)
            }
        }
    }
}

struct PotCollectionView: UIViewControllerRepresentable {
    
    var models: [PotModel]
    
    func makeUIViewController(context: Context) -> PotCollectionViewController {
        
        let view = PotCollectionViewController(models: models)
        
        return view
    }
    
    func updateUIViewController(_ uiViewController: PotCollectionViewController, context: Context) {
        
        
    }
    
    typealias UIViewControllerType = PotCollectionViewController
}

