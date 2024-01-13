//
//  FilGlobalStateObjecte.swift
//
//
//  Created by 최준영 on 2024/01/12.
//

import SwiftUI

public class GlobalStateObject: ObservableObject {
    
    var categories: [CategoryObject]!
    
    public init() { }
    
    public func setCategories(categories: [CategoryObject]) {
        
        self.categories = categories
    }
    
}
