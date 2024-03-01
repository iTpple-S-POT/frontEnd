//
//  CJCameraCell.swift
//
//
//  Created by 최준영 on 2023/12/28.
//

import UIKit

public class CJCameraCell: UICollectionViewCell {
    
    var cameraImageView: UIImageView {
        
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "camera")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        
        return imageView
        
    }
    
    var cameraLabel: UILabel {
        
        let label = UILabel()
        
        label.text = "카메라"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        
        return label
    }
    
    public func setUp() {
        
        self.backgroundColor = .gray
        
        let image = cameraImageView
        let label = cameraLabel
        
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(image)
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            
            image.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 28),
            image.widthAnchor.constraint(equalToConstant: 28),
            
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            
        ])
        
    }
    
}
