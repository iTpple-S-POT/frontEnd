//
//  PotClusterAnnotationView.swift
//
//
//  Created by 최준영 on 2/5/24.
//

import MapKit
import UIKit
import SwiftUI


class PotClusterAnnotationView: MKAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureCallBack))
        
        self.addGestureRecognizer(tapGesture)
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        let clusterAnnotation = self.annotation as! MKClusterAnnotation
        
        self.image = drawCircleWithCountText(count: clusterAnnotation.memberAnnotations.count)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func drawCircleWithCountText(count: Int) -> UIImage {
        
        let annotationSize = CGSize(width: 104, height: 104)
        
        let renderer = UIGraphicsImageRenderer(size: annotationSize)
        
        return renderer.image { _ in
            
            UIColor.clusterRed.setFill()
            
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: annotationSize.width, height: annotationSize.height)).fill()
            
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 40)]
            
            let text = "\(count)"
            let textSize = text.size(withAttributes: attributes)
            let rect = CGRect(x: (annotationSize.width - textSize.width)/2, y: (annotationSize.height - textSize.height)/2, width: textSize.width, height: textSize.height)
            text.draw(in: rect, withAttributes: attributes)
        }
        
    }
    
}

extension PotClusterAnnotationView {

    @objc
    func tapGestureCallBack() {
        
        if let cluster = self.annotation as? MKClusterAnnotation {
            
            let models = cluster.memberAnnotations.compactMap {
                
                if let potAnnot = ($0 as? PotAnnotation) {
                    return potAnnot.potModel
                    
                }
                return nil
            }
            
            NotificationCenter.potSelection.post(name: .multiplePotsSelection, object: models)
        }
    }
}
