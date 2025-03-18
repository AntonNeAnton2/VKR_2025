//
//  StoryViewController.swift
//  StoriesMaker
//
//  Created by Максим Рудый on 20.09.23.
//  Copyright © 2023 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
import Combine

final class StoryViewController: UIViewController {
    
    // MARK: Subviews
    @IBOutlet private weak var storyTitleLabel: UILabel!
    @IBOutlet private weak var storyContentLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!

    // MARK: Other properties
    private var viewModel: IStoryViewModel?
    private var subscriptions = Set<AnyCancellable>()
    private let onLoad = PassthroughSubject<Void, Never>()
    private let onBackButtonTap = PassthroughSubject<Void, Never>()
    private let onSaveButtonTap = PassthroughSubject<Void, Never>()

    // MARK: Life cycle
    convenience init() {
        self.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.onLoad.send()
    }
    
    func setDependencies(viewModel: IStoryViewModel?) {
        self.viewModel = viewModel
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.impactFeedbackGenerator.impactOccurred()
        self.onBackButtonTap.send()
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        self.impactFeedbackGenerator.impactOccurred()
        self.onSaveButtonTap.send()
    }
}

// MARK: - Setup
private extension StoryViewController {
    
    func setup() {
        self.setupUI()
        self.setupSubscriptions()
    }

    func setup(with config: Story.Models.Configuration) {
        self.storyTitleLabel.text = config.story.name
        self.storyContentLabel.text = config.story.storyContent
        self.saveButtonState(config.saveButtonState)
        
        guard let backgroundMusic = config.universe?.backgroundMusic else { return }
        
        MusicManager.shared.startMusic(backgroundMusic)
    }

    func setupUI() {
        self.storyContentLabel.font = FontFamily.Montserrat.regular.font(size: 18)
    }
    
    func setupSubscriptions() {
        self.subscriptions.forEach { $0.cancel() }
        self.subscriptions.removeAll()
        
        let input = Story.Models.ViewModelInput(
            onLoad: self.onLoad.eraseToAnyPublisher(),
            onBackButtonTap: self.onBackButtonTap.eraseToAnyPublisher(),
            onSaveButtonTap: self.onSaveButtonTap.eraseToAnyPublisher()
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
    
    func handleState(_ state: Story.Models.ViewState) {
        switch state {
        case .idle:
            break
        case .loaded(let config):
            self.setup(with: config)
        }
    }

    func handleAction(_ action: Story.Models.ViewAction) {
        switch action {
        case .saveButtonState(let state):
            self.saveButtonState(state)
        }
    }
    
    func handleRoute(_ route: Story.Models.ViewRoute) {
        switch route {
        case .dismiss:
            self.dismiss()
        case .pop:
            self.pop()
        }
    }
}

// MARK: - Private
private extension StoryViewController {

    func dismiss() {
        self.navigationController?.dismiss(animated: true) {
            MusicManager.shared.startMusic(.mainTheme)
        }
    }

    func pop() {
        self.navigationController?.popViewController(animated: true)
        MusicManager.shared.startMusic(.mainTheme)
    }
    
    func saveButtonState(_ state: Story.Models.SaveButtonState) {
        switch state {
        case .hidden:
            self.saveButton.isHidden = true
        case .active:
            self.saveButton.setImage(Asset.Images.saveSelected.image, for: .normal)
        case .inactive:
            self.saveButton.setImage(Asset.Images.saveUnselected.image, for: .normal)
        }
    }
}
