//
//  ReportModel.swift
//
//
//  Created by 최준영 on 3/5/24.
//

import Foundation

// 리퀘스트 모델
struct ReportModel: Encodable {
    
    let reportType: String
    let reportContent: String
    
    enum CodingKeys: CodingKey {
        case reportType
        case reportContent
    }
}

// 리스폰스 모델
struct ReportResponseModel: Decodable {
    
    let reportId: Int64?
    let potId: Int64?
    let reporterId: Int64?
    let reportType: String?
    let reportContent: String?
    
    enum CodingKeys: CodingKey {
        case reportId
        case potId
        case reporterId
        case reportType
        case reportContent
    }
}
