//
//  UIView+Extension.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 04/09/2024.
//

import UIKit

extension UIView {
    
    func withoutAutoresizing() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func showTapAnimation(completion: (() -> Void)? = nil) {
        isUserInteractionEnabled = false
        
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveLinear,
            animations: { [weak self] in
                self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
            }
        ) { (_) in
            UIView.animate(
                withDuration: 0.1,
                delay: 0,
                options: .curveLinear,
                animations: { [weak self] in
                    self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                }
            ) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completion?()
            }
        }
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
