//
//  GlobalObject.swift
//
//
//  Created by 최준영 on 2024/01/01.
//

import SwiftUI
import Alamofire

public struct APIRequestGlobalObject {
    
    public var spotAccessToken: String!
    public var spotRefreshToken: String!
    
    public static var shared: APIRequestGlobalObject = .init()
    
    private init() { }
    
    let kAccessTokenKey = "spotAccessToken"
    let kRefreshTokenKey = "spotRefreshToken"
    
}

// MARK: - Errors
enum SpotApiRequestError: Error {
    
    case apiUrlError(discription: String)
    
}

// MARK: - API공통
public extension APIRequestGlobalObject {
    
    enum SpotAPI: CaseIterable {
        
        case getSpotToken
        case getPotCategory
        case postPot
        
        static let baseUrl = "http://43.201.220.214"
        
        public func getApiUrl() throws -> URL {
            
            var additinalUrl = ""
            
            switch self {
            case .getSpotToken:
                additinalUrl = "/auth/login/KAKAO"
            case .getPotCategory:
                additinalUrl = "/pot/category"
            case .postPot:
                additinalUrl = "/pot"
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


// MARK: - 로컬에 저장된 토큰 체크
extension APIRequestGlobalObject {
    
    // 토큰 저장
    public mutating func setToken(accessToken: String, refreshToken: String, isSaveInUserDefaults: Bool = false) {
        
        self.spotAccessToken = accessToken
        self.spotRefreshToken = refreshToken
        
        if isSaveInUserDefaults {
            
            UserDefaults.standard.set(accessToken, forKey: self.kAccessTokenKey)
            UserDefaults.standard.set(refreshToken, forKey: self.kRefreshTokenKey)

        }
        
    }
    
    // 로컬 토큰 존재확인
    public func checkTokenExistsInUserDefaults() -> (String, String)? {
        
        if let accessToken = UserDefaults.standard.string(forKey: self.kAccessTokenKey), let refreshToken = UserDefaults.standard.string(forKey: self.kRefreshTokenKey) {
            
            return (accessToken, refreshToken)
            
        }
        
        return nil
        
    }
    
}


// MARK: - SPOT서버로 토큰 요청 API
public struct SpotTokenResponse {
    
    public var accessToken: String
    public var refreshToken: String
    
}

public enum SpotNetworkError: Error {
    
    // TODO: 네트워크 에러 구체화
    case serverError
    case dataTransferError
    case wrongDataTransfer
    
}

extension APIRequestGlobalObject {
    
    public func sendAccessTokenToServer(accessToken: String, refreshToken: String, completion: @escaping (Result<SpotTokenResponse, SpotNetworkError>) -> Void) {
        
        let url = try! SpotAPI.getSpotToken.getApiUrl()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "accessToken": accessToken,
            "refreshToken": refreshToken
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData{ response in
                switch response.result {
                case .success(let data):
                    
                    if let decoded = try? JSONDecoder().decode(SpotTokenResponseModel.self, from: data) {
                        
                        let tokenData = SpotTokenResponse(accessToken: decoded.accessToken, refreshToken: decoded.refreshToken)
                        
                        completion(.success(tokenData))
                        
                        return
                        
                    }
                    
                    // 잘못된 데이터 전송으로인한 디코딩 실패
                    completion(.failure(.wrongDataTransfer))
                    
                    
                case .failure(let error):
                    
                    print("Server error: \(error.localizedDescription)")
                    
                    completion(.failure(.serverError))
                    
                }
        }
        
    }
    
}


// MARK: - Pot 업로드및 조회
public extension APIRequestGlobalObject {
    
    func uploadPot() throws {
        
        
        
    }
    
}
