//
//  SettingsViewModel.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 30/08/2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine
import MessageUI

protocol ISettingsViewModel: AnyObject {
    
    var viewStatePublisher: AnyPublisher<Settings.Models.ViewState, Never> { get }
    var viewActionPublisher: AnyPublisher<Settings.Models.ViewAction, Never> { get }
    var viewRoutePublisher: AnyPublisher<Settings.Models.ViewRoute, Never> { get }

    func process(input: Settings.Models.ViewModelInput)
}

final class SettingsViewModel: NSObject {
    
    // MARK: Properties
    private let viewStateSubject = CurrentValueSubject<Settings.Models.ViewState, Never>(.idle)
    private let viewActionSubject = PassthroughSubject<Settings.Models.ViewAction, Never>()
    private let viewRouteSubject = PassthroughSubject<Settings.Models.ViewRoute, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
}

// MARK: - ISettingsViewModel
extension SettingsViewModel: ISettingsViewModel {

    var viewStatePublisher: AnyPublisher<Settings.Models.ViewState, Never> {
        self.viewStateSubject.eraseToAnyPublisher()
    }
    
    var viewActionPublisher: AnyPublisher<Settings.Models.ViewAction, Never> {
        self.viewActionSubject.eraseToAnyPublisher()
    }
    
    var viewRoutePublisher: AnyPublisher<Settings.Models.ViewRoute, Never> {
        self.viewRouteSubject.eraseToAnyPublisher()
    }
    
    func process(input: Settings.Models.ViewModelInput) {
        input.onLoad
            .sink { [weak self] in
                
            }
            .store(in: &self.subscriptions)
        
        input.onSelectSetting
            .sink { [weak self] setting in
                self?.handleSelect(setting: setting)
            }
            .store(in: &subscriptions)
        
        input.onPrivacyPolicy
            .sink { [weak self] in
                self?.handlePrivacyPolicy()
            }
            .store(in: &subscriptions)
        
        input.onTermsOfUse
            .sink { [weak self] in
                self?.handleTermsOfUse()
            }
            .store(in: &subscriptions)
        
        input.onChangeLanguage
            .sink { [weak self] in
                self?.handleChangeLanguage()
            }
            .store(in: &subscriptions)
        
        input.onConfirmChangeLanguage
            .sink { [weak self] in
                self?.handleConfirmChangeLanguage()
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Private
private extension SettingsViewModel {
    
    func handleSelect(setting: Settings.Models.Setting) {
        switch setting {
        case .help:
            self.handleHelp()
        case .rateUs:
            self.handleRateUs()
        case .shareApp:
            self.handleShareApp()
        case .privacyPolicyTermOfUse:
            self.viewActionSubject.send(.showLegalChoise)
        }
    }
    
    func handleHelp() {
        let email = "appsfromalliance@gmail.com"
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setSubject(L10n.Settings.Email.subject)
            mail.setMessageBody(L10n.Settings.Email.body, isHTML: true)
            self.viewActionSubject.send(.showHelp(mail))
        } else {
            self.viewActionSubject.send(.showHelpFailure(email))
        }
    }
    
    func handleRateUs() {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/id6464425287?mt=8&action=write-review") else { return }
        self.viewActionSubject.send(.showRateUs(url))
    }
    
    func handleShareApp() {
        guard let url = URL(string: "https://apps.apple.com/us/app/id6464425287") else { return }
        self.viewActionSubject.send(.showShare(url))
    }
    
    func handleChangeLanguage() {
        self.viewActionSubject.send(.showChangeLanguageAlert)
    }
    
    func handleConfirmChangeLanguage() {
        self.viewRouteSubject.send(.settings)
    }
    
    func handlePrivacyPolicy() {
        guard let url = URL(string: "https://192.168.0.1:80/privacy-policy/magicJourneys.pdf") else { return }
        self.viewActionSubject.send(.showLegal(url))
    }
    
    func handleTermsOfUse() {
        guard let url = URL(string: "https://192.168.0.1:80/terms-of-use/magicJourneys.pdf") else { return }
        self.viewActionSubject.send(.showLegal(url))
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension SettingsViewModel: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
