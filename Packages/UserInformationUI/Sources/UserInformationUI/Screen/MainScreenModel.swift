//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/22.
//

import Foundation

class MainScreenModel: ObservableObject {
    
    @Published private(set) var inputScreenOrder: Int = 1
    @Published private(set) var inputScreenCount: Int = 5
    
    func nextScreen() {
        if inputScreenOrder < inputScreenCount {
            inputScreenOrder += 1
        }
    }
}
