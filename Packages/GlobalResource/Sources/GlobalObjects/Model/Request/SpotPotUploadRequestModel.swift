//
//  SpotPotUploadRequestModel.swift
//
//
//  Created by 최준영 on 2024/01/04.
//

import Foundation

struct SpotPotUploadRequestModel: Codable {
    let categoryID: Int
    let imageKey: String?
    let type: String
    let location: Location
    let content: String

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case imageKey, type, location, content
    }
}

// MARK: - Location
struct Location: Codable {
    let lat, lon: Double
}


