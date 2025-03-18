//
//  UIView+Blur.swift
//  PlantsApp
//
//  Created by Anton Mitrafanau on 22/08/2023.
//

import UIKit
import SnapKit

extension UIView {
    
    private static let blurViewIdentifier = "blurViewIdentifier"
    
    var isBlurred: Bool {
        self.subviews.contains(where: { $0.accessibilityIdentifier == Self.blurViewIdentifier })
    }
    
    func addBlur(nonAlphaBackgroundColor: UIColor? = nil, radius: Float = 3) {
        self.clipsToBounds = true
        
        let image = self.asImage(nonAlphaBackgroundColor: nonAlphaBackgroundColor ?? self.backgroundColor)
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = image.applyGaussianBlur(radius: radius)
        view.contentMode = .scaleAspectFit
        view.accessibilityIdentifier = Self.blurViewIdentifier
                
        self.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func removeBlur() {
        guard let view = self.subviews.first(where: { $0.accessibilityIdentifier == Self.blurViewIdentifier }) else { return }
        view.removeFromSuperview()
    }
    
    private func asImage(nonAlphaBackgroundColor: UIColor?) -> UIImage {
        let savedColor = backgroundColor
        let savedCornerRadius = layer.cornerRadius
        layer.cornerRadius = 0
        backgroundColor = nonAlphaBackgroundColor
        
        defer {
            backgroundColor = savedColor
            layer.cornerRadius = savedCornerRadius
        }
        
        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: format)
        return renderer.image { _ in self.drawHierarchy(in: bounds, afterScreenUpdates: true) }
    }
}
