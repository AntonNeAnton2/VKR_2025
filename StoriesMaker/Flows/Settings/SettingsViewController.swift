//
//  SettingsViewController.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 30/08/2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
import Combine

final class SettingsViewController: UIViewController {
    
    // MARK: Subviews
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var settingsContainer: UIView!
    @IBOutlet private weak var helpView: UIView!
    @IBOutlet private weak var helpLabel: UILabel!
    @IBOutlet private weak var rateUsView: UIView!
    @IBOutlet private weak var rateUsLabel: UILabel!
    @IBOutlet private weak var shareAppView: UIView!
    @IBOutlet private weak var shareAppLabel: UILabel!
    @IBOutlet private weak var changeLanguageView: UIView!
    @IBOutlet private weak var changeLanguageLabel: UILabel!
    @IBOutlet private weak var changeLanguageIcon: UIImageView!
    @IBOutlet private weak var legalView: UIView!
    @IBOutlet private weak var legalLabel: UILabel!
    
    // MARK: Other properties
    private var viewModel: ISettingsViewModel?
    private var subscriptions = Set<AnyCancellable>()
    private let onLoad = PassthroughSubject<Void, Never>()
    private let onSelectSetting = PassthroughSubject<Settings.Models.Setting, Never>()
    private let onChangeLanguage = PassthroughSubject<Void, Never>()
    private let onConfirmChangeLanguage = PassthroughSubject<Void, Never>()
    private let onPrivacyPolicy = PassthroughSubject<Void, Never>()
    private let onTermsOfUse = PassthroughSubject<Void, Never>()

    // MARK: Life cycle
    convenience init() {
        self.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.onLoad.send()
    }
    
    func setDependencies(viewModel: ISettingsViewModel?) {
        self.viewModel = viewModel
    }
}

// MARK: - Setup
private extension SettingsViewController {
    
    func setup() {
        self.setupUI()
        self.setupSubscriptions()
    }
    
    func setupUI() {
        self.titleLabel.text = L10n.Settings.settings
        
        self.settingsContainer.layer.cornerRadius = 15
        
        self.helpView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.helpViewTapped)
            )
        )
        self.helpLabel.text = L10n.Settings.help
        
        self.rateUsView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.rateUsViewTapped)
            )
        )
        self.rateUsLabel.text = L10n.Settings.rateUs
        
        self.shareAppView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.shareAppViewTapped)
            )
        )
        self.shareAppLabel.text = L10n.Settings.shareApp
        
        self.changeLanguageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.changeLanguageViewTapped)
            )
        )
        // TODO: Can be removed after new icon with proper color is added to project
        self.changeLanguageIcon.image = Asset.Images.settingsChangeLanguage.image.withTintColor(Asset.Colors.e7Ea73.color)
        self.changeLanguageLabel.text = L10n.Settings.changeLanguage
        
        self.legalView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.legalViewTapped)
            )
        )
        self.legalLabel.text = L10n.Settings.privacyAndTerms
    }
    
    func setupSubscriptions() {
        self.subscriptions.forEach { $0.cancel() }
        self.subscriptions.removeAll()
        
        let input = Settings.Models.ViewModelInput(
            onLoad: self.onLoad.eraseToAnyPublisher(),
            onSelectSetting: self.onSelectSetting.eraseToAnyPublisher(),
            onPrivacyPolicy: self.onPrivacyPolicy.eraseToAnyPublisher(),
            onTermsOfUse: self.onTermsOfUse.eraseToAnyPublisher(),
            onChangeLanguage: self.onChangeLanguage.eraseToAnyPublisher(),
            onConfirmChangeLanguage: self.onConfirmChangeLanguage.eraseToAnyPublisher()
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
    
    func handleState(_ state: Settings.Models.ViewState) {
        switch state {
        case .idle:
            break
        }
    }

    func handleAction(_ action: Settings.Models.ViewAction) {
        switch action {
        case .showHelp(let controller):
            self.present(controller, animated: true)
        case .showHelpFailure(let email):
            let alert = UIAlertController(
                title: L10n.Settings.failedToCompose,
                message: L10n.Settings.pleaseSendToAddress(email),
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        case .showRateUs(let url):
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case .showShare(let url):
            let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.present(controller, animated: true)
        case .showLegalChoise:
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            sheet.addAction(
                .init(
                    title: L10n.Settings.privacyPolicy,
                    style: .default,
                    handler: { [weak self] _ in
                        self?.impactFeedbackGenerator.impactOccurred()
                        self?.onPrivacyPolicy.send()
                    }
                )
            )
            sheet.addAction(
                .init(
                    title: L10n.Settings.termsOfUse,
                    style: .default,
                    handler: { [weak self] _ in
                        self?.impactFeedbackGenerator.impactOccurred()
                        self?.onTermsOfUse.send()
                    }
                )
            )
            sheet.addAction(.init(title: L10n.Settings.cancel, style: .cancel))
            self.present(sheet, animated: true)
        case .showLegal(let url):
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case .showChangeLanguageAlert:
            let sheet = UIAlertController(
                title: nil,
                message: L10n.Settings.changeLanguageAlertMessage,
                preferredStyle: .alert
            )
            
            sheet.addAction(.init(title: L10n.Settings.cancel, style: .cancel))
            sheet.addAction(
                .init(
                    title: L10n.Settings.settings,
                    style: .default,
                    handler: { [weak self] _ in
                        self?.impactFeedbackGenerator.impactOccurred()
                        self?.onConfirmChangeLanguage.send()
                    }
                )
            )
            
            self.present(sheet, animated: true)
        }
    }
    
    func handleRoute(_ route: Settings.Models.ViewRoute) {
        switch route {
        case .youAreAllSet:
            self.goToYouAreAllSet()
        case .settings:
            self.goToSettings()
        }
    }
}

// MARK: - Navigation
private extension SettingsViewController {
    
    func goToYouAreAllSet() {
//        guard let customNavigationController = self.navigationController as? CustomNavigationController else { return }
//        let controller = YouAreAllSet.Assembly.createModule()
//        controller.hidesBottomBarWhenPushed = true
//        customNavigationController.push(screen: controller, animated: true)
    }
    
    func goToSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsUrl)
        else { return }
        
        UIApplication.shared.open(settingsUrl)
    }
}

// MARK: - Private
private extension SettingsViewController {

    @objc
    func helpViewTapped() {
        self.impactFeedbackGenerator.impactOccurred()
        self.onSelectSetting.send(.help)
    }
    
    @objc
    func rateUsViewTapped() {
        self.impactFeedbackGenerator.impactOccurred()
        self.onSelectSetting.send(.rateUs)
    }
    
    @objc
    func shareAppViewTapped() {
        self.impactFeedbackGenerator.impactOccurred()
        self.onSelectSetting.send(.shareApp)
    }
    
    @objc
    func changeLanguageViewTapped() {
        self.impactFeedbackGenerator.impactOccurred()
        self.onChangeLanguage.send()
    }
    
    @objc
    func legalViewTapped() {
        self.impactFeedbackGenerator.impactOccurred()
        self.onSelectSetting.send(.privacyPolicyTermOfUse)
    }
}
