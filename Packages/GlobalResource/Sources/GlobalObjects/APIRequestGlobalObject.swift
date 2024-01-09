//
//  GlobalObject.swift
//
//
//  Created by 최준영 on 2024/01/01.
//

import SwiftUI
import Alamofire

public class APIRequestGlobalObject {
    
    public var spotAccessToken: String!
    public var spotRefreshToken: String!
    
    public var potCategories: [PotCategory]!
    
    public static var shared: APIRequestGlobalObject = .init()
    
    private init() { }
    
    // tokens
    let kAccessTokenKey = "spotAccessToken"
    let kRefreshTokenKey = "spotRefreshToken"
    
    // pot
    let kPotCategory = "spotPotCategory"
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        return Session(configuration: configuration)
    }()
    
    
    // 연산 프로퍼티
    private var getBearerAuthorizationValue: String {
        
        return "Bearer \(spotAccessToken!)"
        
    }
    
}

// MARK: - Errors
enum SpotApiRequestError: Error {
    
    case apiUrlError(discription: String)
    
}

// MARK: - API공통

// 네트워크통신 에러
public enum SpotNetworkError: Error {
    
    // TODO: 네트워크 에러 구체화
    case serverError
    case dataTransferError
    case wrongDataTransfer
    
    case cantFindRefreshToken
    
    case urlError(description: String)
    
}

public extension APIRequestGlobalObject {
    
    enum SpotAPI: CaseIterable {
        
        case getSpotToken
        case refreshSpotToken
        case getPotCategory
        case postPot
        case preSignedUrl
        
        static let baseUrl = "http://43.201.220.214"
        
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


// MARK: - 로컬에 저장된 토큰 체크
extension APIRequestGlobalObject {
    
