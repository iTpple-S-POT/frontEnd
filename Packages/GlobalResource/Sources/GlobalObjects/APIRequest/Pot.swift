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
    
    // 팟 업로드
    func executePotUpload(imageInfo: ImageInformation, uploadObject: SpotPotUploadObject) async throws -> PotObject {
        
        let s3Object = try await getPreSignedUrl(imageInfo: imageInfo)
        
        guard let preUrl = URL(string: s3Object.preSignedUrl) else {
            throw SpotNetworkError.notFoundError(description: "pre-signed-url 생성 에러")
        }
        
        try await uploadImageToS3(url: preUrl, imageData: imageInfo.data)
        
        print("S3 업로드 성공")
        
        print(s3Object.fileKey)
        
        let uploadedObject = try await uploadPotData(fileKey: s3Object.fileKey, uploadObject: uploadObject)
        
        print("팟 업로드 성공")
        
        return uploadedObject
    }
    
    
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
    
    // 팟업로드
    private func uploadPotData(fileKey: String, uploadObject: SpotPotUploadObject) async throws -> PotObject {
        
        let object = SpotPotUploadRequestModel(
            categoryId: uploadObject.category,
            imageKey: fileKey,
            type: "IMAGE",
            location: Location(lat: uploadObject.latitude, lon: uploadObject.longitude),
            content: uploadObject.text
        )
        
        let url = try SpotAPI.postPot.getApiUrl()
        
        var request = try getURLRequest(url: url, method: .post)
        
        request.httpBody = try JSONEncoder().encode(object)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
            
            let decoded = try jsonDecoder.decode(SpotPotUploadResponseModel.self, from: data)
            
            let object = PotObject(
                id: decoded.id,
                userId: decoded.userID,
                categoryId: decoded.categoryID,
                content: decoded.content ?? "",
                imageKey: decoded.imageKey,
                expirationDate: decoded.expiredAt,
                latitude: decoded.location.lat,
                longitude: decoded.location.lon
            )
            
            print("팟 업로드 성공")
            
            return object
            
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
        
        print("팟 fetch url: \(urlWithQuery)")
        
        let request = try getURLRequest(url: urlWithQuery, method: .get)
        
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
                    longitude: Double(model.location.lon)
                )
            }
            
            return potObjects
        } else {
            
            throw SpotNetworkError.unknownError(function: #function)
        }
    }
}
