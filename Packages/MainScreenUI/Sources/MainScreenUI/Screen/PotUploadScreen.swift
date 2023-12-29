//
//  PotUploadScreen.swift
//
//
//  Created by 최준영 on 2023/12/29.
//

import SwiftUI
import CJPhotoCollection

struct PotUploadScreen: View {
    
    @State private var selectedImage: ImageInformation?
    
    var body: some View {
        VStack(spacing: 0) {
            
            CJPhotoCollectionView { image in
                
                selectedImage = image
                
            }
            
        }
        .sheet(item: $selectedImage) { item in
            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    PotUploadScreen()
}
