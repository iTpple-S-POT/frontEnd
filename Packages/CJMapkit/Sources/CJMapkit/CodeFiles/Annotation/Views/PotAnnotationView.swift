//
//  File.swift
//
//
//  Created by 최준영 on 2023/12/24.
//

import SwiftUI
import UIKit
import MapKit
import GlobalObjects
import Lottie
import Kingfisher

class PotAnnotationView: MKAnnotationView {
    
    let layer1: PotShapeView = {
        
        let view = PotShapeView()
        
        view.color = .white
        return view
    }()
    
    let layer2: PotShapeView = {
        
        let view = PotShapeView()
        
        return view
    }()
    
    let layer3: UIImageView = {
        
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    init(annotation: PotAnnotation, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.annotation = annotation
        
        setUp(annotation: annotation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
    
    func setUp(annotation: PotAnnotation) {
        
        layer2.color = PotAnnotationType(rawValue: Int(annotation.potObject.categoryId))!.getAnnotationColor()
        
        self.addSubview(layer1)
        self.insertSubview(layer2, aboveSubview: layer1)
        self.insertSubview(layer3, aboveSubview: layer2)
        
        layer1.translatesAutoresizingMaskIntoConstraints = false
        layer2.translatesAutoresizingMaskIntoConstraints = false
        layer3.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            layer1.widthAnchor.constraint(equalTo: self.widthAnchor),
            layer1.heightAnchor.constraint(equalTo: self.heightAnchor),
            layer1.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            layer1.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            layer2.widthAnchor.constraint(equalTo: layer1.widthAnchor, constant: -6),
            layer2.heightAnchor.constraint(equalTo: layer1.heightAnchor, constant: -6),
            layer2.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            layer2.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            layer3.widthAnchor.constraint(equalTo: layer2.widthAnchor, constant: -6),
            layer3.heightAnchor.constraint(equalTo: layer2.heightAnchor, constant: -6),
            layer3.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            layer3.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        // shadow
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0
        
    }
    
    override func draw(_ rect: CGRect) {
        
        let height = self.bounds.height
        
        self.bounds.origin.y = sqrt(2.0) * height/2
        
        layer3.layer.cornerRadius = layer3.bounds.width/2
        
        if let potAnot = annotation as? PotAnnotation, let imageKey = potAnot.potObject.imageKey {
            loadImageView(imageKey: imageKey)
        }
    }
    
    func loadImageView(imageKey: String) {
        
        let url = URL(string: "https://d1gmn3m06z496v.cloudfront.net/" + imageKey)
        
        let processor = DownsamplingImageProcessor(size: layer3.bounds.size) |> RoundCornerImageProcessor(cornerRadius: layer3.bounds.size.width/2)
        
        layer3.kf.indicatorType = .none
        layer3.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]) {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
        
        
    }
}


class PotShapeView: UIView {
    
    var color: UIColor = .black
    
    let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        defaultSetUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        defaultSetUp()
    }
    
    func defaultSetUp() {
        
        self.backgroundColor = .clear
        
        self.clipsToBounds = false
        
        self.layer.addSublayer(shapeLayer)
    }
    
    override func draw(_ rect: CGRect) {
        
        drawPotShape(rect: rect)
    }
    
    func drawPotShape(rect: CGRect) {
        
        shapeLayer.lineWidth = 0.0
        shapeLayer.fillColor = color.cgColor
        shapeLayer.backgroundColor = UIColor.red.withAlphaComponent(0.0).cgColor
        
        color.setFill()
        
        let path = UIBezierPath()
        
        let radius = rect.width/2
        
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        
        path.move(to: CGPoint(x: rect.width/2, y: 0))
        
        path.addArc(withCenter: center, radius: radius, startAngle: (-90 * .pi) / 180, endAngle: (-225 * .pi) / 180, clockwise: false)
        
        path.addLine(to: CGPointMake(rect.width/2, rect.height/2 + sqrt(2.0)*radius))
        
        path.addLine(to: CGPointMake(rect.width/2 + sqrt(2.0)*radius/2, rect.height/2 + sqrt(2.0)*radius/2))
        
        path.addArc(withCenter: center, radius: radius, startAngle: (-315 * .pi) / 180, endAngle: (-90 * .pi) / 180, clockwise: false)
        
        path.close()
        
        path.fill()
        
        shapeLayer.path = path.cgPath
    }
}


