//
//  SubscriptionOptionView.swift
//  StoriesMaker
//
//  Created by borisenko on 19.09.2023.
//

import UIKit
import Glassfy

final class SubscriptionOptionView: UIView {
    
    // MARK: Subviews
    @IBOutlet var contentView: UIView!
    @IBOutlet var subscriptionPeriodLabel: UILabel!
    @IBOutlet var trialPeriodLabel: UILabel!
    @IBOutlet var subscriptionPriceLabel: UILabel!
    @IBOutlet var subscriptionPeriodicityLabel: UILabel!
    @IBOutlet var upperStackView: UIStackView!
    @IBOutlet var lowerStackView: UIStackView!
    @IBOutlet var separatorView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: Public Methods
    func configure(with product: Glassfy.Sku) {
        self.subscriptionPriceLabel.text = product.product.localizedPrice
        self.subscriptionPeriodLabel.text = product.product.subscriptionPeriod?.normalizedPeriodUnit.textualRepresentation
        self.subscriptionPeriodicityLabel.text = product.product.subscriptionPeriod?.normalizedPeriodUnit.adverbTextualRepresentation
        self.upperStackView.isHidden = false
        self.lowerStackView.isHidden = false
        self.separatorView.isHidden = false
        self.activityIndicator.stopAnimating()
    }
}

// MARK: - Private
private extension SubscriptionOptionView {
    
    func configureUI() {
        Bundle.main.loadNibNamed("SubscriptionOptionView", owner: self, options: nil)
        
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]        
        self.contentView.layer.cornerRadius = 17
        
        self.layer.cornerRadius = 17
        self.layer.borderWidth = 2
        self.layer.borderColor = Asset.Colors.e7Ea73.color.cgColor
        self.layer.shadowRadius = 12
        self.layer.shadowColor = Asset.Colors.e7Ea73.color.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        
        // TODO: Will be moved to "configure" func and become configurable
        self.trialPeriodLabel.text = L10n.Subscription.freeTrial
    }
}
