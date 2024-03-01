//
//  File.swift
//  
//
//  Created by 최준영 on 2/26/24.
//

import SwiftUI

public extension APIRequestGlobalObject {
    
    func sendReaction(potId: Int64, reactionString: String) async throws -> ReactionDTO {
        
        let url = try SpotAPI.reaction.getApiUrl()
        
        var request = try getURLRequest(url: url, method: .post, isAuth: true)
            
        let jsonObject: [String: Any] = [
            "potId" : potId,
            "reactionType" : reactionString
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: jsonObject)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            
            let decoded = try jsonDecoder.decode(ReactionDTO.self, from: data)
            
            return decoded
            
        } catch {
            
            guard let reactionError = try? jsonDecoder.decode(SpotErrorMessageModel.self, from: data) else {
                
                throw SpotNetworkError.unknownError(function: #function)
            }
            
            switch reactionError.code {
            case 1801:
                throw SpotNetworkError.duplicatedReaction
            default:
                throw SpotNetworkError.unknownError(function: #function)
            }
        }
    }
}
