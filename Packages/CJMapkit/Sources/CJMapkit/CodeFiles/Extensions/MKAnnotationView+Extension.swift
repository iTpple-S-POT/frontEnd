//
//  MKAnnotationView+Extension.swift
//
//
//  Created by 최준영 on 2/5/24.
//
import UIKit
import MapKit

extension MKAnnotationView {
    
    private struct Holder {
        static var heldSavedCollision = [String: CollisionMode]()
        static var heldSavedAnnotation = [String: MKAnnotation]()
    }
    
    var savedAnnotation: MKAnnotation? {
        get { return Holder.heldSavedAnnotation[debugDescription] ?? nil }
        set(newValue) { Holder.heldSavedAnnotation[debugDescription] = newValue }
    }
    
    // used for saving and restoring collisionmode
    var savedCollision: CollisionMode? {
        get { return Holder.heldSavedCollision[debugDescription] ?? nil }
        set(newValue) { Holder.heldSavedCollision[debugDescription] = newValue }
    }
    
    func hideAnimated(withDuration: Double = 0.2 , delay: Double = 0, completion: (() -> Void)? = nil) {
        savedAnnotation = self.annotation
        self.savedCollision = self.collisionMode
        
        let dispGroup = DispatchGroup()
        dispGroup.enter()
        DispatchQueue.main.async(group: dispGroup) {
            // small delay is needed to make the collisons recalculate
            UIView.animate(withDuration: withDuration, delay: delay, options: .curveEaseInOut,
                           animations: { self.alpha = 0 },
                           completion: { _ in dispGroup.leave()})
        }
        
        dispGroup.notify(queue: .main) {
            self.collisionMode = .none
            
            // don't complete the animation if the annotation has changed meanwhile
            // when using reusable annotations the annotation could have changed
            // while the animation was running
            // therefore we dont want to complete the animation when the annotation has changed
            
            if self.hasAnnotationChanged() {
                completion?()
                return
                
            } else {
                self.alpha = 0
                self.isHidden = true
                completion?()
            }
            
        }
    }
    
    func hide() {
        savedCollision = collisionMode
        collisionMode = .none
        alpha = 0
        isHidden = true
    }
    
    private func hasAnnotationChanged() -> Bool {
        return !(self.savedAnnotation?.title == self.annotation?.title && self.savedAnnotation?.subtitle == self.annotation?.subtitle)
    }
    
    func showAnimated(withDuration: Double = 0.2 , delay: Double = 0, completion: (() -> Void)? = nil) {
        savedAnnotation = self.annotation
        collisionMode = savedCollision ?? .rectangle
        
        isHidden = false
        
        let dispGroup = DispatchGroup()
        dispGroup.enter()
        DispatchQueue.main.async(group: dispGroup) {
            // small delay is needed to make the collisons recalculate
            UIView.animate(withDuration: withDuration, delay: delay, options: .curveEaseInOut,
                           animations: { self.alpha = 1.0 },
                           completion: { _ in dispGroup.leave() }
            )
        }
        
        dispGroup.notify(queue: .main) {
            // don't complete the animation if the annotation has changed meanwhile
            if self.hasAnnotationChanged() {
                completion?()
                return
            } else {
                self.alpha = 1
                completion?()
            }
        }
        
    }
    
    func show() {
        collisionMode = savedCollision ?? .rectangle
        alpha = 1
        isHidden = false
    }
}
