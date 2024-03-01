//
//  PotListCell.swift
//  MainScreenUI
//
//  Created by 최준영 on 2/25/24.
//

import SwiftUI
import Kingfisher
import GlobalObjects

struct PotListCell: View {
    
    let potModel: PotModel
    
    let itemSize: CGSize
    
    private let cornerRadius: CGFloat = 10
    
    private var processor: ImageProcessor {
        
        DownsamplingImageProcessor(size: itemSize)
    }
    
    var body: some View {
        
        ZStack {
            
            if let imageKey = potModel.imageKey {
                
                KFImage.url(URL(string: imageKey.getPreSignedUrlString())!)
                    .setProcessor(processor)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            
            let object: [String: Any?] = [
                "model" : potModel
            ]
            NotificationCenter.potSelection.post(name: .singlePotSelection, object: object)
        }
    }
}

//#Preview {
//    PotListCell()
//}
