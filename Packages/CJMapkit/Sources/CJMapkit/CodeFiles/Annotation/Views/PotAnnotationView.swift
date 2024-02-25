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
import DefaultExtensions
import Lottie
import Kingfisher

enum PotAnnotationViewConfig {
    static var annotationSize = CGSize(width: 52, height: 52)
}


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
        
        setUp(annotation: self.annotation as! PotAnnotation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        setNeedsDisplay()
    }
    
    override func prepareForReuse() {
        self.alpha = 1.0
        self.isHidden = false
    }
    
    func setUp(annotation: PotAnnotation) {
        
        self.collisionMode = .circle
        
        // Annotation크기 조정(collision을 위한 설정)
        self.frame.size = PotAnnotationViewConfig.annotationSize
        
        layer2.color = PotAnnotationType(rawValue: Int(annotation.potModel.categoryId))!.getAnnotationColor()
        
        // TapGesture
        // MapView를 거치지 않고 이벤트를 바로호출하는 경우가 훨씬 빠르다.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureCallBack))
        self.addGestureRecognizer(tapGesture)
        
        self.addSubview(layer1)
        self.layer1.addSubview(layer2)
        self.layer2.addSubview(layer3)
        
        // AutoLayout
        
        layer1.translatesAutoresizingMaskIntoConstraints = false
        layer2.translatesAutoresizingMaskIntoConstraints = false
        layer3.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            layer1.widthAnchor.constraint(equalToConstant: self.frame.width),
            layer1.heightAnchor.constraint(equalToConstant: self.frame.height),
            
            layer2.widthAnchor.constraint(equalTo: layer1.widthAnchor, constant: -6),
            layer2.heightAnchor.constraint(equalTo: layer1.heightAnchor, constant: -6),
            layer2.centerXAnchor.constraint(equalTo: layer1.centerXAnchor),
            layer2.centerYAnchor.constraint(equalTo: layer1.centerYAnchor),
            
            layer3.widthAnchor.constraint(equalTo: layer2.widthAnchor, constant: -6),
            layer3.heightAnchor.constraint(equalTo: layer2.heightAnchor, constant: -6),
            layer3.centerXAnchor.constraint(equalTo: layer2.centerXAnchor),
            layer3.centerYAnchor.constraint(equalTo: layer2.centerYAnchor),
        ])
        
        // shadow
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0
    }
    
    override func draw(_ rect: CGRect) {
        
        layer3.layer.cornerRadius = layer3.bounds.width / 2
        
        if let potAnot = annotation as? PotAnnotation, let imageKey = potAnot.potModel.imageKey {
            loadImageView(imageKey: imageKey)
        }
    }
    
    func loadImageView(imageKey: String) {
        
        let url = URL(string: imageKey.getPreSignedUrlString())
        
        let processor = DownsamplingImageProcessor(size: layer3.bounds.size) |> RoundCornerImageProcessor(cornerRadius: layer3.bounds.size.width/2)
        
        layer3.kf.indicatorType = .none
        layer3.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.5)),
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
    
    func pathForAnnotationViewCollisionBound(rect: CGRect) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        
        path.move(to: CGPoint(x: rect.width/2, y: rect.width/4))
        
        path.addArc(withCenter: center, radius: rect.width/2, startAngle: (-90 * .pi) / 180, endAngle: 0, clockwise: false)
        
        path.close()
        
        return path
    }
}

extension PotAnnotationView {
    
    @objc
    func tapGestureCallBack() {
        
        let potModel = (annotation as! PotAnnotation).potModel
        
        let to: [String: Any?] = [
            "model" : potModel
        ]
        
        NotificationCenter.potSelection.post(name: .singlePotSelection, object: to)
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


