//
//  CJPhotoCell.swift
//
//
//  Created by 최준영 on 2023/12/27.
//

import UIKit

class CJPhotoCell: UICollectionViewCell {
    
    var thumbNailImageView = UIImageView()
    var livePhotoIconImageView = UIImageView()
    
    var representedAssetId: String!
    
    var thumbNailImage: UIImage! {
        didSet {
            thumbNailImageView.image = thumbNailImage
        }
    }
    
    
    var livePhotoIconImage: UIImage! {
        didSet {
            livePhotoIconImageView.image = livePhotoIconImage
        }
    }
    
    public override func draw(_ rect: CGRect) {
        
        setUp()
    }
    
    func setUp() {
        
        thumbNailImageView.contentMode = .scaleAspectFill
        thumbNailImageView.clipsToBounds = true
        
        livePhotoIconImageView.contentMode = .scaleAspectFit
        
        self.addSubview(thumbNailImageView)
        self.addSubview(livePhotoIconImageView)
        
        self.bringSubviewToFront(livePhotoIconImageView)
        
        thumbNailImageView.translatesAutoresizingMaskIntoConstraints = false
        livePhotoIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbNailImageView.topAnchor.constraint(equalTo: self.topAnchor),
            thumbNailImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            thumbNailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            thumbNailImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            livePhotoIconImageView.topAnchor.constraint(equalTo: self.topAnchor),
            livePhotoIconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            livePhotoIconImageView.widthAnchor.constraint(equalToConstant: 28.0),
            livePhotoIconImageView.heightAnchor.constraint(equalToConstant: 28.0),
            
        ])
        
    }
    
}

extension CJPhotoCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbNailImageView.image = nil
        livePhotoIconImageView.image = nil
        
    }
    
}
