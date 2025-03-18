//
//  OnboardingViewController.swift
//  StoriesMaker
//
//  Created by borisenko on 11.09.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
import Combine

final class OnboardingViewController: UIViewController {
    
    // MARK: Subviews
    private lazy var pageViewController: OnboardingPageViewController = {
        let controller = OnboardingPageViewController(steps: self.viewModel?.steps ?? [])
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()

    // MARK: Other properties
    private var viewModel: IOnboardingViewModel?
    private var subscriptions = Set<AnyCancellable>()
    private let onLoad = PassthroughSubject<Void, Never>()
    private let onUpdateCurrentIndex = PassthroughSubject<Int, Never>()

    // MARK: Life cycle
    convenience init() {
        self.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.onLoad.send()
    }
    
    func setDependencies(viewModel: IOnboardingViewModel?) {
        self.viewModel = viewModel
    }
}

// MARK: - Setup
private extension OnboardingViewController {
    
    func setup() {
        self.setupUI()
        self.setupSubscriptions()
    }
    
    func setupUI() {
        self.view.backgroundColor = Asset.Colors._262845.color
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            self.pageViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.pageViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.pageViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.pageViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func setupSubscriptions() {
        self.subscriptions.forEach { $0.cancel() }
        self.subscriptions.removeAll()
        
        let input = Onboarding.Models.ViewModelInput(
            onLoad: self.onLoad.eraseToAnyPublisher(),
            onUpdateCurrentIndex: self.onUpdateCurrentIndex.eraseToAnyPublisher()
        )
        self.viewModel?.process(input: input)
        
        self.viewModel?.viewStatePublisher
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &self.subscriptions)

        self.viewModel?.viewRoutePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] route in
                self?.handleRoute(route)
            }
            .store(in: &self.subscriptions)

        self.viewModel?.viewActionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                self?.handleAction(action)
            }
            .store(in: &self.subscriptions)
        
        self.pageViewController.currentPageIndexPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                self?.handleIndexChange(index)
            }
            .store(in: &subscriptions)
    }
    
    func handleState(_ state: Onboarding.Models.ViewState) {
        switch state {
        case .idle:
            break
        }
    }

    func handleAction(_ action: Onboarding.Models.ViewAction) {
        switch action {
        }
    }
    
    func handleRoute(_ route: Onboarding.Models.ViewRoute) {
    }
    
    func handleIndexChange(_ index: Int) {
        self.onUpdateCurrentIndex.send(index)
    }
}

// MARK: - Private
private extension OnboardingViewController {

}
