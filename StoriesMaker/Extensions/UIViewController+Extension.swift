//
//  UIViewController+Extension.swift
//  StoriesMaker
//
//  Created by borisenko on 22.09.2023.
//

import UIKit

extension UIViewController {
    
    func showErrorAlert(
        description: String?,
        onOk: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: L10n.Subscription.somethingWentWrong,
            message: description,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            self.impactFeedbackGenerator.impactOccurred()
            onOk?()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func showLoading() {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = LoadingView.identifier
        guard let window = UIApplication.shared.keyWindow else { return }
        window.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: window.topAnchor),
            view.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])
    }
    
    func hideLoading() {
        guard let window = UIApplication.shared.keyWindow,
              let view = window.subviews.first(
                where: { $0.accessibilityIdentifier == LoadingView.identifier }
              ) else { return }
        view.removeFromSuperview()
    }
}
