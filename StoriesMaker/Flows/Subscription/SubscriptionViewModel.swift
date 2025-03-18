//
//  SubscriptionViewModel.swift
//  StoriesMaker
//
//  Created by borisenko on 19.09.2023.
//  Copyright © 2023 ___ORGANIZATIONNAME___ All rights reserved.
//

import Foundation
import Combine
import Glassfy
import StoreKit

protocol ISubscriptionViewModel: AnyObject {
    
    var viewStatePublisher: AnyPublisher<Subscription.Models.ViewState, Never> { get }
    var viewActionPublisher: AnyPublisher<Subscription.Models.ViewAction, Never> { get }
    var viewRoutePublisher: AnyPublisher<Subscription.Models.ViewRoute, Never> { get }

    func process(input: Subscription.Models.ViewModelInput)
}

final class SubscriptionViewModel {
    
    // MARK: Properties
    private let viewStateSubject = CurrentValueSubject<Subscription.Models.ViewState, Never>(.idle)
    private let viewActionSubject = PassthroughSubject<Subscription.Models.ViewAction, Never>()
    private let viewRouteSubject = PassthroughSubject<Subscription.Models.ViewRoute, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    private var products = [Glassfy.Sku]()
    
    private let entryPoint: Subscription.Models.EntryPoint
    
    init(entryPoint: Subscription.Models.EntryPoint) {
        self.entryPoint = entryPoint
    }
}

// MARK: - ISubscriptionViewModel
extension SubscriptionViewModel: ISubscriptionViewModel {

    var viewStatePublisher: AnyPublisher<Subscription.Models.ViewState, Never> {
        self.viewStateSubject.eraseToAnyPublisher()
    }
    
    var viewActionPublisher: AnyPublisher<Subscription.Models.ViewAction, Never> {
        self.viewActionSubject.eraseToAnyPublisher()
    }
    
    var viewRoutePublisher: AnyPublisher<Subscription.Models.ViewRoute, Never> {
        self.viewRouteSubject.eraseToAnyPublisher()
    }
    
    func process(input: Subscription.Models.ViewModelInput) {
        input.onLoad
            .sink { [weak self] in
                self?.onLoad()
            }
            .store(in: &self.subscriptions)
        
        input.onArrowButtonTapped
            .sink { [weak self] in
                self?.onArrowButtonTapped()
            }
            .store(in: &self.subscriptions)
        
        input.onCrossButtonTapped
            .sink { [weak self] in
                self?.onCrossButtonTapped()
            }
            .store(in: &self.subscriptions)
        
        input.onOptionSelected
            .sink { [weak self] productId in
                self?.purchaseSelectedSubscription(productId: productId)
            }
            .store(in: &self.subscriptions)
        
        input.onPrivacyPolicyTapped
            .sink { [weak self] in
                self?.handlePrivacyPolicy()
            }
            .store(in: &self.subscriptions)
        
        input.onTermsOfUseTapped
            .sink { [weak self] in
                self?.handleTermsOfUse()
            }
            .store(in: &self.subscriptions)
        
        input.onRestorePurchasesTapped
            .sink { [weak self] in
                self?.handleRestorePurchases()
            }
            .store(in: &self.subscriptions)
        
        input.onSuccessPurchaseDismiss
            .sink { [weak self] in
                self?.handleSuccessPurchaseDismiss()
            }
            .store(in: &self.subscriptions)
    }
}

// MARK: - Private
private extension SubscriptionViewModel {
    
    func analyticsEntryPoint() -> AnalyticsManager.Model.SubscriptionEntryPoint {
        switch self.entryPoint {
        case .onboarding:
            return .onboarding
        case .makeStory:
            return .makeStory
        case .premiumLibrary:
            return .premiumLibrary
        case .premiumStory:
            return .premiumStory
        case .premiumMakeStory:
            return .premiumMakeStory
        case .premiumSettings:
            return .premiumSettings
        case .firstStory:
            return .firstStory
        }
    }

    func onLoad() {
        self.trackShow()
        
        Glassfy.offerings { [weak self] (offers, err) in
            let products = offers?["premiumAccess"]?.skus ?? []
            self?.products.append(contentsOf: products)
            
            let weeklyIdentifier = Subscription.Models.SubscriptionIdentifier.weekly.rawValue
            let monthlyIdentifier = Subscription.Models.SubscriptionIdentifier.monthly.rawValue
            let yearlyIdentifier = Subscription.Models.SubscriptionIdentifier.yearly.rawValue
            
            guard let weeklyProduct = products.first(where: { $0.skuId == weeklyIdentifier }),
                  let monthlyProduct = products.first(where: { $0.skuId == monthlyIdentifier }),
                  let yearlyProduct = products.first(where: { $0.skuId == yearlyIdentifier })
            else {
                self?.viewRouteSubject.send(.closeModule)
                return
            }
            
            let config = Subscription.Models.ViewConfig(
                weekInfo: weeklyProduct,
                monthInfo: monthlyProduct,
                yearInfo: yearlyProduct
            )
            self?.viewStateSubject.send(.loaded(config))
        }
    }
    
