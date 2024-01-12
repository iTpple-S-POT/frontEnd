//
//  File.swift
//  
//
//  Created by 최준영 on 2024/01/12.
//

import Foundation

public enum PotUploadPrepareError: Error {
    
    case cantGetUserLocation(function: String)
    case imageInfoDoesntExist(function: String)
    
}
