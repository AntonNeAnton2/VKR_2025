//
//  TabBar.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 04/09/2023.
//

import UIKit
import Combine
import SnapKit

final class TabBar: UIView {
    
    enum Constants {
        static let height: CGFloat = 61
    }
    
    // MARK: Subviews
    private lazy var stack: UIStackView = {
        let stack = UIStackView().withoutAutoresizing()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.addArrangedSubview(self.libraryTabView)
        stack.addArrangedSubview(self.makeStoryTabView)
        stack.addArrangedSubview(self.settingsTabView)
        return stack
    }()
    
    private lazy var libraryTabView: TabView = {
        let tabView = TabView(tab: .library, selected: false)
        tabView.selectionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.selectedTabSubject.send(.library)
            }
            .store(in: &self.subscriptions)
        return tabView
    }()
    
    private lazy var makeStoryTabView: TabView = {
        let tabView = TabView(tab: .makeStory, selected: true)
        tabView.selectionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.selectedTabSubject.send(.makeStory)
            }
            .store(in: &self.subscriptions)
        return tabView
    }()
    
    private lazy var settingsTabView: TabView = {
        let tabView = TabView(tab: .settings, selected: false)
        tabView.selectionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.selectedTabSubject.send(.settings)
            }
            .store(in: &self.subscriptions)
        return tabView
    }()
    
    // MARK: Other properties
    var selectedTabPublisher: AnyPublisher<Tab, Never> {
        self.selectedTabSubject.eraseToAnyPublisher()
    }
    
    var selectedTab: Tab {
        self.selectedTabSubject.value
    }
    
    private let selectedTabSubject = CurrentValueSubject<Tab, Never>(.makeStory)
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TabBar {
    
    func setup() {
        self.setupUI()
        self.setupSubscriptions()
    }
    
    func setupUI() {
        self.layer.cornerRadius = Constants.height / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = Asset.Colors.fdffc2.color.cgColor
        self.layer.shadowRadius = 9
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = Asset.Colors.fdffc2.color.cgColor
        self.layer.shadowOffset = .zero
        
        self.backgroundColor = Asset.Colors._262845.color
        
        self.addSubview(self.stack)
        self.stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupSubscriptions() {
        self.selectedTabSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tab in
                self?.refreshState(selectedTab: tab)
            }
            .store(in: &self.subscriptions)
    }
    
    func refreshState(selectedTab: Tab) {
        [
            self.libraryTabView,
            self.makeStoryTabView,
            self.settingsTabView
        ]
            .filter { $0.selected }
            .forEach { $0.selected = false }
        
        switch selectedTab {
        case .library:
            self.libraryTabView.selected = true
        case .makeStory:
            self.makeStoryTabView.selected = true
        case .settings:
            self.settingsTabView.selected = true
        }
    }
}
