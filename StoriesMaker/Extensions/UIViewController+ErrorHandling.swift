//
//  UIViewController+ErrorHandling.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 21/09/2023.
//

import UIKit

extension UIViewController {
    
    func showCustomError(
        _ customError: CustomError,
        onOk: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: customError.cTitle,
            message: customError.cMessage,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            self.impactFeedbackGenerator.impactOccurred()
            onOk?()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
