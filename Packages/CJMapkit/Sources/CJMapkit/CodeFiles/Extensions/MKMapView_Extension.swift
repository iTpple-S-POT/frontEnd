//
//  MKMapView_Extension.swift
//
//
//  Created by 최준영 on 2/5/24.
//
import UIKit
import MapKit

extension MKMapView {
    
    func unhideAnnotation(_ annotation: MKAnnotation, animated: Bool = false, withDuration: Double = 0.2, delay: Double = 0,
                          completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if let annotationView = self.view(for: annotation) {
                if animated {
                    annotationView.showAnimated(withDuration: withDuration , delay: delay,  completion: completion)
                } else {
                    annotationView.show()
                    completion?()
                }
            }
        }
    }
    
    /**
     shows all given annotations
     completion is run after all annotations are shown
     */
    func unhideAnnotations(_ annotations: [MKAnnotation], animated: Bool = false, withDuration: Double = 0.2, delay: Double = 0,
                           completion: (() -> Void)? = nil) {
        
        let dispGroup = DispatchGroup()
        for annotation in annotations {
            dispGroup.enter()
            unhideAnnotation(annotation, animated: animated, withDuration: withDuration , delay: delay, completion: {
                dispGroup.leave()
            })
        }
        
        dispGroup.notify(queue: .main) {
            completion?()
        }
        
    }
    
    
    func hideAnnotation(_ annotation: MKAnnotation, animated: Bool = false, withDuration: Double = 0.2 , delay: Double = 0, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if let annotationView = self.view(for: annotation) {
                if animated {
                    annotationView.hideAnimated(withDuration: withDuration , delay: delay, completion: completion)
                } else {
                    annotationView.hide()
                    completion?()
                }
            } else {
                // when no annotationview is found run the completion
                completion?()
            }
        }
    }
    
    func hideAnnotations(_ annotations: [MKAnnotation], animated: Bool = false, withDuration: Double = 0.2, delay: Double = 0,
                         completion: (() -> Void)? = nil) {
        let dispGroup = DispatchGroup()
        for annotation in annotations {
            dispGroup.enter()
            hideAnnotation(annotation, animated: animated, withDuration: withDuration , delay: delay,  completion: {
                dispGroup.leave()
            })
        }
        
        dispGroup.notify(queue: .main) {
            completion?()
        }
    }
    
}
