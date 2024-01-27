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

class PotAnnotationView: MKAnnotationView {
    
    let layer3: UIImageView = {
        
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        let path = Bundle.module.provideFilePath(name: "test", ext: "png")
        
        view.image = UIImage(named: path)
        
        return view
    }()
    
    let loadingLayer: UIView  = {
        
        let path = Bundle.module.provideFilePath(name: "pot_upload_loading_lottie", ext: "json")
        
        let view = PotShapeView()
        view.color = .black.withAlphaComponent(0.3)
        
        let animationView = LottieAnimationView(filePath: path)
        
        animationView.loopMode = .loop
        
        animationView.play()
        
        // AutoLayout
        view.translatesAutoresizingMaskIntoConstraints = false
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
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
        
        self.clipsToBounds = false
        
        // 로딩화면 최초처리
        if annotation.isActive {
            
            turnOffLoadingLayer()
        } else {
            
            turnOnLoadingLayer()
        }
        
        // 이미지 처리
        if let imageUrl = annotation.thumbNailIamgeUrl, let imageData = try? Data(contentsOf: imageUrl) {
            
            print("이미지 데이터가 존재합니다.")
            
            layer3.image = UIImage(data: imageData)
        }
        
        // 팟 업로드 후 처리
        let layer1 = PotShapeView()
        layer1.color = .white
        
        let layer2 = PotShapeView()
        layer2.color = PotAnnotationType(rawValue: Int(annotation.potObject.categoryId))!.getAnnotationColor()
        
        self.addSubview(layer1)
        self.addSubview(layer2)
        self.addSubview(layer3)
        self.addSubview(loadingLayer)
        
        layer1.translatesAutoresizingMaskIntoConstraints = false
        layer2.translatesAutoresizingMaskIntoConstraints = false
        layer3.translatesAutoresizingMaskIntoConstraints = false
        loadingLayer.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            loadingLayer.widthAnchor.constraint(equalTo: self.widthAnchor),
            loadingLayer.heightAnchor.constraint(equalTo: self.heightAnchor),
            loadingLayer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingLayer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
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
        
        self.bounds.origin.y = -sqrt(2.0) * height/2
        
        layer3.layer.cornerRadius = layer3.frame.width / 2
    }
    
    func turnOffLoadingLayer() {
        
        loadingLayer.isHidden = true
        
        if let lottieView = loadingLayer.subviews.first! as? LottieAnimationView {
            lottieView.stop()
        }
        
        setNeedsDisplay()
    }
    
    func turnOnLoadingLayer() {
        
        loadingLayer.isHidden = false
        
        if let lottieView = loadingLayer.subviews.first! as? LottieAnimationView {
            lottieView.play()
        }
        
        setNeedsDisplay()
    }
}


private class PotShapeView: UIView {
    
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


