//
//  PotFetcher.swift
//  MainScreenUI
//
//  Created by 최준영 on 3/6/24.
//

import Foundation
import GlobalObjects
import Alamofire

extension APIRequestGlobalObject: PotFetcher {
    
    func requestPotsBasedOn(location: LocationModel, completion: @escaping (Result<[PotViewModel], PotFetcherError>) -> Void) {
        
        do {
            
            let url = try SpotAPI.getPots.getApiUrl()
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            
            var queries: [String: String] = [:]
            
            queries["type"] = "CIRCLE"
            queries["diameterInMeters"] = "\(1000)"
            queries["lat"] = "\(location.latitude)"
            queries["lon"] = "\(location.longitude)"
            
            components.queryItems = queries.map({ URLQueryItem(name: $0, value: $1) })
            
            let urlWithQuery = components.url!
            
            let request = try getURLRequest(url: urlWithQuery, method: .get)
            
            AF
                .request(request)
                .validate(statusCode: 200..<300)
                .response { response in
                    
                    switch response.result {
                    case .success(let success):
                        
                        guard let data = success, let decoded = try? JSONDecoder().decode([PotsResponseModel].self, from: data) else {
                            
                            if let data = success {
                                
                                print(String(data: data, encoding: .utf8)!)
                            }
                            
                            return completion(.failure(.decodingError))
                        }
                        
                        let viewModels = decoded.map { element in
                            
                            let model = PotModel(
                                id: element.id,
                                userId: element.userId,
                                categoryId: element.categoryId.first ?? 0,
                                content: element.content ?? "",
                                imageKey: element.imageKey,
                                expirationDate: element.expiredAt,
                                latitude: element.location.lat,
                                longitude: element.location.lon,
                                hashTagList: element.hashtagList,
                                viewCount: Int(element.viewCount),
                                reactionTypeCounts: element.reactionTypeCounts ?? []
                            )
                            
                            return PotViewModel(model: model)
                        }
                        
                        completion(.success(viewModels))
                        
                    case .failure(let failure):
                        
                        print(failure)
                        
                        completion(.failure(.networkError))
                    }
                    
                }
        } catch {
            
            
        }
    }
}
