//
//  String+Extension.swift
//  StoriesMaker
//
//  Created by Максим Рудый on 9.09.23.
//

import Foundation

extension String {
    
    internal var localize: String {
        return NSLocalizedString(self, comment: "")
    }
}
