//
//  StoryCreationViewController.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 19/09/2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
import Combine

final class StoryCreationViewController: UIViewController {
    
    // MARK: Subviews
    @IBOutlet private weak var creatingTheStoryLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var progressContainer: UIView!
    @IBOutlet private weak var progressValueView: UIView!
    @IBOutlet private weak var progressValueViewWidth: NSLayoutConstraint!
    
    // MARK: Other properties
    private var viewModel: IStoryCreationViewModel?
    private var subscriptions = Set<AnyCancellable>()
    private let onLoad = PassthroughSubject<Void, Never>()
    private let onBackButtonTap = PassthroughSubject<Void, Never>()
    private let onErrorDismiss = PassthroughSubject<Void, Never>()

    // MARK: Life cycle
    convenience init() {
        self.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.onLoad.send()
    }
    
    func setDependencies(viewModel: IStoryCreationViewModel?) {
        self.viewModel = viewModel
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.impactFeedbackGenerator.impactOccurred()
        self.onBackButtonTap.send()
    }
}

// MARK: - Setup
private extension StoryCreationViewController {
    
    func setup() {
        self.setupUI()
        self.setupSubscriptions()
    }
    
    func setupUI() {
        self.creatingTheStoryLabel.text = L10n.StoryCreation.creatingTheStory
        self.creatingTheStoryLabel.setLineHeight(lineHeight: 0.73)
        
        self.infoLabel.text = L10n.StoryCreation.thisWillTakeLittleTime
        
        self.progressContainer.layer.cornerRadius = 7.5
        self.progressContainer.layer.borderWidth = 1
        self.progressContainer.layer.borderColor = Asset.Colors._738Dea.color.cgColor
        
        self.progressValueView.layer.cornerRadius = 7.5
        self.progressValueView.layer.borderWidth = 1
        self.progressValueView.layer.borderColor = Asset.Colors._738Dea.color.cgColor
    }
    
    func setupSubscriptions() {
        self.subscriptions.forEach { $0.cancel() }
        self.subscriptions.removeAll()
        
        let input = StoryCreation.Models.ViewModelInput(
            onLoad: self.onLoad.eraseToAnyPublisher(),
            onBackButtonTap: self.onBackButtonTap.eraseToAnyPublisher(),
            onErrorDismiss: self.onErrorDismiss.eraseToAnyPublisher()
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
    
    func handleState(_ state: StoryCreation.Models.ViewState) {
        switch state {
        case .idle:
            break
        }
    }

    func handleAction(_ action: StoryCreation.Models.ViewAction) {
        switch action {
        case .showError(let error):
            self.showCustomError(
                error,
                onOk: { [weak self] in
                    self?.onErrorDismiss.send()
                }
            )
        case .setProgress(let progress):
            self.setProgress(progress)
        case .setFact(let fact):
            self.setFact(fact)
        }
    }
    
    func handleRoute(_ route: StoryCreation.Models.ViewRoute) {
        switch route {
        case .pop:
            self.pop()
        case .story(let story):
            self.goToStory(story)
        }
    }
}

// MARK: - Private
private extension StoryCreationViewController {

    func setProgress(_ progress: Double) {
        var width = self.progressContainer.frame.width * progress
        width = min(width, self.progressContainer.frame.width)
        self.progressValueViewWidth.constant = width
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setFact(_ fact: String) {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.infoLabel.alpha = 0
            },
            completion: { _ in
                self.infoLabel.text = fact
                UIView.animate(withDuration: 0.3) {
                    self.infoLabel.alpha = 1
                }
            }
        )
    }
}

// MARK: - Navigation
private extension StoryCreationViewController {
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }

    func goToStory(_ story: MyStory) {
        let controller = Story.Assembly.createModule(
            config: .init(
                entryPoint: .storyCreation,
                story: story,
                saveButtonState: .inactive,
                backButtonState: .dismiss, 
                universe: story.universe
            )
        )
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
