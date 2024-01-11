//
//  Common.swift
//
//
//  Created by 최준영 on 2024/01/11.
//

import SwiftUI

// MARK: - API공통

// 네트워크통신 에러
public enum SpotNetworkError: Error {

    case kakaoServerError
    case serverError
    case clientError
    case dataRequestError
    case dataResponseError
    case urlError(description: String)
    case unProcessedStatusCode
    case unownedError
    
}

public extension APIRequestGlobalObject {
    
    enum SpotAPI: CaseIterable {
        
        case getSpotToken
        case refreshSpotToken
        case getPotCategory
        case postPot
        case preSignedUrl
        
        static let baseUrl = "http://13.209.233.160"
        
        public func getApiUrl() throws -> URL {
            
            var additinalUrl = ""
            
            switch self {
            case .getSpotToken:
                additinalUrl = "/auth/login/KAKAO"
            case .refreshSpotToken:
                additinalUrl = "/auth/refresh"
            case .getPotCategory:
                additinalUrl = "/pot/category"
            case .postPot:
                additinalUrl = "/pot"
            case .preSignedUrl:
                additinalUrl = "/pot/image/pre-signed-url"
            @unknown default:
                throw SpotApiRequestError.apiUrlError(discription: "주소가 지정되지 않은 API가 있습니다.")
            }
            
            guard let url = URL(string: Self.baseUrl + additinalUrl) else {
                throw SpotApiRequestError.apiUrlError(discription: "잘못된 문자열구성으로 URL을 생성할 수 없습니다.")
            }
            
            return url
            
        }
        
    }
    
}
