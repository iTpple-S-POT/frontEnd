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
    
    // 카테고리 탐색
    func getCategoryFromServer() async throws -> [CategoryObject] {
        
        let url = try SpotAPI.getPotCategory.getApiUrl()
        
        let request = try getURLRequest(url: url, method: .get)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
            
            // status code 정상
            let decoded = try jsonDecoder.decode(PotCategoryModel.self, from: data)
            
            return decoded.categoryList.map { CategoryObject(id: $0.id, name: $0.name, description: $0.description) }
            
        }
        
        throw SpotNetworkError.unknownError(function: #function)
    }
    
    // 팟 업로드 태스크 실행
    func executePotUpload(imageInfo: ImageInformation, uploadObject: SpotPotUploadObject) async throws -> PotObject {
        
        let s3Object = try await getPreSignedUrl(imageInfo: imageInfo)
        
        guard let preUrl = URL(string: s3Object.preSignedUrl) else {
            throw SpotNetworkError.notFoundError(description: "pre-signed-url 생성 에러")
        }
        
        try await uploadImageToS3(url: preUrl, imageData: imageInfo.data)
        
        print("S3 업로드 성공", s3Object.fileKey)
        
        let hashtagList = try await postHashtags(hashtags: uploadObject.hashtagList)
        
        print(hashtagList)
        
        print("해쉬테그 id로 변환 성공")
        
        let object = SpotPotUploadRequestModel(
            categoryId: uploadObject.category,
            imageKey: s3Object.fileKey,
            type: "IMAGE",
            location: Location(lat: uploadObject.latitude, lon: uploadObject.longitude),
            content: uploadObject.text,
            hashtagIdList: hashtagList.map { $0.hashtagId }
        )
        
        let uploadedObject = try await uploadPotData(object: object)
        
        print("팟 업로드 성공")
        
        return uploadedObject
    }
    
    private func postHashtags(hashtags: [String]) async throws -> [HashTagDTO] {
        
        if hashtags.isEmpty { return [] }
        
        let url = try SpotAPI.potHashtag.getApiUrl()
        
        var request = try getURLRequest(url: url, method: .post, isAuth: true)
        
        let jsonObject: [String: Any] = [ "hashtagList" : hashtags ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: jsonObject)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
            
            // status code 정상
            return try jsonDecoder.decode([HashTagDTO].self, from: data)
            
        } else {
            
            throw SpotNetworkError.unknownError(function: #function)
        }
    }
    
    // PreSignedUrl획득
    private func getPreSignedUrl(
        imageInfo: ImageInformation) async throws -> PreSignedUrlObject {
            
            let url = try! SpotAPI.preSignedUrl.getApiUrl()
            
            let fileName = imageInfo.id.uuidString + "." + imageInfo.ext
            
            var request = try getURLRequest(url: url, method: .post)
            
            let jsonObject: [String: Any] = ["fileName": fileName]
            
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonObject)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                
                try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
                
                // status code 정상
                let decoded = try jsonDecoder.decode(PreSignedUrlResponseModel.self, from: data)
                
                return PreSignedUrlObject(preSignedUrl: decoded.preSignedUrl, fileKey: decoded.fileKey)
            } else {
                
                throw SpotNetworkError.unknownError(function: #function)
            }
            
        }
    
    // S3에 업로드
    private func uploadImageToS3(url: URL, imageData: Data) async throws {
        
        var request = try getURLRequest(url: url, method: .put, isAuth: false)
        request.setValue("binary/octet-stream", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.upload(for: request, from: imageData)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
            
        } else {
            
            throw SpotNetworkError.unknownError(function: #function)
        }
        
    }
    
    // 팟 최종 업로드
    private func uploadPotData(object: SpotPotUploadRequestModel) async throws -> PotObject {
        
        print(object)
        
        let url = try SpotAPI.postPot.getApiUrl()
        
        var request = try getURLRequest(url: url, method: .post)
        
        request.httpBody = try JSONEncoder().encode(object)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
            
            let decoded = try jsonDecoder.decode(SpotPotUploadResponseModel.self, from: data)
            
            let objectFromServer = PotObject(
                id: decoded.id,
                userId: decoded.userID,
                categoryId: decoded.categoryID,
                content: decoded.content ?? "",
                imageKey: decoded.imageKey,
                expirationDate: decoded.expiredAt,
                latitude: decoded.location.lat,
                longitude: decoded.location.lon,
                viewCount: 0
            )
            
            print(objectFromServer)
            
            print("팟 업로드 성공")
            
            return objectFromServer
            
        } else {
            
            throw SpotNetworkError.unknownError(function: #function)
        }
    }
    
    // 팟 불러오기
    func getPots(latitude lat: Double, longitude lon: Double, diameter: Double, categoryId: Int64? = nil) async throws -> [PotObject] {
        let searchType = "CIRCLE"
        
        let url = try SpotAPI.getPots.getApiUrl()
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        var queries: [String: String] = [:]
        
        queries["type"] = searchType
        
        // 따로 id가 없는 경우 전체 불러오기
        if let id = categoryId {
            queries["categoryId"] = String(id)
        }
        
        queries["diameterInMeters"] = String(diameter)
        queries["lat"] = String(lat)
        queries["lon"] = String(lon)
        
        components.queryItems = queries.map({ URLQueryItem(name: $0, value: $1) })
        
        let urlWithQuery = components.url!
        
        let request = try getURLRequest(url: urlWithQuery, method: .get)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
            
            let decoded: [PotsResponseModel] = try jsonDecoder.decode([PotsResponseModel].self, from: data)
            
            print("팟 수: \(decoded.count)")
            
            let potObjects = decoded.map { model in
                
                print(model)
                
                return PotObject(
                    id: model.id,
                    userId: model.userId,
                    categoryId: model.categoryId.first!,
                    content: model.content ?? "",
                    imageKey: model.imageKey.isEmpty ? nil : model.imageKey,
                    expirationDate: model.expiredAt,
                    latitude: Double(model.location.lat),
                    longitude: Double(model.location.lon),
                    viewCount: Int(model.viewCount)
                )
            }
            
            return potObjects
        } else {
            
            throw SpotNetworkError.unknownError(function: #function)
        }
    }
    
    // 팟 클릭시 팟데이터 요청(viewCount증가 로직)
    func getPotForPotDetailAbout(potId: Int64) async throws -> PotObject {
        
        var url = try SpotAPI.getPots.getApiUrl()
        url = url.appendingPathComponent(String(potId))
        
        let request = try getURLRequest(url: url, method: .get, isAuth: true)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
            
            let decoded: PotsResponseModel = try jsonDecoder.decode(PotsResponseModel.self, from: data)
            
            return PotObject(
                id: decoded.id,
                userId: decoded.userId,
                categoryId: decoded.categoryId.first!,
                content: decoded.content ?? "",
                imageKey: decoded.imageKey.isEmpty ? nil : decoded.imageKey,
                expirationDate: decoded.expiredAt,
                latitude: Double(decoded.location.lat),
                longitude: Double(decoded.location.lon),
                hashTagList: decoded.hashtagList,
                viewCount: Int(decoded.viewCount)
            )
        }
        
        throw SpotNetworkError.unknownError(function: #function)
    }
    
    // 최근본 팟
    func getRecentlyViewedPot() async throws -> [PotObject] {
        
        let url = try SpotAPI.recentlyViewed.getApiUrl()
        
        let request = try getURLRequest(url: url, method: .get, isAuth: true)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
            
            let decoded: [PotsResponseModel] = try jsonDecoder.decode([PotsResponseModel].self, from: data)
            
            print("최근본 팟수(from 서버) \(decoded.count)")
            
            let potObjects = decoded.map { model in
                
                print(model)
                
                return PotObject(
                    id: model.id,
                    userId: model.userId,
                    categoryId: model.categoryId.first!,
                    content: model.content ?? "",
                    imageKey: model.imageKey.isEmpty ? nil : model.imageKey,
                    expirationDate: model.expiredAt,
                    latitude: Double(model.location.lat),
                    longitude: Double(model.location.lon),
                    viewCount: Int(model.viewCount)
                )
            }
            
            return potObjects
        } else {
            
            throw SpotNetworkError.unknownError(function: #function)
        }
    }
    
    func getMyPot() async throws -> [PotObject] {
        
        let url = try SpotAPI.myPot.getApiUrl()
        
        let request = try getURLRequest(url: url, method: .get, isAuth: true)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
            
            let decoded: [PotsResponseModel] = try jsonDecoder.decode([PotsResponseModel].self, from: data)
            
            let potObjects = decoded.map { model in
                
                return PotObject(
                    id: model.id,
                    userId: model.userId,
                    categoryId: model.categoryId.first!,
                    content: model.content ?? "",
                    imageKey: model.imageKey.isEmpty ? nil : model.imageKey,
                    expirationDate: model.expiredAt,
                    latitude: Double(model.location.lat),
                    longitude: Double(model.location.lon),
                    viewCount: Int(model.viewCount)
                )
            }
            
            return potObjects
        } else {
            
            throw SpotNetworkError.unknownError(function: #function)
        }
    }
}
