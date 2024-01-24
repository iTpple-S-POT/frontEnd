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
        
        view.subView = animationView
        
        return view
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        guard let annotation = annotation as? PotAnnotation else {
            preconditionFailure("타입변환 불가")
        }
        
        self.annotation = annotation
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
    
    func setUp() {
        
        guard let annotation = self.annotation as? PotAnnotation else {
            
            fatalError("잘못된 Annotation할당")
        }
        
        // 이미지 처리
        // 일시적 이미지(팟 업로드 전)
        if !annotation.isActive, let imageData = annotation.temporalImageData {
            
            layer3.image = UIImage(data: imageData)
        }
        
        // 팟 업로드 후 처리
        
        let layer1 = PotShapeView()
        layer1.color = .white
        
        let layer2 = PotShapeView()
        layer2.color = PotAnnotationType(rawValue: Int(annotation.potObject.categoryId))!.getAnnotationColor()
        
        // 이미지 세팅
        
    
        self.addSubview(layer1)
        self.addSubview(layer2)
        self.addSubview(layer3)
        
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
        
        if !annotation.isActive {
            
            self.addSubview(loadingLayer)
            
            loadingLayer.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                loadingLayer.widthAnchor.constraint(equalTo: self.widthAnchor),
                loadingLayer.heightAnchor.constraint(equalTo: self.heightAnchor),
                loadingLayer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                loadingLayer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ])
        }
        
        // shadow
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = self.bounds.height
        
        self.bounds.origin.y = sqrt(2.0) * height/2
        
        layer3.layer.cornerRadius = layer3.frame.width / 2
        
        setUp()
    }
    
}

private class PotShapeView: UIView {
    
    var color: UIColor = .black
    
    var subView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        defaultSetUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        defaultSetUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateShape()
    }
    
    func defaultSetUp() {
        
        self.backgroundColor = .clear
    }
    
    
    func updateShape() {
        
        self.drawCustomShape(color: color)
        
        if let sub = subView {
            self.bringSubviewToFront(sub)
        }
    }
}

// MARK: - Test


class PotAnnotationViewTest: UIView {
    
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
        
        view.subView = animationView
        
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp(potData: PotAnnotation(isActive: true, potObject: PotObject(id: 1, userId: 1, categoryId: 1, content: "", imageKey: "", expirationDate: "", latitude: 1, longitude: 1)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
    
    func setUp(potData: PotAnnotation) {
        
        let layer1 = PotShapeView()
        layer1.color = .white
        
        let layer2 = PotShapeView()
        layer2.color = .black
        
        // 이미지 세팅
        
        self.addSubview(layer1)
        self.addSubview(layer2)
        self.addSubview(layer3)
        
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
        
        if potData.isActive {
            
            self.addSubview(loadingLayer)
            
            loadingLayer.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                loadingLayer.widthAnchor.constraint(equalTo: self.widthAnchor),
                loadingLayer.heightAnchor.constraint(equalTo: self.heightAnchor),
                loadingLayer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                loadingLayer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ])
        }
        
        
        // shadow
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = self.bounds.height
        
        self.bounds.origin.y = sqrt(2.0) * height/2
        
        layer3.layer.cornerRadius = layer3.frame.width / 2
    }
    
}



private struct MyUIViewWrapper: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        
        let conatinerView = PotAnnotationViewTest()
        return conatinerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
        
    }
    
}

private extension UIView {
    func drawCustomShape(color: UIColor) {
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.frame = self.bounds
        shapeLayer.lineWidth = 0.0
        shapeLayer.fillColor = color.cgColor
        
        self.layer.addSublayer(shapeLayer)
        
        let path = UIBezierPath()
        
        let rect = self.frame.size
        
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


#Preview {
    ZStack {
        
        Color.brown
        
        Rectangle()
            .fill(.red)
            .frame(height: 1)
        
        Rectangle()
            .fill(.red)
            .frame(width: 1)
        
        MyUIViewWrapper()
            .frame(width: 56, height: 56)
    }
}
