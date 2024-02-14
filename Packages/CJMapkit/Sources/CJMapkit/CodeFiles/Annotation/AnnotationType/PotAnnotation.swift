//
//  PotDefaultAnnotation.swift
//
//
//  Created by 최준영 on 2023/12/24.
//

import CoreLocation
import SwiftUI
import DefaultExtensions
import GlobalObjects
import MapKit

class PotAnnotation: NSObject, Identifiable, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    
    var potModel: PotModel
    
    public init(potModel: PotModel) {
        
        self.potModel = potModel
        
        self.coordinate = CLLocationCoordinate2D(latitude: potModel.latitude, longitude: potModel.longitude)
    }
}

enum ImageDownloadError: Error {
    
    case downloadError
    case internetError
    
}

public enum PotAnnotationType: Int, CaseIterable {
    
    case hot
    case life
    case question
    case information
    case party
    
    func getAnnotationColor() -> UIColor {
        
        switch self {
        case .hot:
            return .tag_red
        case .life:
            return .tag_yellow
        case .question:
            return .tag_green
        case .information:
            return .tag_purple
        case .party:
            return .tag_blue
        }
        
    }
    
}

extension UIColor {
    
    static var tag_red: UIColor { UIColor(hex: "FF533F") }
    static var tag_yellow: UIColor { UIColor(hex: "FFB800") }
    static var tag_green: UIColor { UIColor(hex: "86CC40") }
    static var tag_purple: UIColor { UIColor(hex: "D092ED") }
    static var tag_blue: UIColor { UIColor(hex: "5EA7FF") }
    
}