    func onArrowButtonTapped() {
        self.close()
    }
    
    func onCrossButtonTapped() {
        self.close()
    }
    
    func close() {
        self.trackClose()
        self.viewRouteSubject.send(.closeModule)
    }
    
    func purchaseSelectedSubscription(productId: String) {
        guard let sku = self.products.first(where: { $0.skuId == productId }) else { return }
        
        self.trackStartPurchase(productId: sku.product.productIdentifier)
        
        Glassfy.purchase(sku: sku) { [weak self] (transaction, error) in
            guard let self = self else { return }
            guard error == nil else {
                if let skError = error as? SKError,
                   skError.code == .paymentCancelled {
                    self.trackCanceledPurchase(productId: sku.product.productIdentifier)
                    self.viewActionSubject.send(.showLoading(false))
                } else {
                    self.trackFailedPurchase(
                        productId: sku.product.productIdentifier,
                        errorDescription: error?.localizedDescription
                    )
                    self.viewActionSubject.send(.showError(L10n.Subscription.tryAgainLater))
                }
                return
            }
            
            // TODO: Refactor
            guard let permission = transaction?.permissions["premiumAccess"],
                  permission.isValid
            else {
                self.setSubscription(isActive: false)
                return
            }
            
            self.trackSuccessfulPurchase(productId: sku.product.productIdentifier)
            self.setSubscription(isActive: true)
            self.viewActionSubject.send(.showPurchaseSuccess)
        }
    }
    
    func handlePrivacyPolicy() {
        guard let url = URL(string: "https://amitrafanau.com/privacy-policy/magicJourneys.pdf") else { return }
        self.viewActionSubject.send(.showLegal(url))
    }
    
    func handleTermsOfUse() {
        guard let url = URL(string: "https://amitrafanau.com/terms-of-use/magicJourneys.pdf") else { return }
        self.viewActionSubject.send(.showLegal(url))
    }
    
    func handleRestorePurchases() {
        self.trackRestorePurchase()
        
        Glassfy.restorePurchases { [weak self] permission, error in
            guard error == nil else {
                self?.viewActionSubject.send(.showError(L10n.Subscription.tryAgainLater))
                return
            }
            
            guard permission?.all.first(where: { $0.permissionId == "premiumAccess" })?.isValid ?? false else {
                self?.setSubscription(isActive: false)
                self?.viewActionSubject.send(.showNothingToRestore)
                return
            }
            
            self?.setSubscription(isActive: true)
            self?.viewActionSubject.send(.showPurchaseSuccess)
        }
    }
    
    func handleSuccessPurchaseDismiss() {
        self.viewRouteSubject.send(.closeModule)
    }
    
    func setSubscription(isActive: Bool) {
        SubscriptionHelper.setSubscription(isActive: isActive)
    }
}

// MARK: - Analytics
private extension SubscriptionViewModel {
    
    func trackShow() {
        AnalyticsManager.shared.track(
            event: .showSubscription,
            parameters: [AnalyticsManager.Key.entryPoint: self.analyticsEntryPoint().value]
        )
    }
    
    func trackClose() {
        AnalyticsManager.shared.track(
            event: .closeSubscription,
            parameters: [AnalyticsManager.Key.entryPoint: self.analyticsEntryPoint().value]
        )
    }
    
    func trackStartPurchase(productId: String) {
        AnalyticsManager.shared.track(
            event: .startPurchase,
            parameters: [
                AnalyticsManager.Key.productId: productId,
                AnalyticsManager.Key.entryPoint: self.analyticsEntryPoint().value,
            ]
        )
    }
    
    func trackSuccessfulPurchase(productId: String) {
        AnalyticsManager.shared.track(
            event: .successfulPurchase,
            parameters: [
                AnalyticsManager.Key.productId: productId,
                AnalyticsManager.Key.entryPoint: self.analyticsEntryPoint().value
            ]
        )
    }
    
    func trackCanceledPurchase(productId: String) {
        AnalyticsManager.shared.track(
            event: .canceledPurchase,
            parameters: [
                AnalyticsManager.Key.productId: productId,
                AnalyticsManager.Key.entryPoint: self.analyticsEntryPoint().value
            ]
        )
    }
    
    func trackFailedPurchase(productId: String, errorDescription: String?) {
        AnalyticsManager.shared.track(
            event: .failedPurchase,
            parameters: [
                AnalyticsManager.Key.productId: productId,
                AnalyticsManager.Key.errorDescription: errorDescription ?? "No description",
                AnalyticsManager.Key.entryPoint: self.analyticsEntryPoint().value
            ]
        )
    }
    
    func trackRestorePurchase() {
        AnalyticsManager.shared.track(
            event: .restorePurchase,
            parameters: [AnalyticsManager.Key.entryPoint: self.analyticsEntryPoint().value]
        )
    }
}
