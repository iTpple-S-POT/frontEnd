//
//  File.swift
//  
//
//  Created by 최준영 on 2023/12/24.
//

import SwiftUI
import UIKit
import MapKit

class PotAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        guard let data = annotation as? PotAnnotation else {
            preconditionFailure("타입변환 불가")
        }
        
        setUp(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
    
    private func setUp(data: PotAnnotation) {
        
        let uiImageView = UIImageView(image: data.type.getUIImage())
        uiImageView.contentMode = .scaleAspectFit
        
        self.addSubview(uiImageView)
        
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
                
        
        NSLayoutConstraint.activate([
            
            self.widthAnchor.constraint(equalToConstant: 56.0),
            self.heightAnchor.constraint(equalToConstant: 56.0),
            
            uiImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            uiImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            uiImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -28)
            
        ])
        
    }
    
}



struct MyUIViewWrapper: UIViewRepresentable {
    func makeUIView(context: Context) -> PotAnnotationView {
        
        let anotData = PotAnnotation(type: .event, coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        
        return PotAnnotationView(annotation: anotData, reuseIdentifier: nil)
        
    }

    func updateUIView(_ uiView: PotAnnotationView, context: Context) {
        
    }
}


#Preview {
    MyUIViewWrapper()
        .frame(width: 56, height: 56)
}
