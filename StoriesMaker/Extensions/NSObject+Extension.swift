//
//  NSObject+Extension.swift
//  StoriesMaker
//
//  Created by Максим Рудый on 9.09.23.
//

import UIKit

extension NSObject {
    
    internal var impactFeedbackGenerator: UIImpactFeedbackGenerator {
        return UIImpactFeedbackGenerator.init(style: .light)
    }
}
