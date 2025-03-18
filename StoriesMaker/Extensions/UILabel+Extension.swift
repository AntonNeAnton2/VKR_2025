//
//  UILabel+Extension.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 08/09/2024.
//

import UIKit

extension UILabel {
    
    func setLineHeight(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment

        let attrString = NSMutableAttributedString()
        if (self.attributedText != nil) {
            attrString.append( self.attributedText!)
        } else if let text = self.text {
            attrString.append( NSMutableAttributedString(string: text))
            attrString.addAttribute(NSAttributedString.Key.font, value: self.font, range: NSMakeRange(0, attrString.length))
        }
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
    
    func setStroke(width: CGFloat, color: UIColor) {
        let attrString = NSMutableAttributedString()
        
        if (self.attributedText != nil) {
            attrString.append( self.attributedText!)
        } else if let text = self.text {
            attrString.append(NSMutableAttributedString(string: text))
            attrString.addAttribute(NSAttributedString.Key.font, value: self.font, range: NSMakeRange(0, attrString.length))
        }

        attrString.addAttributes(
            [
                NSAttributedString.Key.strokeColor: color,
                NSAttributedString.Key.strokeWidth: width
            ],
            range: NSMakeRange(0, attrString.length)
        )
        self.attributedText = attrString
    }
}
