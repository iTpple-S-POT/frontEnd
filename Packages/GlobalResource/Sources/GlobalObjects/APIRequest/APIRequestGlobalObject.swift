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
    
}



