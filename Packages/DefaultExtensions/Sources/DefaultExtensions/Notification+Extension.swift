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
}

public extension Notification.Name {
    
    static let potChange: Self = .init("potChange")
}
