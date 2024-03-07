//
//  File.swift
//  
//
//  Created by 최준영 on 2/14/24.
//

import Foundation

// for CJMap
public extension NotificationCenter {
    
    static let potSelection = NotificationCenter()
    
    static let potMapCenter = NotificationCenter()
}

public extension Notification.Name {
    
    static let potChange: Self = .init("potChange")
    
    static let potUpload: Self = .init("potUpload")
    
    static let moveMapCenterToSpecificLocation: Self = .init("moveMapCenterToSpecificLocation")
    
    static let specificPotRemovedRequest: Self = .init("specificPotRemovedRequest")
    
    static let whenUserMoveTheMap: Self = .init("whenUserMoveTheMap")
    
    static let potDataFromUploadProccess: Self = .init("potDataFromUploadProccess")
    
}
