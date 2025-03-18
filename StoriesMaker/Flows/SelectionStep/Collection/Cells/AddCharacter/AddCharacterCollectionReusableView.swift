//
//  AddCharacterCollectionReusableView.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 15/09/2023.
//

import UIKit
import SnapKit

class AddCharacterCollectionReusableView: UICollectionReusableView {
    
    // MARK: Subviews
    private lazy var button: UIButton = {
        let button = UIButton(type: .system).withoutAutoresizing()
        button.backgroundColor = Asset.Colors.e7Ea73.color
        button.setTitle(L10n.AddCharacter.addYourselfAsCharacter, for: .normal)
        button.titleLabel?.font = FontFamily.Montserrat.bold.font(size: 16)
        button.setTitleColor(Asset.Colors._262845.color, for: .normal)
        button.setImage(Asset.Images.plusButton.image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.titleEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 0)
        button.addAction(
            .init(
                handler: { [weak self] _ in
                    self?.onAddCharacter?()
                }
            ),
            for: .touchUpInside
        )
        return button
    }()
    
    var onAddCharacter: (() -> Void)?
    
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
}

// MARK: - Private
private extension AddCharacterCollectionReusableView {
    
    func commonInit() {
        self.backgroundColor = .clear
        self.button.layer.cornerRadius = 25
        self.addSubview(self.button)
        self.button.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }
}
