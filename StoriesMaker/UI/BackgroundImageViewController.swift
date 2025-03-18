//
//  BackgroundImageViewController.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 04/09/2023.
//

import UIKit

class BackgroundImageViewController: UIViewController {
    
    var backgroundImage: UIImage? {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = self.backgroundImage
        self.view = imageView
    }
}

