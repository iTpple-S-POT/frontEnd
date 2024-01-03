//
//  GlobalResourceTests.swift
//  
//
//  Created by 최준영 on 2024/01/04.
//

import XCTest
import GlobalObjects

final class GlobalResourceTests: XCTestCase {


    func test_makeUrlFromApi() throws {
        
        for api in APIRequestGlobalObject.SpotAPI.allCases {
            
            let _ = try api.getApiUrl()
            
        }
        
    }

}
