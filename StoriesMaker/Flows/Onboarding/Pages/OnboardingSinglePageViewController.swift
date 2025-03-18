//
//  OnboardingSinglePageViewController.swift
//  StoriesMaker
//
//  Created by borisenko on 11.09.2024.
//

import UIKit

final class OnboardingSinglePageViewController: UIViewController {
    
    // MARK: Subviews
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontFamily.MrCountryhouseG.regular.font(size: isIpad() ? 62 : 41)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = Asset.Colors._263158.color
        label.layer.shadowRadius = 7
        label.layer.shadowColor = Asset.Colors.f0C577.color.cgColor
        label.layer.shadowOffset = .zero
        label.layer.shadowOpacity = 1
        label.layer.masksToBounds = false
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontFamily.Montserrat.regular.font(size: isIpad() ? 38 : 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    // MARK: Other properties
    private let step: Onboarding.Models.Step
    
    init(step: Onboarding.Models.Step) {
        self.step = step
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.view.emitStarfall()
    }
}

// MARK: - Private
private extension OnboardingSinglePageViewController {
    func setupUI() {
        self.backgroundImageView.image = self.step.backgroundImage
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel)
        
        self.updateUI()
        
        let descriptionLabelBottomConstant = (isIpad() ? -70 : -60) - (isIpad() ? 12 : 8) - (isIpad() ? 13.26 : 8) - 4
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.widthAnchor.constraint(equalToConstant: isIpad() ? 593 : 315),
            titleLabel.heightAnchor.constraint(equalToConstant: isIpad() ? 180 : 160),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            descriptionLabel.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                constant: descriptionLabelBottomConstant
            ),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
//            descriptionLabel.widthAnchor.constraint(equalToConstant: isIpad() ? 793 : 380),
//            descriptionLabel.heightAnchor.constraint(equalToConstant: isIpad() ? 200 : 110),
        ])
    }
    
    func updateUI() {
        self.descriptionLabel.text = step.description
        self.titleLabel.text = step.title
        self.titleLabel.setLineHeight(lineHeight: 0.64)
        self.titleLabel.setStroke(width: -2.0, color: .white)
    }
}
