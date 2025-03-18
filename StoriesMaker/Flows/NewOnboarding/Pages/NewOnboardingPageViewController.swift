//
//  NewOnboardingPageViewController.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 6.12.24.
//

import UIKit
import Combine
import SnapKit

final class NewOnboardingPageViewController: UIPageViewController {
    
    // MARK: Subviews
    private lazy var backgroundBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.Colors._738Dea.color
        view.addSubview(self.bottomView)
        self.bottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(5)
        }
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.Colors._313F6E.color
        view.addSubview(self.stack)
        self.stack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.horizontalEdges.equalToSuperview().inset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 16
        stack.addArrangedSubview(self.titleLabel)
        stack.addArrangedSubview(self.descriptionLabel)
        stack.addArrangedSubview(self.stepImageView)
        stack.addArrangedSubview(self.actionButton)
        self.actionButton.snp.makeConstraints { make in
            make.width.equalTo(stack.snp.width)
        }
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.Gilroy.bold.font(size: 34)
        label.textAlignment = .center
        label.textColor = .white
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.Gilroy.medium.font(size: 16)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let stepImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.width.equalTo(42)
            make.height.equalTo(6)
        }
        
        return imageView
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontFamily.Gilroy.bold.font(size: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(
            self,
            action: #selector(self.actionButtonTapped),
            for: .touchUpInside
        )
        button.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        button.backgroundColor = Asset.Colors._738Dea.color
        button.layer.cornerRadius = 12
        return button
    }()
    
    // MARK: Other properties
    var currentPageIndexPublisher: AnyPublisher<Int, Never> {
        self.currentPageIndexSubject.eraseToAnyPublisher()
    }
    
    private let currentPageIndexSubject = CurrentValueSubject<Int, Never>(0)
    private lazy var pages: [UIViewController] = self.steps.map { NewOnboardingSinglePageViewController(step: $0)
    }
    
    private let steps: [NewOnboarding.Models.Step]
    
    init(steps: [NewOnboarding.Models.Step]) {
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
}

// MARK: - Private
private extension NewOnboardingPageViewController {
    
    func setupUI() {
        self.view.addSubview(self.backgroundBottomView)
        self.backgroundBottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.updateUI()
    }
    
    func updateUI() {
        let currentPageIndex = self.currentPageIndexSubject.value
        let currentStep = self.steps[currentPageIndex]
        
        self.titleLabel.text = currentStep.title
        self.descriptionLabel.text = currentStep.description
        self.actionButton.setTitle(
            currentStep.buttonTitle,
            for: .normal
        )
        self.stepImageView.image = currentStep.stepImage
    }
    
    @objc
    func actionButtonTapped() {
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


// MARK: - UIPageViewControllerDelegate
extension NewOnboardingPageViewController: UIPageViewControllerDelegate {
    
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
extension NewOnboardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = self.pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        guard previousIndex >= 0,
              self.pages.count > previousIndex else { return nil }
        return self.pages[previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = self.pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        guard nextIndex < self.pages.count,
              self.pages.count > nextIndex else { return nil }
        return self.pages[nextIndex]
    }
}
