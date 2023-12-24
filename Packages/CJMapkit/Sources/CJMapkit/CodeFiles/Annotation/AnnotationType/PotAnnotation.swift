//
//  PotDefaultAnnotation.swift
//
//
//  Created by 최준영 on 2023/12/24.
//

import CoreLocation
import UIKit

public class PotAnnotation: NSObject, AnnotationClassType {
    
    public var type: PotAnnotationType
    
    public var coordinate: CLLocationCoordinate2D
    
    public init(type: PotAnnotationType, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.type = type
    }
    
}

public enum PotAnnotationType: String, CaseIterable {
    case life = "life"
    case event = "event"
    case party = "party"
    case information = "information"
    case question = "question"
    
    func getUIImage() -> UIImage {
        
        let fileName = "pot_anot_\(self.rawValue)"
        
        let path = Bundle.module.provideFilePath(name: fileName, ext: "png")
        
        return UIImage(named: path)!
        
    }
}




