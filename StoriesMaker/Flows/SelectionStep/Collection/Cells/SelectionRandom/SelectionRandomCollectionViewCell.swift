//
//  SelectionRandomCollectionViewCell.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 15/09/2024.
//

import UIKit

class SelectionRandomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var frameView: UIView!
    @IBOutlet private weak var label: UILabel!
    
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
    
    static var nibName: String {
        String(describing: Self.self)
    }
    
    static var cellWidth: CGFloat {
        (UIScreen.main.bounds.width - 45) / 2
    }
    
    var step: SelectionStep.Models.Step? {
        didSet {
            self.configure()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.frameView.layer.borderWidth = 1
        self.frameView.layer.borderColor = Asset.Colors.fdffc2.color.cgColor
        self.frameView.layer.shadowRadius = 9
        self.frameView.layer.shadowOpacity = 1
        self.frameView.layer.shadowColor = Asset.Colors.fdffc2.color.cgColor
        self.frameView.layer.shadowOffset = .zero
        self.frameView.alpha = 0.4
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frameView.layer.cornerRadius = Self.cellWidth * 0.8 / 2
    }
}

// MARK: - Private
private extension SelectionRandomCollectionViewCell {
    
    func configure() {
        guard let step = self.step else { return }
        self.label.text = step.selectRandomText
    }
}
