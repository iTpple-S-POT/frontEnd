//
//  SpotPotUploadRequestModel.swift
//
//
//  Created by 최준영 on 2024/01/04.
//

import Foundation

struct SpotPotUploadRequestModel: Codable {
    let categoryId: Int64
    let imageKey: String
    let type: String
    let location: Location
    let content: String
}

// MARK: - Location
struct Location: Codable {
    let lat, lon: Double
}


public struct SpotPotUploadObject {
    
    let category: Int64
    let text: String
    let latitude: Double
    let longitude: Double
    
    public init(category: Int64, text: String, latitude: Double, longitude: Double) {
        self.category = category
        self.text = text
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
