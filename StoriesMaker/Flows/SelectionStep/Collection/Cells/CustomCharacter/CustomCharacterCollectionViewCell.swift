//
//  CustomCharacterCollectionViewCell.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 18/09/2024.
//

import UIKit

class CustomCharacterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var frameView: UIView!
    @IBOutlet private weak var label: UILabel!
    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(
            Asset.Images.removeButtonCircle.image.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
        button.addAction(
            .init(
                handler: { [weak self] _ in
                    guard let customCharacter = self?.customCharacter else { return }
                    self?.onRemoveCustomCharacter?(customCharacter)
                }
            ),
            for: .touchUpInside
        )
        return button
    }()
    
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
    
    static var nibName: String {
        String(describing: Self.self)
    }
    
    static var cellWidth: CGFloat {
        (UIScreen.main.bounds.width - 45) / 2
    }
    
    var customCharacter: CustomCharacter? {
        didSet {
            self.configure()
        }
    }
    
    var onRemoveCustomCharacter: ((CustomCharacter) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.frameView.layer.borderWidth = 1
        self.frameView.layer.borderColor = Asset.Colors.fdffc2.color.cgColor
        self.frameView.layer.shadowRadius = 9
        self.frameView.layer.shadowOpacity = 1
        self.frameView.layer.shadowColor = Asset.Colors.fdffc2.color.cgColor
        self.frameView.layer.shadowOffset = .zero
        self.frameView.alpha = 0.4
        
        self.contentView.addSubview(self.removeButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frameView.layer.cornerRadius = Self.cellWidth * 0.8 / 2
        self.refreshRemoveButton()
    }
}

// MARK: - Private
private extension CustomCharacterCollectionViewCell {
    
    func configure() {
        guard let customCharacter = self.customCharacter else { return }
        self.label.text = customCharacter.name
    }
    
    func refreshRemoveButton() {
        let cat = Self.cellWidth * 0.8 / 2
        let hypo = sqrt(2 * pow(cat, 2))
        let diffHypo = hypo - cat
        let diff = cat * diffHypo / hypo
        self.removeButton.frame = .init(
            x: Self.cellWidth * 0.1 + 2 * cat - diff - 22,
            y: Self.cellWidth * 0.1 + diff - 22,
            width: 44,
            height: 44
        )
    }
}
