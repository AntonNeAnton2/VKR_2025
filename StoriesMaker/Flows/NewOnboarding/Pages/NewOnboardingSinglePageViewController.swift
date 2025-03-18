//
//  NewOnboardingSinglePageViewController.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 6.12.24.
//

import UIKit

class NewOnboardingSinglePageViewController: UIViewController {
    
    // MARK: Subviews
    @IBOutlet weak var backgroundImageView: UIImageView!

    // MARK: Other properties
    private let step: NewOnboarding.Models.Step
    
    init(step: NewOnboarding.Models.Step) {
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
private extension NewOnboardingSinglePageViewController {
    
    func setupUI() {
        self.backgroundImageView.image = self.step.backgroundImage
    }
}
