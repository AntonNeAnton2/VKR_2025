//
//  AnalyticsManager.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 28/09/2024.
//

import FirebaseAnalytics
import FacebookCore

final class AnalyticsManager: NSObject {
    
    static let shared = AnalyticsManager()
    
    private override init() {
        super.init()
    }
    
    //MARK: - Default Events
    func track(event: Event, parameters: [String: Any]? = nil) {
        let withBuildParameters = self.buildParameters(parameters: parameters)
        
        #if DEBUG
        print("Analytics EVENT NAME: \(event.name), with parameters: \(withBuildParameters)")
        #else
        self.firebase(event: event, parameters: withBuildParameters)
        #endif
    }
    
    //MARK: - Build parameters
    private func buildParameters(parameters: [String: Any]?) -> [String: Any] {
        var additionalParameters = [String: Any]()
        additionalParameters["app_version"] = Constants.AppTarget.version
        additionalParameters["app_build"] = Constants.AppTarget.build
        
        guard var parameters = parameters else {
            return additionalParameters
        }
        
        parameters.merge(additionalParameters) { (current, _) -> Any in current }
        return parameters
    }
}

// MARK: - Metrics
private extension AnalyticsManager {

    func firebase(event: Event, parameters: [String: Any]) {
        Analytics.logEvent(event.name, parameters: parameters)
    }
    
    func facebook(event: Event, parameters: [String: Any]) {
        var params: [AppEvents.ParameterName: Any] = [:]
        parameters.forEach {
            params[AppEvents.ParameterName($0.key)] = $0.value
        }
        AppEvents.shared.logEvent(AppEvents.Name(event.name), parameters: params)
    }
}

// MARK: - Events
extension AnalyticsManager {
    
    enum Event {
        
        case firstLaunch
        case onboardingPage1
        case onboardingPage2
        case onboardingPage3
        case closeOnboarding
        
        case showSubscription
        case closeSubscription
        
        case startPurchase
        case successfulPurchase
        case failedPurchase
        case canceledPurchase
        case restorePurchase
        
        case openLibrary
        case openMakeStory
        case openSettings
        case openSelectUniverse
        case openSelectCharacters
        case openSelectEvents
        case openSelectMoral
        case openStoryCreation
        case openStory
                     
        var name: String {
            switch self {
            case .firstLaunch:
                return "first_launch"
            case .onboardingPage1:
                return "onboarding_page_1"
            case .onboardingPage2:
                return "onboarding_page_2"
            case .onboardingPage3:
                return "onboarding_page_3"
            case .closeOnboarding:
                return "close_onboarding"
            case .showSubscription:
                return "show_subscription"
            case .closeSubscription:
                return "close_subscription"
            case .startPurchase:
                return "start_purchase"
            case .successfulPurchase:
                return "successful_purchase"
            case .failedPurchase:
                return "failed_purchase"
            case .canceledPurchase:
                return "canceled_purchase"
            case .restorePurchase:
                return "restore_purchase"
            case .openLibrary:
                return "open_library"
            case .openMakeStory:
                return "open_make_story"
            case .openSettings:
                return "open_settings"
            case .openSelectUniverse:
                return "open_select_universe"
            case .openSelectCharacters:
                return "open_select_characters"
            case .openSelectEvents:
                return "open_select_events"
            case .openSelectMoral:
                return "open_select_moral"
            case .openStoryCreation:
                return "open_story_creation"
            case .openStory:
                return "open_story"
            }
        }
    }
}

// MARK: - Keys
extension AnalyticsManager {
    
    enum Key {
        
        static let entryPoint = "entry_point"
        static let productId = "product_id"
        static let errorDescription = "error_description"
    }
}

// MARK: - Models
extension AnalyticsManager {
    
    enum Model {
        
        enum SubscriptionEntryPoint {
            
            case onboarding
            case makeStory
            case premiumLibrary
            case premiumStory
            case premiumMakeStory
            case premiumSettings
            case firstStory
            
            var value: String {
                switch self {
                case .onboarding:
                    return "onboarding"
                case .makeStory:
                    return "make_story"
                case .premiumLibrary:
                    return "premium_library"
                case .premiumStory:
                    return "premium_story"
                case .premiumMakeStory:
                    return "premium_make_story"
                case .premiumSettings:
                    return "premium_settings"
                case .firstStory:
                    return "first_story"
                }
            }
        }
        
        enum StoryEntryPoint {
            
            case storyCreation
            case library
            
            var value: String {
                switch self {
                case .storyCreation:
                    return "story_creation"
                case .library:
                    return "library"
                }
            }
        }
    }
}
 
private enum Constants {
    
    enum AppTarget {
        
        static let bundle: String = Bundle.main.bundleIdentifier ?? "AppBundle_Not_Found"
        static let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "AppVersion_Not_Found"
        static let build: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "AppBuild_Not_Found"
    }
}
