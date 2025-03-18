//
//  OnboardingPageViewController.swift
//  StoriesMaker
//
//  Created by borisenko on 13.09.2024.
//

import UIKit
import Combine

final class OnboardingPageViewController: UIPageViewController {

    // MARK: Subviews
    private lazy var stepImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(self.didTapNextButton(_:)),
            for: .primaryActionTriggered
        )
        button.backgroundColor = Asset.Colors._262845.color
        button.setTitleColor(Asset.Colors.f0C577.color, for: .normal)
        button.layer.cornerRadius = 26
        button.titleLabel?.font = FontFamily.Montserrat.bold.font(size: isIpad() ? 24 : 16)
        button.layer.borderWidth = 2
        button.layer.borderColor = Asset.Colors.f0C577.color.cgColor
        
        button.layer.shadowRadius = 13
        button.layer.shadowColor = Asset.Colors.f0C577.color.cgColor
        button.layer.shadowOffset = .zero
        button.layer.shadowOpacity = 1
        button.layer.masksToBounds = false
        
        return button
    }()
    
    // MARK: Other properties
    var currentPageIndexPublisher: AnyPublisher<Int, Never> {
        self.currentPageIndexSubject.eraseToAnyPublisher()
    }
    
    private let currentPageIndexSubject = CurrentValueSubject<Int, Never>(0)
    private lazy var pages: [UIViewController] = self.steps.map { OnboardingSinglePageViewController(step: $0) }
    
    private let steps: [Onboarding.Models.Step]
    
    init(steps: [Onboarding.Models.Step]) {
        self.steps = steps
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setViewControllers(
            [self.pages[self.currentPageIndexSubject.value]],
            direction: .forward,
            animated: false
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Actions
    @objc func didTapNextButton(_ sender: Any) {
        self.impactFeedbackGenerator.impactOccurred()
        let currentIndex = self.currentPageIndexSubject.value
        let nextIndex = currentIndex + 1
        self.currentPageIndexSubject.send(nextIndex)
        
        guard nextIndex < self.pages.count else { return }
        
        let page = self.pages[nextIndex]
        self.setViewControllers(
            [page],
            direction: .forward,
            animated: true
        )
        self.updateUI()
    }
}

// MARK: - Private
private extension OnboardingPageViewController {
    func setupUI() {
        self.view.addSubview(nextButton)
        self.view.addSubview(stepImageView)
        
        self.updateUI()
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: isIpad() ? 60 : 50),
            nextButton.widthAnchor.constraint(equalToConstant: isIpad() ? 394 : 278),
            
            stepImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stepImageView.widthAnchor.constraint(equalToConstant: isIpad() ? 63 : 38),
            stepImageView.heightAnchor.constraint(equalToConstant: isIpad() ? 13.26 : 8),
            stepImageView.bottomAnchor.constraint(equalTo: self.nextButton.topAnchor, constant: isIpad() ? -12 : -8),
        ])
    }
    
    func updateUI() {
        let currentPageIndex = self.currentPageIndexSubject.value
        let currentStep = self.steps[currentPageIndex]
        
        currentPageIndex == self.pages.count - 1 ? self.nextButton.pulsate() : self.nextButton.layer.removeAllAnimations()
        
        self.nextButton.setTitle(
            currentStep.buttonTitle,
            for: .normal
        )
        self.stepImageView.image = currentStep.stepImage
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed,
              let currentPage = pageViewController.viewControllers?.first,
              let index = self.pages.firstIndex(of: currentPage) else { return }
        self.currentPageIndexSubject.send(index)
        self.updateUI()
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        guard previousIndex >= 0,
              self.pages.count > previousIndex else { return nil }
        return self.pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        guard nextIndex < self.pages.count,
              self.pages.count > nextIndex else { return nil }
        return self.pages[nextIndex]
    }
}
