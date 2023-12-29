//
//  File.swift
//  
//
//  Created by 최준영 on 2023/11/18.
//

import Foundation

public extension String {
    /// Returns the localized string from localizable file. Always use Bundle.module.
    ///  - returns: Localized String in Localizable file
    func localized() -> String {
        NSLocalizedString(self, bundle: .module, comment: "")
    }
}
