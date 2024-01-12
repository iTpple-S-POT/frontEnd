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
    
    public var potCategories: [CategoryObject]!
    
    public static var shared: APIRequestGlobalObject = .init()
    
    private init() { }
    
    let jsonEncoder = JSONEncoder()
    let jsonDecoder = JSONDecoder()
    
    // tokens
    let kAccessTokenKey = "spotAccessToken"
    let kRefreshTokenKey = "spotRefreshToken"
    
    // pot
    let kPotCategory = "spotPotCategory"
    
}

// MARK: - Request
public extension APIRequestGlobalObject {
    
    internal func getURLRequest(url: URL, method: HTTPMethod, isAuth: Bool = true) throws -> URLRequest {
        
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



