//
//  SubscriptionViewController.swift
//  StoriesMaker
//
//  Created by borisenko on 19.09.2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
import Combine
import Glassfy

final class SubscriptionViewController: UIViewController {
    
    // MARK: Subviews
    @IBOutlet var firstSubscriptionOptionView: SubscriptionOptionView!
    @IBOutlet var secondSubscriptionOptionView: SubscriptionOptionView!
    @IBOutlet var thirdSubscriptionOptionView: SubscriptionOptionView!
    
    @IBOutlet weak var premiumTitleLabel: UILabel!
    @IBOutlet weak var premiumDescriptionLabel: UILabel!
    @IBOutlet weak var freeStoryCreationsLeftLabel: UILabel!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    @IBOutlet weak var restorePurchasesLabel: UILabel!
    @IBOutlet weak var termsOfUseLabel: UILabel!
    @IBOutlet weak var legalStackView: UIStackView!
    
    @IBOutlet weak var arrowBackButton: UIButton!
    @IBOutlet weak var crossBackButton: UIButton!
    
    // MARK: Constraints
    @IBOutlet weak var premiumLabelHeightConstraint: NSLayoutConstraint!
    
    // MARK: Other properties
    private var viewModel: ISubscriptionViewModel?
    private var isDismissable = false
    private var subscriptions = Set<AnyCancellable>()
    private let onLoad = PassthroughSubject<Void, Never>()
    private let onArrowButtonTapped = PassthroughSubject<Void, Never>()
    private let onCrossButtonTapped = PassthroughSubject<Void, Never>()
    private let onOptionSelected = PassthroughSubject<String, Never>()
    private let onRestorePurchasesTapped = PassthroughSubject<Void, Never>()
    private let onTermsOfUseTapped = PassthroughSubject<Void, Never>()
    private let onPrivacyPolicyTapped = PassthroughSubject<Void, Never>()
    private let onSuccessPurchaseDismiss = PassthroughSubject<Void, Never>()

    // MARK: Life cycle
    convenience init() {
        self.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.onLoad.send()
    }
    
    func setDependencies(viewModel: ISubscriptionViewModel?, isDismissable: Bool) {
        self.viewModel = viewModel
        self.isDismissable = isDismissable
    }
    
    // MARK: Actions
    @IBAction func arrowBackButtonTapped(_ sender: Any) {
        self.impactFeedbackGenerator.impactOccurred()
        self.onArrowButtonTapped.send()
    }
    
    @IBAction func crossBackButtonTapped(_ sender: Any) {
        self.impactFeedbackGenerator.impactOccurred()
        self.onCrossButtonTapped.send()
    }
}

// MARK: - Setup
private extension SubscriptionViewController {
    
    func setup() {
        self.setupUI()
        self.setupSubscriptions()
    }
    
    func configureView(with viewConfig: Subscription.Models.ViewConfig) {
        self.firstSubscriptionOptionView.configure(with: viewConfig.weekInfo)
        self.secondSubscriptionOptionView.configure(with: viewConfig.monthInfo)
        self.thirdSubscriptionOptionView.configure(with: viewConfig.yearInfo)
        
        self.addGestures()
    }
    
