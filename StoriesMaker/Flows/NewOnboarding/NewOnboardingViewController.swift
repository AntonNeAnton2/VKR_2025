//
//  NewOnboardingViewController.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 6.12.24.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
import Combine

final class NewOnboardingViewController: UIViewController {
    
    // MARK: Subviews
    private lazy var pageViewController: NewOnboardingPageViewController = {
        let controller = NewOnboardingPageViewController(steps: self.viewModel?.steps ?? [])
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()

    // MARK: Other properties
    private var viewModel: INewOnboardingViewModel?
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
    
    func setDependencies(viewModel: INewOnboardingViewModel?) {
        self.viewModel = viewModel
    }
}

// MARK: - Setup
private extension NewOnboardingViewController {
    
    func setup() {
        self.setupUI()
        self.setupSubscriptions()
    }
    
    func setupUI() {
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
        
        let input = NewOnboarding.Models.ViewModelInput(
            onLoad: self.onLoad.eraseToAnyPublisher()
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
    }
    
    func handleState(_ state: NewOnboarding.Models.ViewState) {
        switch state {
        case .idle:
            break
        }
    }

    func handleAction(_ action: NewOnboarding.Models.ViewAction) {
        switch action {
        }
    }
    
    func handleRoute(_ route: NewOnboarding.Models.ViewRoute) {
        switch route {
        }
    }
}

// MARK: - Private
private extension NewOnboardingViewController {

}
