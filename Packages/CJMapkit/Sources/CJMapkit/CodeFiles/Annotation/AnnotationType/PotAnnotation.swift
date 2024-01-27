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

public class PotAnnotation: NSObject, Identifiable, AnnotationClassType {
//    public var id = UUID() // 고유 식별자를 위한 UUID 추가
//    public var type: PotAnnotationType

    public var coordinate: CLLocationCoordinate2D
    
    var isActive: Bool
    
    var isHiiden: Bool = false
    
    var potObject: PotObject
    
    var thumbNailIamgeUrl: URL?
    
    public init(coordinate: CLLocationCoordinate2D, isActive: Bool, potObject: PotObject, thumbNailIamgeUrl: URL? = nil) {
        
        self.coordinate = coordinate
        
        self.isActive = isActive
        
        self.potObject = potObject
        
        self.coordinate = CLLocationCoordinate2D(latitude: potObject.latitude, longitude: potObject.longitude)
        
        self.thumbNailIamgeUrl = thumbNailIamgeUrl
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



