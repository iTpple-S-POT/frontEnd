//
//  SwiftUI.swift
//
//
//  Created by 최준영 on 2024/01/11.
//

import SwiftUI
import Alamofire

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
        
//        if let data = UserDefaults.standard.data(forKey: kPotCategory) {
//            
//            let decoded = try? JSONDecoder().decode([PotCategory].self, from: data)
//            
//            self.potCategories = decoded
//            
//            return
//        }
//        
//        let url = try! SpotAPI.getPotCategory.getApiUrl()
//        
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(spotAccessToken!)",
//            "Content-Type": "application/json",
//        ]
//        
//        AF
//            .request(url, method: .get, headers: headers)
//            .validate(statusCode: 200..<300)
//            .responseData { reponse in
//                switch reponse.result {
//                case .success(let data):
//                    
//                    guard let decoded = try? JSONDecoder().decode(SpotPotCategoryModel.self, from: data) else {
//                        return completion(.failure(.wrongDataTransfer))
//                    }
//                    
//                    completion(.success(decoded.categoryList))
//                    
//                case .failure(let error):
//                    
//                    // TODO: 에러 구체화
//                    completion(.failure(.serverError))
//                    
//                }
//            }
        
        
    }
    
    // 팟 업로드
    // TODO: 카테고리 수정
    func uploadPot(imageInfo: ImageInformation, uploadObject: SpotPotUploadObject) {
        
//        Task {
//            
//            do {
//                let psObject = try await getPreSignedUrl(imageInfo: imageInfo)
//                
//                try uploadImageToS3(psUrlString: psObject.preSignedUrl, imageData: imageInfo.data) {
//                    result in
//                    
//                    switch result {
//                    case .success( _ ):
//                            
//                        // TODO: await 처리방법 생각하기
//                        try? self.uploadPotData(fileKey: psObject.fileKey, uploadObject: uploadObject)
//
//       
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                    
//                }
//                
//                
//            }
//            catch {
//                
//                print(error.localizedDescription)
//                
//            }
//            
//        }
    }
    
    
    private func getPreSignedUrl(
        imageInfo: ImageInformation) async throws -> PreSignedUrlObject {
            
            let url = try! SpotAPI.preSignedUrl.getApiUrl()
            
            let fileName = imageInfo.id.uuidString + "." + imageInfo.ext
            

            var request = try URLRequest(url: url, method: .post)
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue(getBearerAuthorizationValue, forHTTPHeaderField: "Authorization")
            
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
                throw SpotNetworkError.dataRequestError
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
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue(getBearerAuthorizationValue, forHTTPHeaderField: "Authorization")
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
