//
//  UITableViewCell+Reuse.swift
//  StoriesMaker
//
//  Created by Максим Рудый on 15.09.23.
//

import UIKit

extension UITableViewCell {
    
    static var reuseIdentifier: String {
        String(describing: self)
    }

    var reuseIdentifier: String {
        type(of: self).reuseIdentifier
    }
}
