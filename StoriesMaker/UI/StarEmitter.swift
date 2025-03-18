//
//  StarEmitter.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 04/09/2023.
//

import UIKit

extension UIView {
    
    func emitStars(
        with config: StarEmitter.Config = .init(),
        duration: TimeInterval = 0.3,
        fadeOutDuration: TimeInterval = 0.6
    ) {
        let starEmitterView = UIView()
        starEmitterView.backgroundColor = .clear
        starEmitterView.frame = self.bounds
        self.addSubview(starEmitterView)
        starEmitterView.addEmitterLayer(with: config)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(
                withDuration: fadeOutDuration,
                animations: {
                    starEmitterView.alpha = 0
                },
                completion: { _ in
                    starEmitterView.removeFromSuperview()
                }
            )
        }
    }
    
    func emitStarfall() {
        let starfallEmitterLayer = CAEmitterLayer()
        starfallEmitterLayer.emitterSize = bounds.size
        starfallEmitterLayer.emitterShape = .rectangle
        starfallEmitterLayer.emitterPosition = CGPoint(
            x: isIpad() ? bounds.width : bounds.width / 2,
            y: bounds.height / 2
        )
        
        let starfallEmitterCell = CAEmitterCell()
        starfallEmitterCell.color = Asset.Colors.e7Ea73.color.cgColor
        starfallEmitterCell.contents = Asset.Images.whiteStar.image.cgImage
        starfallEmitterCell.lifetime = 5.5
        starfallEmitterCell.birthRate = isIpad() ? 100 : 20
        starfallEmitterCell.velocity = 10
        starfallEmitterCell.velocityRange = 900
        starfallEmitterCell.scale = 0.4
        starfallEmitterCell.scaleRange = 1.3
        starfallEmitterCell.emissionRange = .pi / 2
        starfallEmitterCell.emissionLongitude = .pi
        starfallEmitterCell.yAcceleration = -70
        starfallEmitterCell.scaleSpeed = -0.1
        starfallEmitterCell.alphaSpeed = -0.8
        
        starfallEmitterLayer.emitterCells = [starfallEmitterCell]
        self.layer.addSublayer(starfallEmitterLayer)
    }
    
    func addEmitterLayer(with config: StarEmitter.Config) {
        let emitter = StarEmitter(config: config)
        let side = min(self.frame.width, self.frame.height) * 2
        let layer = emitter.emit(
            with: .init(width: side, height: side),
            in: self.center
        )
        self.layer.addSublayer(layer)
    }
}

class StarEmitter {
    
    struct Config {
        
        let lifetime: Float
        let birthRate: Float
        let scaleIn: CGFloat
        let scaleRange: CGFloat
        let scaleSpeed: CGFloat
        let emitterShape: CAEmitterLayerEmitterShape
        
        init(
            lifetime: Float = 0.7,
            birthRate: Float = 9,
            scaleIn: CGFloat = 0.3,
            scaleRange: CGFloat = 0.6,
            scaleSpeed: CGFloat = -0.65,
            emitterShape: CAEmitterLayerEmitterShape = .circle
        ) {
            self.lifetime = lifetime
            self.birthRate = birthRate
            self.scaleIn = scaleIn
            self.scaleRange = scaleRange
            self.scaleSpeed = scaleSpeed
            self.emitterShape = emitterShape
        }
    }
    
    // MARK: - Properties
    static let shared: StarEmitter = StarEmitter(config: Config())
    
    // MARK: - Private Properties
    private lazy var emitterScaleInCell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.color = Asset.Colors.e7Ea73.color.cgColor
        cell.contents = UIImage(named: "white-star")?.cgImage
        cell.lifetime = config.lifetime
        cell.birthRate = config.birthRate
        cell.scale = config.scaleIn
        cell.scaleRange = config.scaleRange
        cell.scaleSpeed = config.scaleSpeed
        return cell
    }()
    
    private let config: Config
    
    // MARK: - Initializators
    init(config: Config) {
        self.config = config
    }
    
    // MARK: - Interface
    func emit(with size: CGSize, in position: CGPoint) -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = config.emitterShape
        emitterLayer.emitterCells = [emitterScaleInCell]
        emitterLayer.emitterSize = size
        emitterLayer.emitterPosition = position
        emitterLayer.emitterMode = .surface
        return emitterLayer
    }
}
