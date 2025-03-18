//
//  TabBarViewController.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 29/08/2024.
//

import UIKit
import Combine

final class TabBarViewController: UITabBarController {
    
    // MARK: Subviews
    private lazy var customTabBar: TabBar = {
        let tabBar = TabBar().withoutAutoresizing()
        tabBar.selectedTabPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tab in
                self?.handleTabChange(tab)
            }
            .store(in: &self.subscriptions)
        return tabBar
    }()
    
    private lazy var premiumButton: UIButton = {
        let button = UIButton().withoutAutoresizing()
        button.setImage(Asset.Images.premiumButton.image, for: .normal)
        button.addAction(
            .init(
                handler: { [weak self] _ in
                    self?.handlePremiumButtonTap()
                }
            ),
            for: .touchUpInside
        )
        return button
    }()
    
    // MARK: Other properties
    private var onboardingViewController: UIViewController?
    private var onboardingWasShown = false//UserDefaultsManager.shared.getBool(by: .onboardingWasShown)
    private var subscriptionWasShown = false
    private var subscriptionHasExpiredAlertIsShown = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateSubscriptionInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showOnboardingIfNeeded()
        self.showSubscriptionIfNeeded()
    }
}

// MARK: - Setup
private extension TabBarViewController {
    
    func setup() {
        self.delegate = self
        self.setupViewControllers()
        self.setupTabBar()
        self.setupPremiumButton()
        self.setupSubscriptions()
        MusicManager.shared.startMusic(.mainTheme)
    }
    
    func updateSubscriptionInfo() {
        SubscriptionHelper.updateSubscriptionInfo { [weak self] subscriptionIsValid in
            guard let subscriptionIsValid else { return }
            
            self?.updatePremiumButtonVisibility(isHidden: subscriptionIsValid)
        }
    }
    
    func setupViewControllers() {
        let libraryFlow = self.libraryFlow()
        let makeStoryFlow = self.makeStoryFlow()
        let settingsFlow = self.settingsFlow()
        
        self.viewControllers = [
            libraryFlow,
            makeStoryFlow,
            settingsFlow
        ]
    }
    
    func setupTabBar() {
        self.tabBar.isHidden = true
        self.view.addSubview(self.customTabBar)
        self.customTabBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(15)
            make.height.equalTo(TabBar.Constants.height)
        }
    }
    
    func setupPremiumButton() {
        self.view.addSubview(self.premiumButton)
        self.premiumButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview().inset(15)
        }
    }
    
    func updatePremiumButtonVisibility(isHidden: Bool) {
        self.premiumButton.isHidden = isHidden
    }
    
    func setupSubscriptions() {
  
    }
}

// MARK: - Setup viewControllers
private extension TabBarViewController {
    
    func libraryFlow() -> UIViewController {
        let controller = Library.Assembly.createModule()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.isNavigationBarHidden = true
        navigationController.delegate = self
        return navigationController
    }
    
    func makeStoryFlow() -> UIViewController {
        let controller = MakeStory.Assembly.createModule()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
    
    func settingsFlow() -> UIViewController {
        let controller = Settings.Assembly.createModule()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
}

// MARK: - Logic
private extension TabBarViewController {
    
    func handleTabChange(_ tab: Tab) {
        self.selectedIndex = tab.index
        
        switch tab {
        case .library:
            AnalyticsManager.shared.track(event: .openLibrary)
        case .makeStory:
            AnalyticsManager.shared.track(event: .openMakeStory)
        case .settings:
            AnalyticsManager.shared.track(event: .openSettings)
        }
    }
    
    func showSubscriptionIfNeeded() {
        guard !SubscriptionHelper.isSubscriptionActive(),
              UserDefaultsManager.shared.getBool(by: .firstStoryCreated),
              !UserDefaultsManager.shared.getBool(by: .firstStoryPaywallShown) else { return }
        self.showSubscription(entryPoint: .firstStory, isDismissable: true)
        UserDefaultsManager.shared.save(value: true, forKey: .firstStoryPaywallShown)
    }
    
    func showOnboardingIfNeeded() {
        guard !self.onboardingWasShown else { return }
        
        let controller = NewOnboarding.Assembly.createModule()
//        { [weak self] in
//            self?.onboardingViewController?.dismiss(
//                animated: true,
//                completion: { [weak self] in
//                    guard !SubscriptionHelper.isSubscriptionActive() else { return }
//                    UserDefaultsManager.shared.save(value: true, forKey: .onboardingWasShown)
//                    self?.showSubscription(entryPoint: .onboarding, isDismissable: true)
//                    self?.subscriptionWasShown = true
//                }
//            )
//        }
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
        self.onboardingViewController = controller
        
        self.onboardingWasShown = true
    }
    
    func handlePremiumButtonTap() {
        self.impactFeedbackGenerator.impactOccurred()
        let entryPoint: Subscription.Models.EntryPoint = {
            switch self.customTabBar.selectedTab {
            case .library:
                if let navigationController = self.viewControllers?[0] as? UINavigationController,
                   navigationController.topViewController is StoryViewController {
                    return .premiumStory
                } else {
                    return .premiumLibrary
                }
            case .makeStory:
                return .premiumMakeStory
            case .settings:
                return .premiumSettings
            }
        }()
        self.showSubscription(entryPoint: entryPoint, isDismissable: true)
    }
}

// MARK: - Navigation
private extension TabBarViewController {
    
    func showSubscription(entryPoint: Subscription.Models.EntryPoint, isDismissable: Bool) {
        let controller = Subscription.Assembly.createModule(entryPoint: entryPoint, isDismissable: isDismissable)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        animationControllerForTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        TabBarAnimatedTransitioning()
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        self.tabBar.isHidden = true
        if viewController.hidesBottomBarWhenPushed {
            self.customTabBar.isHidden = true
        } else {
            self.customTabBar.isHidden = false
        }
    }
}
