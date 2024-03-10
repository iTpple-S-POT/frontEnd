//
//  PotFetcher.swift
//  MainScreenUI
//
//  Created by 최준영 on 3/6/24.
//

import Foundation
import GlobalObjects

enum PotFetcherError: Error {
    
    case unknownError
    case decodingError
    case networkError
}

protocol PotFetcher {
    
    func requestPotsBasedOn(location: LocationModel, completion: @escaping (Result<[PotViewModel], PotFetcherError>) -> Void)
}
