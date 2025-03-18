//
//  SelectionStepViewController.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 09/09/2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
import Combine
import IQKeyboardManagerSwift

final class SelectionStepViewController: UIViewController {
    
    // MARK: Subviews
    @IBOutlet private weak var stepTitleLabel: UILabel!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var stepInfoLabel: UILabel!
    @IBOutlet private weak var stepProgressImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var addCharacterDialog: AddCharacterDialog?
    
    // MARK: Other properties
    private lazy var collectionAdapter = SelectionStepCollectionAdapter(
        collectionView: self.collectionView,
        onCellTap: { [weak self] index in
            self?.onCellTap.send(index)
        },
        onSelectRandomTap: { [weak self] in
            self?.onSelectRandomTap.send()
        },
        onAddCharacter: { [weak self] in
            self?.onAddCharacter.send()
        },
        onRemoveCharacter: { [weak self] character in
            self?.onRemoveCustomCharacter.send(character)
        }
    )
    private var viewModel: ISelectionStepViewModel?
    private var subscriptions = Set<AnyCancellable>()
    private let onLoad = PassthroughSubject<Void, Never>()
    private let onBackButtonTap = PassthroughSubject<Void, Never>()
    private let onNextButtonTap = PassthroughSubject<Void, Never>()
    private let onCellTap = PassthroughSubject<Int, Never>()
    private let onSelectRandomTap = PassthroughSubject<Void, Never>()
    private let onAddCharacter = PassthroughSubject<Void, Never>()
    private let onSaveCustomCharacter = PassthroughSubject<CustomCharacter, Never>()
    private let onRemoveCustomCharacter = PassthroughSubject<CustomCharacter, Never>()
    
    private var defaultkeyboardDistanceFromTextField: CGFloat = 0

    // MARK: Life cycle
    convenience init() {
        self.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.onLoad.send()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.addCharacterDialog?.frame = self.frameForAddCharacterDialog()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.defaultkeyboardDistanceFromTextField = IQKeyboardManager.shared.keyboardDistanceFromTextField
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 220
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = self.defaultkeyboardDistanceFromTextField
    }
    
    func setDependencies(viewModel: ISelectionStepViewModel?) {
        self.viewModel = viewModel
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.impactFeedbackGenerator.impactOccurred()
        self.onBackButtonTap.send()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        self.impactFeedbackGenerator.impactOccurred()
        self.onNextButtonTap.send()
    }
}

// MARK: - Setup
private extension SelectionStepViewController {
    
    func setup() {
        self.setupUI()
        self.setupSubscriptions()
    }
    
    func setupUI() {
        self.nextButton.setTitle(
            L10n.SelectionStep.next,
            for: .normal
        )
    }
    
    func setup(with config: SelectionStep.Models.Configuration) {
        self.stepTitleLabel.text = config.step.title
        self.stepInfoLabel.text = config.step.info
        self.stepProgressImageView.image = config.step.progressImage
        self.collectionAdapter.config = config
    }
    
    func setupSubscriptions() {
        self.subscriptions.forEach { $0.cancel() }
        self.subscriptions.removeAll()
        
        let input = SelectionStep.Models.ViewModelInput(
            onLoad: self.onLoad.eraseToAnyPublisher(),
            onBackButtonTap: self.onBackButtonTap.eraseToAnyPublisher(),
            onNextButtonTap: self.onNextButtonTap.eraseToAnyPublisher(),
            onCellTap: self.onCellTap.eraseToAnyPublisher(),
            onSelectRandomTap: self.onSelectRandomTap.eraseToAnyPublisher(),
            onAddCharacter: self.onAddCharacter.eraseToAnyPublisher(),
            onSaveCustomCharacter: self.onSaveCustomCharacter.eraseToAnyPublisher(),
            onRemoveCustomCharacter: self.onRemoveCustomCharacter.eraseToAnyPublisher()
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
    
    func handleState(_ state: SelectionStep.Models.ViewState) {
        switch state {
        case .idle:
            break
        case .loaded(let config):
            self.setup(with: config)
        }
    }

    func handleAction(_ action: SelectionStep.Models.ViewAction) {
        switch action {
        case .enableNextButton(let enable):
            self.nextButton.isHidden = !enable
        case .showAddCharacterDialog:
            self.showAddCharacterDialog()
        }
    }
    
    func handleRoute(_ route: SelectionStep.Models.ViewRoute) {
        switch route {
        case .dismiss:
            self.dismiss()
        case .pop:
            self.pop()
        case .selectionStep(let config):
            self.goToSelectionStep(config)
        case .storyCreation(let config):
            self.goStoryCreation(config)
        }
    }
}

// MARK: - Navigation
private extension SelectionStepViewController {
    
    func dismiss() {
        self.navigationController?.dismiss(animated: true)
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func goToSelectionStep(_ config: SelectionStep.Models.Configuration) {
        let viewController = SelectionStep.Assembly.createModule(config: config)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func goStoryCreation(_ storyConfig: StoryConfiguation) {
        let viewController = StoryCreation.Assembly.createModule(storyConfiguration: storyConfig)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Private
private extension SelectionStepViewController {

    func showAddCharacterDialog() {
        let backgroundView = UIView(frame: self.view.bounds)
        backgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundView.backgroundColor = Asset.Colors._262845.color.withAlphaComponent(0.7)
        backgroundView.alpha = 0
        
        self.view.addSubview(backgroundView)
        
        var initialFrame = self.frameForAddCharacterDialog()
        let finalY = initialFrame.origin.y
        initialFrame.origin.y = self.view.frame.height
        
        let dialog = AddCharacterDialog(frame: initialFrame)
        
        dialog.onClose = { [weak self] in
            self?.addCharacterDialog?.removeFromSuperview()
            backgroundView.removeFromSuperview()
        }
        
        dialog.onSave = { [weak self] customCharacter in
            self?.onSaveCustomCharacter.send(customCharacter)
            self?.addCharacterDialog?.removeFromSuperview()
            backgroundView.removeFromSuperview()
        }
        
        self.view.addSubview(dialog)
        self.addCharacterDialog = dialog
        
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.3,
            options: .curveEaseOut
        ) {
            dialog.frame.origin.y = finalY
            backgroundView.alpha = 1
        }
    }
    
    func frameForAddCharacterDialog() -> CGRect {
        let width = min(365, self.view.frame.width - 20)
        let height: CGFloat = 320
        
        return .init(
            x: (self.view.frame.width - width) / 2,
            y: (self.view.frame.height - height) / 2,
            width: width,
            height: height
        )
    }
}
