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
        
        throw SpotNetworkError.unownedError(function: #function)
    }
    
    // 팟 업로드
    func executePotUpload(imageInfo: ImageInformation, uploadObject: SpotPotUploadObject) async throws {
        
        let s3Object = try await getPreSignedUrl(imageInfo: imageInfo)
        
        guard let preUrl = URL(string: s3Object.preSignedUrl) else {
            throw SpotNetworkError.notFoundError(description: "pre-signed-url 생성 에러")
        }
        
        try await uploadImageToS3(url: preUrl, imageData: imageInfo.data)
        try await uploadPotData(fileKey: s3Object.fileKey, uploadObject: uploadObject)
        
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
                
                throw SpotNetworkError.unownedError(function: #function)
            }
            
        }
    
    
    private func uploadImageToS3(url: URL, imageData: Data) async throws {
        
        var request = try getURLRequest(url: url, method: .put, isAuth: false)
        request.setValue("binary/octet-stream", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.upload(for: request, from: imageData)
        
        if let httpResponse = response as? HTTPURLResponse {
            
            try defaultCheckStatusCode(response: httpResponse, functionName: #function, data: data)
            
            print("S3 업로드 성공")
            
        } else {
            
            throw SpotNetworkError.unownedError(function: #function)
        }
        
    }
    
    // 팟업로드
    private func uploadPotData(fileKey: String, uploadObject: SpotPotUploadObject) async throws {
        
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
            
            print("팟 업로드 성공")
            
        } else {
            
            throw SpotNetworkError.unownedError(function: #function)
        }
    }
}
