//
//  LocationFetcher.swift
//  MainScreenUI
//
//  Created by 최준영 on 3/6/24.
//

import Foundation
import Combine
import MapKit

enum LocationFetcherError: Error {
    
    case unAuthorized
    case locationDataNotExist
    case unknownError
    case needsAuthInSetting
}

protocol LocationFetcher {
    
    var locationPublisher: PassthroughSubject<LocationViewModel, Never> { get }
    
    var isAuthorizationValid: Bool { get }
    
    func reqeustCurrentUserLocation() throws
}
