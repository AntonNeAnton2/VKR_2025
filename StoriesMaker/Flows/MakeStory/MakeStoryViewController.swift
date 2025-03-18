//
//  MakeStoryViewController.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 08/09/2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
import Combine

final class MakeStoryViewController: UIViewController {
    
    // MARK: Subviews
    @IBOutlet private weak var makeStoryLabel: UILabel!
    @IBOutlet weak var makeStoryButton: UIButton!
    
    // MARK: Other properties
    private var viewModel: IMakeStoryViewModel?
    private var subscriptions = Set<AnyCancellable>()
    private let onLoad = PassthroughSubject<Void, Never>()
    private let onMakeStory = PassthroughSubject<Void, Never>()

    // MARK: Life cycle
    convenience init() {
        self.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.onLoad.send()
    }
    
    func setDependencies(viewModel: IMakeStoryViewModel?) {
        self.viewModel = viewModel
    }
    
    @IBAction func makeStoryButtonTapped(_ sender: UIButton) {
        self.impactFeedbackGenerator.impactOccurred()
        self.onMakeStory.send()
    }
}

// MARK: - Setup
private extension MakeStoryViewController {
    
    func setup() {
        self.setupUI()
        self.setupSubscriptions()
    }
    
    func setupUI() {
        self.makeStoryLabel.text = L10n.MakeStrory.letsCreate
        self.makeStoryLabel.setLineHeight(lineHeight: 0.56)
    }
    
    func setupSubscriptions() {
        self.subscriptions.forEach { $0.cancel() }
        self.subscriptions.removeAll()
        
        let input = MakeStory.Models.ViewModelInput(
            onLoad: self.onLoad.eraseToAnyPublisher(),
            onMakeStory: self.onMakeStory.eraseToAnyPublisher()
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
    
    func handleState(_ state: MakeStory.Models.ViewState) {
        switch state {
        case .idle:
            break
        }
    }

    func handleAction(_ action: MakeStory.Models.ViewAction) {
        switch action {
        }
    }
    
    func handleRoute(_ route: MakeStory.Models.ViewRoute) {
        switch route {
        case .selectionStepFlow:
            self.startSelectionStepFlow()
        case .subscription:
            self.showSubscription()
        }
    }
}

// MARK: - Navigation
private extension MakeStoryViewController {

    func startSelectionStepFlow() {
        let viewController = SelectionStep.Assembly.createModule(config: .initial)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
    func showSubscription() {
        let controller = Subscription.Assembly.createModule(entryPoint: .makeStory, isDismissable: true)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
}


// MARK: - Private
private extension MakeStoryViewController {

}
