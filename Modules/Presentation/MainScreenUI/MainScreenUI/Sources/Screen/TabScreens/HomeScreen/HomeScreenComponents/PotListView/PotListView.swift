//
//  PotListView.swift
//  MainScreenUI
//
//  Created by 최준영 on 2/23/24.
//

import SwiftUI
import GlobalObjects
import Kingfisher
import GlobalUIComponents

struct PotListView: View {
    @Binding var present: Bool
    
    var title: String
    
    @State var models: [PotModel]
    
    var body: some View {
        
        ZStack {
            
            Color.white.ignoresSafeArea(.all, edges: .top)
            
            VStack(spacing: 0) {
                
                SpotNavigationBarView(title: title) {
                    
                    withAnimation {
                        present = false;
                    }
                }
                
                Spacer()
            }
            .zIndex(1.0)
            
            VStack {
                
                PotCollectionView(models: $models)
                
                Spacer()
            }
            .padding(.top, 56)
            .zIndex(0.0)
        }
    }
}

struct PotCollectionView: UIViewControllerRepresentable {
    
    @Binding var models: [PotModel]
    
    func makeUIViewController(context: Context) -> PotCollectionViewController {
        
        let view = PotCollectionViewController(models: models)
        
        return view
    }
    
    func updateUIViewController(_ uiViewController: PotCollectionViewController, context: Context) {
        
        uiViewController.models = models
        
        uiViewController.collectionView.reloadData()
    }
    
    typealias UIViewControllerType = PotCollectionViewController
}

