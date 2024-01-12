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

    case kakaoServerError(function: String)
    case serverError(function: String)
    case clientError(function: String)
    case dataRequestError(function: String)
    case dataResponseError(function: String)
    case notFoundError(description: String)
    case unProcessedStatusCode(function: String)
    case unownedError(function: String)
    case authorizationError(function: String)
    
}

public extension APIRequestGlobalObject {
    
    enum SpotAPI: CaseIterable {
        
        case getSpotTokenFromKakao
        case getSpotTokenFromApple
        case refreshSpotToken
        case getPotCategory
        case postPot
        case preSignedUrl
        
        static let baseUrl = "http://13.209.233.160"
        
        public func getApiUrl() throws -> URL {
            
            var additinalUrl = ""
            
            switch self {
            case .getSpotTokenFromKakao:
                additinalUrl = "/api/v1/auth/login/KAKAO"
            case .getSpotTokenFromApple:
                additinalUrl = "/api/v1/auth/login/APPLE"
            case .refreshSpotToken:
                additinalUrl = "/api/v1/auth/refresh"
            case .getPotCategory:
                additinalUrl = "/api/v1/pot/category"
            case .postPot:
                additinalUrl = "/api/v1/pot"
            case .preSignedUrl:
                additinalUrl = "/api/v1/pot/image/pre-signed-url"
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


// MARK: - Error Handling
extension APIRequestGlobalObject {
        
    // 에러를 던지지 않으면 성공
    func defaultCheckStatusCode(response: HTTPURLResponse, functionName: String, data: Data) throws {
        
        let statusCode = response.statusCode
        
        if !(200..<300).contains(statusCode) {
            
            if let error = try? jsonDecoder.decode(SpotErrorMessageModel.self, from: data) {
                print("\(functionName) 에러코드: \(error.code) 메세지: \(error.message)")
            }
            
            switch statusCode {
            case 401:
                throw SpotNetworkError.authorizationError(function: functionName)
            case 404:
                throw SpotNetworkError.notFoundError(description: functionName)
            case 400..<500:
                throw SpotNetworkError.clientError(function: functionName)
            case 500..<600:
                throw SpotNetworkError.serverError(function: functionName)
            default:
                throw SpotNetworkError.unProcessedStatusCode(function: functionName)
            }
            
        }
        
    }
    
}
