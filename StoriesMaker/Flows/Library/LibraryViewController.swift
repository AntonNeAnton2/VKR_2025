//
//  LibraryViewController.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 08/09/2024.
//  Copyright © 2024 ___ORGANIZATIONNAME___ All rights reserved.
//

import UIKit
import Combine

final class LibraryViewController: UIViewController {
    
    // MARK: Subviews
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var emptyView: UIView!
    @IBOutlet private weak var emptyTitleLabel: UILabel!
    @IBOutlet private weak var emptySubtitleLabel: UILabel!
    @IBOutlet private weak var makeStoryButton: UIButton!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: Other properties
    private var viewModel: ILibraryViewModel?
    private var subscriptions = Set<AnyCancellable>()
    private let onLoad = PassthroughSubject<Void, Never>()
    private let onViewWillAppear = PassthroughSubject<Void, Never>()
    private let onMakeStory = PassthroughSubject<Void, Never>()
    private let onDeleteMyStory = PassthroughSubject<MyStory, Never>()
    private let onSelectMyStory = PassthroughSubject<MyStory, Never>()

    private var myStories: [MyStory] = []

    // MARK: Life cycle
    convenience init() {
        self.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.onLoad.send()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.onViewWillAppear.send()
    }
    
    func setDependencies(viewModel: ILibraryViewModel?) {
        self.viewModel = viewModel
    }
    
    @IBAction func makeStoryButtonTapped(_ sender: UIButton) {
        self.impactFeedbackGenerator.impactOccurred()
        self.onMakeStory.send()
    }
}

// MARK: - Setup
private extension LibraryViewController {
    
    func setup() {
        self.setupUI()
        self.setupSubscriptions()
    }
    
    func setupUI() {
        self.titleLabel.text = L10n.Library.title
        self.emptyTitleLabel.text = L10n.Library.Empty.title
        self.emptyTitleLabel.setLineHeight(lineHeight: 0.70)
        self.emptySubtitleLabel.text = L10n.Library.Empty.subtitle
        self.tableView.registerNib(cellClass: LibraryTableViewCell.self)
        self.tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    func setupSubscriptions() {
        self.subscriptions.forEach { $0.cancel() }
        self.subscriptions.removeAll()
        
        let input = Library.Models.ViewModelInput(
            onLoad: self.onLoad.eraseToAnyPublisher(),
            onViewWillAppear: self.onViewWillAppear.eraseToAnyPublisher(),
            onMakeStory: self.onMakeStory.eraseToAnyPublisher(),
            onDeleteMyStory: self.onDeleteMyStory.eraseToAnyPublisher(),
            onSelectMyStory: self.onSelectMyStory.eraseToAnyPublisher()
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
    
    func handleState(_ state: Library.Models.ViewState) {
        switch state {
        case .idle:
            break
        }
    }

    func handleAction(_ action: Library.Models.ViewAction) {
        switch action {
        case .showMyStories(let myStories):
            self.myStories = myStories
            self.tableView.reloadData()
        case .showEmptyState(let show):
            let dur = 0.3
            DispatchQueue.main.asyncAfter(deadline: .now() + dur) { [weak self] in
                guard let self = self else { return }
                self.setView(view: self.emptyView, hidden: !show)
                self.setView(view: self.titleLabel, hidden: show)
                self.setView(view: self.separatorView, hidden: show)
                self.setView(view: self.tableView, hidden: show)
            }
        }
    }
    
    func handleRoute(_ route: Library.Models.ViewRoute) {
        switch route {
        case .selectionStepFlow:
            self.startSelectionStepFlow()
        case .story(let story):
            self.goToStory(story)
        case .subscription:
            self.showSubscription()
        }
    }
}

// MARK: - Navigation
private extension LibraryViewController {

    func startSelectionStepFlow() {
        let viewController = SelectionStep.Assembly.createModule(config: .initial)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
    func goToStory(_ story: MyStory) {
        let controller = Story.Assembly.createModule(config: .init(
            entryPoint: .library,
            story: story,
            saveButtonState: .hidden,
            backButtonState: .pop, 
            universe: story.universe)
        )
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showSubscription() {
        let controller = Subscription.Assembly.createModule(entryPoint: .makeStory, isDismissable: true)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
}

// MARK: - Private
private extension LibraryViewController {

    func setView(view: UIView, hidden: Bool) {
        let dur = 0.5
        UIView.transition(with: view, duration: dur, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
}

// MARK: - UITableViewDelegate
extension LibraryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.impactFeedbackGenerator.impactOccurred()
        let cell = tableView.cellForRow(at: indexPath)
        cell?.emitStars(duration: 0.2, fadeOutDuration: 0.3)
        let myStory = self.myStories[indexPath.row]
        self.onSelectMyStory.send(myStory)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        139
    }
}

// MARK: - UITableViewDataSource
extension LibraryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myStories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: LibraryTableViewCell.self, forIndexPath: indexPath)
        cell.myStory = self.myStories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let myStorie = self.myStories[indexPath.row]
        self.onDeleteMyStory.send(myStorie)
        self.myStories.remove(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}
