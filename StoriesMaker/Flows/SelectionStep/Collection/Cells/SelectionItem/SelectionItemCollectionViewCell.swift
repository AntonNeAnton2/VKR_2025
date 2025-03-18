//
//  SelectionItemCollectionViewCell.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 13/09/2023.
//

import UIKit
import Combine

class SelectionItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var selectionView: UIView!
    @IBOutlet private weak var frameView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var label: UILabel!
    
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
    
    static var nibName: String {
        String(describing: Self.self)
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    static var imageWidth: CGFloat {
        (UIScreen.main.bounds.width - 45) / 2
    }
    
    var dataModel: SelectionStepCellDataModel? {
        didSet {
            self.configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.clipsToBounds = false
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
        self.selectionView.layer.cornerRadius = Self.imageWidth / 2
        self.frameView.layer.cornerRadius = Self.imageWidth * 0.8 / 2
    }
}

// MARK: - Private
private extension SelectionItemCollectionViewCell {
    
    func configure() {
        self.subscriptions.forEach { $0.cancel() }
        self.subscriptions.removeAll()
        
        guard let dataModel = self.dataModel else { return }
        
        dataModel.isSelectedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSelected in
                self?.setSelection(isSelected)
            }
            .store(in: &self.subscriptions)
        
        self.frameView.isHidden = !dataModel.dataSource.shouldShowFrame
        self.imageView.transform = CGAffineTransform(scaleX: dataModel.dataSource.imageScaleMultiplier, y: dataModel.dataSource.imageScaleMultiplier)
        
        self.imageView.image = dataModel.dataSource.selectionStepCellImage
        if let text = dataModel.dataSource.selectionStepCellText {
            self.label.isHidden = false
            self.label.text = text
        } else {
            self.label.isHidden = true
        }
        
        self.layoutIfNeeded()
    }
    
    func setSelection(_ isSelected: Bool) {
        if isSelected {
            self.imageView.emitStars(with: .init(lifetime: 0.6, birthRate: 21), duration: 0.4, fadeOutDuration: 0.8)
            self.selectionView.transform = .init(scaleX: 0.4, y: 0.4)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                self.selectionView.backgroundColor = .white.withAlphaComponent(0.3)
                self.selectionView.transform = .identity
            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: .curveEaseIn) {
                self.selectionView.backgroundColor = .clear
                self.selectionView.transform = .init(scaleX: 0.4, y: 0.4)
            } completion: { _ in
                self.selectionView.transform = .identity
            }
        }
    }
}