    // 토큰 저장
    public func setToken(accessToken: String, refreshToken: String, isSaveInUserDefaults: Bool = false) {
        
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

public extension APIRequestGlobalObject {
    
    func sendAccessTokenToServer(accessToken: String, refreshToken: String, completion: @escaping (Result<SpotTokenResponse, SpotNetworkError>) -> Void) {
        
        let url = try! SpotAPI.getSpotToken.getApiUrl()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "accessToken": accessToken,
            "refreshToken": refreshToken
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { self.tokenRequestCompletionHandler(response: $0, completion: completion) }
        
    }
    
    func refreshTokens(completion: @escaping (Result<SpotTokenResponse, SpotNetworkError>) -> Void) {
        
        let url = try! SpotAPI.refreshSpotToken.getApiUrl()
        
        let parameter: [String: Any] = [
            "refreshToken": spotRefreshToken!
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF
            .request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { self.tokenRequestCompletionHandler(response: $0, completion: completion) }
        
    }
    
    private func tokenRequestCompletionHandler(response: AFDataResponse<Data>, completion: (Result<SpotTokenResponse, SpotNetworkError>) -> Void) {
        
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
            
            completion(.failure(.cantFindRefreshToken))
            
        }
        
    }
    
}


// MARK: - API: 팟업로드및 조회
public extension APIRequestGlobalObject {
    
    func getCategory() {
        
        getCategory { result in
            
            switch result {
            case .success(let data):
                
                self.potCategories = data
                
            case .failure(let error):
                
                switch error {
                    // TODO: 추후 구현
                default:
                    return
                }
            }
            
        }
        
        
    }
    
    // 카테고리 탐색
    private func getCategory(completion: @escaping (Result<[PotCategory], SpotNetworkError>) -> Void) {
        
        if let data = UserDefaults.standard.data(forKey: kPotCategory) {
            
            let decoded = try? JSONDecoder().decode([PotCategory].self, from: data)
            
            self.potCategories = decoded
            
            return
        }
        
        let url = try! SpotAPI.getPotCategory.getApiUrl()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(spotAccessToken!)",
            "Content-Type": "application/json",
        ]
        
        AF
            .request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { reponse in
                switch reponse.result {
                case .success(let data):
                    
                    guard let decoded = try? JSONDecoder().decode(SpotPotCategoryModel.self, from: data) else {
                        return completion(.failure(.wrongDataTransfer))
                    }
                    
                    completion(.success(decoded.categoryList))
                    
                case .failure(let error):
                    
                    // TODO: 에러 구체화
                    completion(.failure(.serverError))
                    
                }
            }
        
        
    }
    
    // 팟 업로드
    // TODO: 카테고리 수정
    func uploadPot(imageInfo: ImageInformation, uploadObject: SpotPotUploadObject) {
        
        Task {
            
            do {
                let psObject = try await getPreSignedUrl(imageInfo: imageInfo)
                
                try uploadImageToS3(psUrlString: psObject.preSignedUrl, imageData: imageInfo.data) {
                    result in
                    
                    switch result {
                    case .success( _ ):
                            
                        // TODO: await 처리방법 생각하기
                        try? self.uploadPotData(fileKey: psObject.fileKey, uploadObject: uploadObject)

       
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    
                }
                
                
            }
            catch {
                
                print(error.localizedDescription)
                
            }
            
        }
    }
    
    
    private func getPreSignedUrl(
        imageInfo: ImageInformation) async throws -> PreSignedUrlObject {
            
            let url = try! SpotAPI.preSignedUrl.getApiUrl()
            
            let fileName = imageInfo.id.uuidString + "." + imageInfo.ext
            

            var request = try URLRequest(url: url, method: .post)
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(getBearerAuthorizationValue, forHTTPHeaderField: "Authorization")
            
            request.timeoutInterval = 10
            
            
            // POST 로 보낼 정보
            let params: [String: Any] = [
                "fileName" : fileName
            ]
            
            print(fileName)
            
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
            
            let re = AF.request(request)
            
            let dataTask = re.serializingDecodable(PreSignedUrlResponseModel.self)
            
            switch await dataTask.result {
                
            case .success(let object):
                return PreSignedUrlObject(preSignedUrl: object.preSignedUrl, fileKey: object.fileKey)
            case .failure:
                throw SpotNetworkError.dataTransferError
            }
        }
    
    
    private func uploadImageToS3(psUrlString: String, imageData: Data, comepletion: @escaping (Result<Bool, SpotNetworkError>) -> Void) throws {
        
        print(psUrlString)
        
        guard let url = URL(string: psUrlString) else {
            throw SpotNetworkError.urlError(description: "presigned url, url 전환 에러")
        }
        
        var request = try URLRequest(url: url, method: .put)
        request.timeoutInterval = 0
        request.setValue("binary/octet-stream", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData
        
        AF
            .request(request)
            .validate()
            .response { response in
                switch response.result {
                case .success( _ ):
                    comepletion(.success(true))
                case .failure( _ ):
                    comepletion(.failure(.serverError))
                }
            }
        
        
    }
    
    // TODO: 카테고리 수정
    private func uploadPotData(fileKey: String, uploadObject: SpotPotUploadObject) throws {
        
        let data = SpotPotUploadRequestModel(
            categoryID: uploadObject.category,
            imageKey: fileKey,
            type: "IMAGE",
            location: Location(lat: uploadObject.latitude, lon: uploadObject.longitude),
            content: uploadObject.text
        )
        
        print(data)
        
        let url = try! SpotAPI.postPot.getApiUrl()
        
        var request = try URLRequest(url: url, method: .post)
        
        print(getBearerAuthorizationValue)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(getBearerAuthorizationValue, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10
        request.httpBody = try JSONEncoder().encode(data)
        
        AF
            .request(request)
            .validate()
            .response { result in
                
                switch result.result {
                case .success(_):
                    print("success")
                case .failure(_):
                    print("failure")
                }
                
            }
        
//        let re = AF.request(request)
//        
//        let dataTask = re.serializingDecodable(SpotPotUploadResponseModel.self)
//        
//        switch await dataTask.result {
//            
//        case .success(let data):
//            
//            print(data)
//            
//            return true
//        case .failure:
//            throw SpotNetworkError.dataTransferError
//            
//        }
    }
}
