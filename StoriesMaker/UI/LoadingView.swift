//
//  LoadingView.swift
//  StoriesMaker
//
//  Created by borisenko on 22.09.2024.
//

import UIKit

final class LoadingView: UIView {
    
    static var identifier: String {
        String(describing: self)
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .large
        view.color = Asset.Colors.e7Ea73.color
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension LoadingView {
    
    func setup() {
        self.backgroundColor = Asset.Colors._262845.color.withAlphaComponent(0.6)
        self.addSubview(self.activityIndicator)
        
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.activityIndicator.startAnimating()
    }
}
