//
//  View+Extensions.swift
//
//
//  Created by 최준영 on 2/26/24.
//

import SwiftUI

public extension View {
    
    func commonShadow() -> some View {
        
        return self.shadow(color: .black.opacity(0.3), radius: 4)
    }
}
