//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
import Combine

final class ___VARIABLE_productName___ViewController: UIViewController {
    
    // MARK: Subviews

    // MARK: Other properties
    private let viewModel: I___VARIABLE_productName___ViewModel
    private var subscriptions = Set<AnyCancellable>()
    private let onLoad = PassthroughSubject<Void, Never>()

    // MARK: Life cycle
    init(viewModel: I___VARIABLE_productName___ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.onLoad.send()
    }
}

// MARK: - Setup
private extension ___VARIABLE_productName___ViewController {
    
    func setup() {
        self.setupUI()
        self.setupSubscriptions()
    }
    
    func setupUI() {
        // do initial ui setup here
    }
    
    func setupSubscriptions() {
        self.subscriptions.forEach { $0.cancel() }
        self.subscriptions.removeAll()
        
        let input = ___VARIABLE_productName___.Models.ViewModelInput(
            onLoad: self.onLoad.eraseToAnyPublisher()
        )
        self.viewModel.process(input: input)
        
        self.viewModel.viewStatePublisher
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &self.subscriptions)

        self.viewModel.viewRoutePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] route in
                self?.handleRoute(route)
            }
            .store(in: &self.subscriptions)

        self.viewModel.viewActionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                self?.handleAction(action)
            }
            .store(in: &self.subscriptions)
    }
    
    func handleState(_ state: ___VARIABLE_productName___.Models.ViewState) {
        switch state {
        case .idle:
            break
        }
    }

    func handleAction(_ action: ___VARIABLE_productName___.Models.ViewAction) {
        switch action {
        }
    }
    
    func handleRoute(_ route: ___VARIABLE_productName___.Models.ViewRoute) {
        switch route {
        }
    }
}

// MARK: - Private
private extension ___VARIABLE_productName___ViewController {

}