    func setupUI() {
        self.premiumTitleLabel.text = L10n.Subscription.getPremium
        self.premiumLabelHeightConstraint.isActive = LocaleHelper.getCurrentLanguage() == .russian
        
        if LocaleHelper.getCurrentLanguage() == .russian {
            self.premiumTitleLabel.setLineHeight(lineHeight: 0.56)
        }
        
        self.premiumDescriptionLabel.text = L10n.Subscription.unlockTheMiracle
        
        let numberOfFreeCreationsLeft = SubscriptionHelper.getNumberOfFreeStoriesCreationsLeft()
        self.freeStoryCreationsLeftLabel.text = {
            guard !SubscriptionHelper.isSubscriptionActive() else { return L10n.Subscription.allSet }
            
            switch numberOfFreeCreationsLeft {
            case 0:
                return L10n.Subscription.noFreeCreationsLeft
            case 1:
                return L10n.Subscription.freeStoryCreationLeft
            default:
                return L10n.Subscription.freeStoryCreationsLeft(numberOfFreeCreationsLeft)
            }
        }()
        
        let privacyPolicyLabelTap = UITapGestureRecognizer(target: self, action: #selector(privacyPolicyTapped))
        self.privacyPolicyLabel.text = L10n.Subscription.privacyPolicy
        self.privacyPolicyLabel.isUserInteractionEnabled = true
        self.privacyPolicyLabel.addGestureRecognizer(privacyPolicyLabelTap)
        
        let restorePurchasesLabelTap = UITapGestureRecognizer(target: self, action: #selector(restorePurchasesTapped))
        self.restorePurchasesLabel.text = L10n.Subscription.restorePurchases
        self.restorePurchasesLabel.isUserInteractionEnabled = true
        self.restorePurchasesLabel.addGestureRecognizer(restorePurchasesLabelTap)
        
        let termsOfUseLabelTap = UITapGestureRecognizer(target: self, action: #selector(termsOfUseTapped))
        self.termsOfUseLabel.text = L10n.Subscription.termsOfUse
        self.termsOfUseLabel.isUserInteractionEnabled = true
        self.termsOfUseLabel.addGestureRecognizer(termsOfUseLabelTap)
        
        self.legalStackView.spacing = LocaleHelper.getCurrentLanguage() == .german ? 6.0 : 30.0
        
        self.arrowBackButton.isHidden = self.isDismissable
        self.crossBackButton.isHidden = !self.isDismissable
    }
    
    func addGestures() {
        [firstSubscriptionOptionView, secondSubscriptionOptionView, thirdSubscriptionOptionView].forEach {
            let tap = UITapGestureRecognizer(target: self, action: #selector(optionSelected))
            $0.addGestureRecognizer(tap)
        }
    }
    
    func setupSubscriptions() {
        self.subscriptions.forEach { $0.cancel() }
        self.subscriptions.removeAll()
        
        let input = Subscription.Models.ViewModelInput(
            onLoad: self.onLoad.eraseToAnyPublisher(),
            onCrossButtonTapped: self.onCrossButtonTapped.eraseToAnyPublisher(),
            onArrowButtonTapped: self.onArrowButtonTapped.eraseToAnyPublisher(),
            onOptionSelected: self.onOptionSelected.eraseToAnyPublisher(),
            onRestorePurchasesTapped: self.onRestorePurchasesTapped.eraseToAnyPublisher(),
            onTermsOfUseTapped: self.onTermsOfUseTapped.eraseToAnyPublisher(),
            onPrivacyPolicyTapped: self.onPrivacyPolicyTapped.eraseToAnyPublisher(),
            onSuccessPurchaseDismiss: self.onSuccessPurchaseDismiss.eraseToAnyPublisher()
        )
        self.viewModel?.process(input: input)
        
        self.viewModel?.viewStatePublisher
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
    
    func handleState(_ state: Subscription.Models.ViewState) {
        switch state {
        case .idle:
            break
        case let .loaded(viewConfig):
            self.configureView(with: viewConfig)
        }
    }

    func handleAction(_ action: Subscription.Models.ViewAction) {
        // TODO: Refactor
        switch action {
        case .showLegal(let url):
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case let .showError(description):
            self.hideLoading()
            self.view.isUserInteractionEnabled = true
            self.showErrorAlert(description: description)
        case .showPurchaseSuccess:
            self.hideLoading()
            self.view.isUserInteractionEnabled = true
            self.showPurchaseSuccessAlert()
        case .showNothingToRestore:
            self.hideLoading()
            self.view.isUserInteractionEnabled = true
            self.showNothingToRestoreAlert()
        case .showLoading(let show):
            show ? self.showLoading() : self.hideLoading()
            self.view.isUserInteractionEnabled = !show
        }
    }
    
    func handleRoute(_ route: Subscription.Models.ViewRoute) {
        switch route {
        case .closeModule:
            self.closeModule()
        }
    }
}

// MARK: - Private
private extension SubscriptionViewController {
    
    @objc func optionSelected(sender: UITapGestureRecognizer) {
        self.impactFeedbackGenerator.impactOccurred()
        guard let optionView = sender.view,
              let selectedOptionId = Subscription.Models.SubscriptionIdentifier.allCases[safe: optionView.tag]?.rawValue
        else { return }
        
        self.showLoading()
        self.view.isUserInteractionEnabled = false
        optionView.showTapAnimation() { [weak self] in
            self?.onOptionSelected.send(selectedOptionId)
        }
    }
    
    @objc func termsOfUseTapped() {
        self.impactFeedbackGenerator.impactOccurred()
        self.onTermsOfUseTapped.send()
    }
    
    @objc func privacyPolicyTapped() {
        self.impactFeedbackGenerator.impactOccurred()
        self.onPrivacyPolicyTapped.send()
    }
    
    @objc func restorePurchasesTapped() {
        self.impactFeedbackGenerator.impactOccurred()
        self.showLoading()
        self.view.isUserInteractionEnabled = false
        self.onRestorePurchasesTapped.send()
    }

    func showPurchaseSuccessAlert() {
        let alert = UIAlertController(
            title: L10n.Subscription.allSet,
            message: L10n.Subscription.congratulations,
            preferredStyle: .alert
        )
        alert.addAction(
            .init(
                title: L10n.Subscription.letsGo,
                style: .default,
                handler: { [weak self] _ in
                    self?.onSuccessPurchaseDismiss.send()
                }
            )
        )
        self.present(alert, animated: true)
    }
    
    func showNothingToRestoreAlert() {
        let alert = UIAlertController(
            title: L10n.Subscription.noPurchasesFound,
            message: L10n.Subscription.noInfoAboutAnyPurchases,
            preferredStyle: .alert
        )
        alert.addAction(
            .init(
                title: "OK",
                style: .default
            )
        )
        self.present(alert, animated: true)
    }

    func closeModule() {
        guard self.isDismissable else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.dismiss(animated: true)
    }
}
