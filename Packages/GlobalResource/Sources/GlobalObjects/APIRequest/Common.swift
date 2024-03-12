//
//  Common.swift
//
//
//  Created by 최준영 on 2024/01/11.
//

import SwiftUI
import Alamofire

// MARK: - API공통

// 네트워크통신 에러
public enum SpotNetworkError: Error, Equatable {

    case kakaoServerError(function: String)
    case serverError(function: String)
    case clientError(function: String)
    case dataRequestError(function: String)
    case dataResponseError(function: String)
    case notFoundError(description: String)
    case unProcessedStatusCode(function: String)
    case unknownError(function: String)
    case authorizationError(function: String)
    case duplicatedReaction
    case duplicatedHashTag
}


// MARK: - API cases
public extension APIRequestGlobalObject {
    
    enum LoginType {
        
        case kakao, apple
        
        func getKorName() -> String {
            switch self {
            case .kakao:
                return "KAKAO"
            case .apple:
                return "APPLE"
            }
        }
        
    }
    
    enum SpotAPI {
        
        // Authentication
        case getSpotTokenFrom(service: LoginType)
        case refreshSpotToken
        
        // Data
        case getPotCategory
        
        // Pot
        case getPots
        case postPot
        case preSignedUrl
        case potHashtag
        case recentlyViewed
        case myPot
        
        // User
        case userInfo
        case userNickNameCheck
        
        // Reaction
        case reaction
        
        public static var baseUrl = ""
        
        public func getApiUrl() throws -> URL {
            
            var additinalUrl = ""
            
            switch self {
            case .getSpotTokenFrom(let service):
                additinalUrl = "/api/v1/auth/login/\(service.getKorName())"
            case .refreshSpotToken:
                additinalUrl = "/api/v1/auth/refresh"
            case .getPotCategory:
                additinalUrl = "/api/v1/pot/category"
            case .getPots, .postPot:
                additinalUrl = "/api/v1/pot"
            case .potHashtag:
                additinalUrl = "/api/v1/pot/hashtag"
            case .preSignedUrl:
                additinalUrl = "/api/v1/pot/image/pre-signed-url"
            case .recentlyViewed:
                additinalUrl = "/api/v1/pot/recently-viewed"
            case .myPot:
                additinalUrl = "/api/v1/pot/my"
            case .userInfo:
                additinalUrl = "/api/v1/user"
            case .userNickNameCheck:
                additinalUrl = "/api/v1/user/nickname/check"
            case .reaction:
                additinalUrl = "/api/v1/reaction"
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

// MARK: - Request
public extension APIRequestGlobalObject {
    
    func getURLRequest(url: URL, method: HTTPMethod, isAuth: Bool = true) throws -> URLRequest {
        
        var request = try URLRequest(url: url, method: method)
        
        request.headers = [
            "Content-Type" : "application/json",
        ]
        
        if isAuth {
            
            request.setValue("Bearer \(spotAccessToken!)", forHTTPHeaderField: "Authorization")
            
        }
        
        return request
    }
    
}

// MARK: - Errors
enum SpotApiRequestError: Error {
    
    case apiUrlError(discription: String)
    
}

